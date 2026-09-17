import 'package:flutter/foundation.dart';

import '../../domain/exception/home_exception.dart';
import '../../domain/model/home_model.dart';
import '../../domain/service/home_service.dart';
import 'home_error_type.dart';
import 'home_view_status.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _service;

  HomeViewModel({required HomeService service}) : _service = service;

  // ============================================================
  // STATE
  // ============================================================

  HomeModel? _home;

  HomeViewStatus _status = HomeViewStatus.initial;

  HomeErrorType? _errorType;

  bool _requestInProgress = false;

  // ============================================================
  // GETTERS
  // ============================================================

  HomeModel? get home => _home;

  HomeViewStatus get status => _status;

  HomeErrorType? get errorType => _errorType;

  bool get isInitial => _status == HomeViewStatus.initial;

  bool get isLoading => _status == HomeViewStatus.loading;

  bool get hasData => _home != null;

  bool get hasError => _status == HomeViewStatus.failure;

  bool get isSuccess => _status == HomeViewStatus.success;

  // ============================================================
  // LOAD
  // ============================================================

  Future<void> load() async {
    /*
     * Empêche deux appels /home simultanés,
     * par exemple :
     *
     * initState
     * +
     * double rebuild accidentel.
     */
    if (_requestInProgress) {
      return;
    }

    _requestInProgress = true;

    _status = HomeViewStatus.loading;
    _errorType = null;

    notifyListeners();

    try {
      final HomeModel result = await _service.getHome();

      _home = result;

      _status = HomeViewStatus.success;

      _errorType = null;
    } on HomeNetworkException {
      _handleFailure(HomeErrorType.network);
    } on HomeTimeoutException {
      _handleFailure(HomeErrorType.timeout);
    } on HomeServerException {
      _handleFailure(HomeErrorType.server);
    } on HomeSessionExpiredException {
      _handleFailure(HomeErrorType.sessionExpired);
    } on HomeInvalidResponseException {
      _handleFailure(HomeErrorType.invalidResponse);
    } on HomeUnexpectedException {
      _handleFailure(HomeErrorType.unexpected);
    } catch (_) {
      /*
       * Sécurité ultime :
       *
       * aucune exception imprévue ne doit faire
       * planter directement la View.
       */
      _handleFailure(HomeErrorType.unexpected);
    } finally {
      _requestInProgress = false;

      notifyListeners();
    }
  }

  // ============================================================
  // RETRY
  // ============================================================

  Future<void> retry() {
    return load();
  }

  // ============================================================
  // FAILURE
  // ============================================================

  void _handleFailure(HomeErrorType errorType) {
    _status = HomeViewStatus.failure;

    _errorType = errorType;
  }
}
