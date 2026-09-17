import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/domain/exception/session_expired_exception.dart';
import '../../features/auth/domain/model/auth_session_model.dart';
import '../../features/auth/domain/service/refresh_service.dart';
import '../service/session_service.dart';
import 'api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  // =========================================================
  // RETRY FLAG
  // =========================================================
  static const String _retryKey = 'payflow.auth.alreadyRetried';

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[AUTH-INTERCEPTOR] $message');
    }
  }

  // =========================================================
  // DEPENDENCIES
  // =========================================================
  final Dio _dio;
  final SessionService _sessionService;
  final RefreshService _refreshService;

  AuthInterceptor({
    required Dio dio,
    required SessionService sessionService,
    required RefreshService refreshService,
  }) : _dio = dio,
       _sessionService = sessionService,
       _refreshService = refreshService;

  // =========================================================
  // SINGLE REFRESH LOCK
  // =========================================================
  Future<AuthSessionModel>? _refreshFuture;

  // =========================================================
  // REQUEST
  // =========================================================
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Login / Register / Refresh ne nécessitent pas
    // notre access token PayFlow.
    if (_isPublicAuthRequest(options)) {
      handler.next(options);
      return;
    }
    final String? accessToken = _sessionService.accessToken;
    /*if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
     */
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';

      _debugLog('Bearer attached: ${options.path}');
    }
    handler.next(options);
  }

  // =========================================================
  // ERROR
  // =========================================================
  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final RequestOptions request = error.requestOptions;
    // =======================================================
    // 1. PAS UN 401
    // =======================================================
    if (error.response?.statusCode != 401) {
      handler.next(error);
      return;
    }
    _debugLog('401 intercepted: ${request.path}');
    // =======================================================
    // 2. LOGIN / REGISTER / REFRESH
    //
    // Un 401 sur /login est par exemple simplement
    // "identifiants incorrects".
    //
    // Il ne faut surtout pas lancer un refresh.
    // =======================================================
    if (_isPublicAuthRequest(request)) {
      handler.next(error);
      return;
    }
    // =======================================================
    // 3. LA REQUÊTE A DÉJÀ ÉTÉ REJOUÉE
    //
    // Protection anti boucle infinie.
    // =======================================================
    if (request.extra[_retryKey] == true) {
      handler.next(error);
      return;
    }
    try {
      // =====================================================
      // 4. VÉRIFIER SI UN AUTRE REFRESH A DÉJÀ EU LIEU
      // =====================================================
      final String? currentAccessToken = _sessionService.accessToken;
      final String? failedAccessToken = _extractBearerToken(
        request.headers['Authorization'],
      );

      /*
       * Cas important :
       *
       * Requête A -> 401
       * Requête A déclenche refresh
       * R1 -> R2 + nouvel access token
       *
       * Requête B avait été envoyée avant le refresh,
       * mais son 401 arrive quelques millisecondes après.
       *
       * Dans ce cas, on NE REFRESH PAS une deuxième fois.
       * On rejoue directement B avec le token déjà renouvelé.
       */
      if (currentAccessToken != null &&
          currentAccessToken.isNotEmpty &&
          failedAccessToken != null &&
          failedAccessToken != currentAccessToken) {
        final Response<dynamic> response = await _retryRequest(
          request: request,
          accessToken: currentAccessToken,
        );
        handler.resolve(response);
        return;
      }

      // =====================================================
      // 5. UN SEUL REFRESH POUR TOUS LES 401 SIMULTANÉS
      // =====================================================
      final AuthSessionModel session = await _refreshSessionOnce();

      // =====================================================
      // 6. REJOUER LA REQUÊTE ORIGINALE
      // =====================================================
      final Response<dynamic> response = await _retryRequest(
        request: request,
        accessToken: session.accessToken,
      );
      handler.resolve(response);
    }
    // =======================================================
    // REFRESH TOKEN INVALIDE / EXPIRÉ / RÉVOQUÉ / RÉUTILISÉ
    // =======================================================
    on SessionExpiredException {
      await _sessionService.clearSession();
      /*
       * La navigation vers Login sera gérée
       * plus tard par AuthGuard / Router.
       *
       * L'interceptor réseau ne connaît pas GoRouter.
       */
      handler.next(error);
    }
    // =======================================================
    // ERREUR TECHNIQUE PENDANT LE REFRESH
    // =======================================================
    on DioException catch (refreshError) {
      /*
       * IMPORTANT :
       *
       * 500 / timeout / réseau pendant le refresh
       * ne doivent PAS supprimer le refresh token.
       */
      handler.reject(refreshError);
    }
    // =======================================================
    // AUTRE ERREUR INATTENDUE
    // =======================================================
    catch (_) {
      /*
       * On conserve également la session locale.
       */
      handler.next(error);
    }
  }

  // =========================================================
  // SINGLE REFRESH
  // =========================================================
  Future<AuthSessionModel> _refreshSessionOnce() async {
    /*
     * Un refresh est déjà en cours.
     *
     * Tous les autres 401 attendent exactement
     * le même Future.
     */
    final Future<AuthSessionModel>? existingRefresh = _refreshFuture;
    /*if (existingRefresh != null) {
      return existingRefresh;
    }*/
    if (existingRefresh != null) {
      _debugLog('Waiting for refresh already in progress');

      return existingRefresh;
    }
    _debugLog('Starting token refresh');
    final Future<AuthSessionModel> refresh = _performRefresh();
    _refreshFuture = refresh;
    try {
      return await refresh;
    } finally {
      /*
       * Libération du verrou.
       */
      if (identical(_refreshFuture, refresh)) {
        _refreshFuture = null;
      }
    }
  }

  // =========================================================
  // PERFORM REFRESH
  // =========================================================

  Future<AuthSessionModel> _performRefresh() async {
    final String? refreshToken = await _sessionService.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const SessionExpiredException();
    }
    final AuthSessionModel session = await _refreshService.refresh(
      refreshToken: refreshToken,
    );

    /*
     * Backend :
     *
     * R1 -> R2
     *
     * Il faut donc persister R2 immédiatement.
     */
    await _sessionService.saveSession(session);
    _debugLog('Refresh successful - new session tokens saved');
    return session;
  }

  // =========================================================
  // RETRY ORIGINAL REQUEST
  // =========================================================
  Future<Response<dynamic>> _retryRequest({
    required RequestOptions request,
    required String accessToken,
  }) async {
    /*
     * Marque la requête comme déjà rejouée.
     *
     * Si le backend répond encore 401 :
     * aucun nouveau refresh.
     */
    request.extra[_retryKey] = true;
    request.headers['Authorization'] = 'Bearer $accessToken';
    _debugLog('Retrying original request: ${request.path}');
    return _dio.fetch<dynamic>(request);
  }

  // =========================================================
  // EXTRACT BEARER TOKEN
  // =========================================================
  String? _extractBearerToken(Object? authorizationHeader) {
    if (authorizationHeader == null) {
      return null;
    }
    final String value = authorizationHeader.toString();
    const String prefix = 'Bearer ';
    if (!value.startsWith(prefix)) {
      return null;
    }
    final String token = value.substring(prefix.length);
    if (token.isEmpty) {
      return null;
    }
    return token;
  }

  // =========================================================
  // PUBLIC AUTH ENDPOINTS
  // =========================================================
  bool _isPublicAuthRequest(RequestOptions options) {
    final String path = options.path;

    return path.endsWith(ApiEndpoints.authLogin) ||
        path.endsWith(ApiEndpoints.authRegister) ||
        path.endsWith(ApiEndpoints.authRefresh);
  }
}
