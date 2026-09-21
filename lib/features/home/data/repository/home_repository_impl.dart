import 'package:dio/dio.dart';

import '../../domain/exception/home_exception.dart';
import '../../domain/model/home_model.dart';
import '../../domain/repository/home_repository.dart';
import '../mapper/home_mapper.dart';
import '../service_api/home_repository_impl.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService _apiService;

  const HomeRepositoryImpl({required HomeApiService apiService})
    : _apiService = apiService;

  // ============================================================
  // GET HOME
  // ============================================================

  @override
  Future<HomeModel> getHome() async {
    try {
      final dto = await _apiService.getHome();

      return HomeMapper.toModel(dto);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw HomeInvalidResponseException(cause: error);
    } on TypeError catch (error) {
      throw HomeInvalidResponseException(cause: error);
    } on HomeException {
      rethrow;
    } catch (error) {
      throw HomeUnexpectedException(cause: error);
    }
  }

  // ============================================================
  // DIO ERROR MAPPING
  // ============================================================

  HomeException _mapDioException(DioException error) {
    switch (error.type) {
      // --------------------------------------------------------
      // TIMEOUTS
      // --------------------------------------------------------

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return HomeTimeoutException(cause: error);

      // --------------------------------------------------------
      // NO NETWORK / SERVER UNREACHABLE
      // --------------------------------------------------------

      case DioExceptionType.connectionError:
        return HomeNetworkException(cause: error);

      // --------------------------------------------------------
      // HTTP RESPONSE RECEIVED
      // --------------------------------------------------------

      case DioExceptionType.badResponse:
        return _mapBadResponse(error);

      // --------------------------------------------------------
      // OTHER TECHNICAL ERRORS
      // --------------------------------------------------------

      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return HomeUnexpectedException(cause: error);
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  // ============================================================
  // HTTP ERROR MAPPING
  // ============================================================

  HomeException _mapBadResponse(DioException error) {
    final int? statusCode = error.response?.statusCode;

    /*
     * Le AuthInterceptor est normalement responsable :
     *
     * 401
     *   ↓
     * refresh token
     *   ↓
     * retry
     *
     * Si un 401 arrive malgré tout jusqu'ici,
     * la session n'est plus exploitable.
     *
     * Le Repository ne fait aucune navigation et
     * ne supprime pas lui-même la session.
     */
    if (statusCode == 401 || statusCode == 403) {
      return HomeSessionExpiredException(cause: error);
    }

    /*
     * Le serveur a répondu mais la requête Home
     * n'a pas abouti correctement.
     */
    return HomeServerException(statusCode: statusCode, cause: error);
  }
}
