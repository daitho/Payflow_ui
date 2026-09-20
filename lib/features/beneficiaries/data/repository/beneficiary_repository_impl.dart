import 'package:dio/dio.dart';
import '../../domain/model/beneficiary_contact.dart';
import '../../domain/exception/beneficiary_exception.dart';
import '../../domain/repository/beneficiary_repository.dart';
import '../service_api/beneficiary_api_service.dart';

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  final BeneficiaryApiService api;
  BeneficiaryRepositoryImpl(this.api);
  @override
  Future<List<BeneficiaryContact>> list() =>
      _guard(() async => (await api.list()).map((r) => r.toModel()).toList());
  @override
  Future<BeneficiaryContact> get(String id) =>
      _guard(() async => (await api.get(id)).toModel());
  @override
  Future<BeneficiaryCatalog> catalog() =>
      _guard(() async => (await api.catalog()).toModel());
  @override
  Future<BeneficiaryContact> save(
    BeneficiaryContactInput input, {
    String? id,
  }) => _guard(
    () async => (await api.save({
      'fullName': input.fullName,
      'countryId': input.countryId,
      'operatorId': input.operatorId,
      'phoneE164': input.phoneE164,
      'gender': switch (input.gender) {
        BeneficiaryGender.male => 'MALE',
        BeneficiaryGender.female => 'FEMALE',
        null => null,
      },
    }, id: id)).toModel(),
  );

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      throw BeneficiaryException(switch (e.response?.statusCode) {
        401 => BeneficiaryFailure.sessionExpired,
        400 || 409 || 422 => BeneficiaryFailure.invalid,
        404 => BeneficiaryFailure.notFound,
        null => BeneficiaryFailure.network,
        _ => BeneficiaryFailure.server,
      });
    } catch (_) {
      throw const BeneficiaryException(BeneficiaryFailure.server);
    }
  }
}
