import 'package:dio/dio.dart';
import '../domain/mobile_money_sandbox_funding.dart';
import '../../transfer/domain/exception/transfer_exception.dart';

class PawaPaySandboxFundingService implements MobileMoneySandboxFunding {
  final Dio _dio;
  const PawaPaySandboxFundingService(this._dio);
  static const _path = '/api/v1/payments/pawapay-sandbox';
  @override
  Future<MobileMoneyFundingOptions> options() => _guard(() async {
    final data = (await _dio.get<Map<String, dynamic>>('$_path/options')).data!;
    return MobileMoneyFundingOptions(enabled: data['enabled'] == true,
      sourceCurrency: data['sourceCurrency'] as String?,
      activePayment: data['activePayment'] == null ? null : _progress(Map<String,dynamic>.from(data['activePayment'] as Map)),
      providers: (data['providers'] as List).map((raw) {
        final p = Map<String,dynamic>.from(raw as Map);
        return MobileMoneyFundingOption(provider: p['provider'] as String,
          label: p['label'] as String, countryCode: p['countryCode'] as String,
          currency: p['currency'] as String, maskedPhone: p['maskedPhone'] as String);
      }).toList(growable: false));
  });
  @override
  Future<MobileMoneyFundingProgress> start({required String quoteId,
      required String provider, required String idempotencyKey}) => _guard(() async {
    final data = (await _dio.post<Map<String,dynamic>>(_path,
      data: {'quoteId': quoteId, 'provider': provider},
      options: Options(headers: {'Idempotency-Key': idempotencyKey}))).data!;
    return _progress(data);
  });
  @override
  Future<MobileMoneyFundingProgress> progress(String paymentId) => _guard(() async =>
    _progress((await _dio.get<Map<String,dynamic>>('$_path/$paymentId')).data!));
  MobileMoneyFundingProgress _progress(Map<String,dynamic> data) {
    if (data['sandbox'] != true) throw const TransferException(TransferFailure.invalidResponse);
    return MobileMoneyFundingProgress(paymentIntentId: data['paymentIntentId'] as String,
      status: data['status'] as String, depositId: data['depositId'] as String,
      depositStatus: data['depositStatus'] as String, bankStatus: data['bankStatus'] as String,
      maskedIban: data['maskedIban'] as String, transferId: data['transferId'] as String?);
  }
  Future<T> _guard<T>(Future<T> Function() run) async {
    try { return await run(); }
    on DioException catch(e) {
      throw TransferException(switch(e.response?.statusCode) {
        401 => TransferFailure.sessionExpired,
        409 => TransferFailure.conflict,
        422 => TransferFailure.invalid,
        503 => TransferFailure.providerUnavailable,
        _ => e.response == null ? TransferFailure.network : TransferFailure.server,
      });
    }
  }
}
