import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/transfer/data/dto/transfer_quote_dto.dart';
import 'package:pay_flow_ui/features/transfer/data/repository/transfer_repository_impl.dart';
import 'package:pay_flow_ui/features/transfer/data/service_api/transfer_api_service.dart';
import 'package:pay_flow_ui/features/transfer/domain/exception/transfer_exception.dart';

class QuoteErrorApi extends TransferApiService {
  QuoteErrorApi(this.status, this.code) : super(Dio());
  final int status;
  final String? code;
  @override
  Future<TransferQuoteDto> createQuote({
    required String beneficiaryId,
    required String destinationId,
    num? sentAmount,
    num? receivedAmount,
    required String sentCurrency,
  }) async {
    final request = RequestOptions(path: '/api/v1/transfer-quotes');
    throw DioException(
      requestOptions: request,
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: request, statusCode: status,
        data: <String, dynamic>{if (code != null) 'code': code}),
    );
  }
}

void main() {
  Future<void> expectFailure(int status, String? code, TransferFailure failure) async {
    final repository = TransferRepositoryImpl(QuoteErrorApi(status, code));
    await expectLater(repository.createQuote(
      beneficiaryId: 'active-beneficiary', destinationId: 'active-destination',
      sentAmount: 10, sentCurrency: 'EUR'),
      throwsA(isA<TransferException>().having((e) => e.failure, 'failure', failure)));
  }
  test('a payout catalogue error never declares the beneficiary missing', () async {
    for (final code in ['PAYMENT_OPERATOR_NOT_AVAILABLE', 'PAYMENT_OPERATOR_NOT_FOUND', 'COUNTRY_OPERATOR_NOT_FOUND']) {
      await expectFailure(404, code, TransferFailure.payoutUnavailable);
    }
  });
  test('gateway outage and missing configuration remain provider failures', () async {
    await expectFailure(503, 'PAYMENT_001', TransferFailure.providerUnavailable);
    await expectFailure(502, 'PAYMENT_002', TransferFailure.providerUnavailable);
    await expectFailure(503, null, TransferFailure.providerUnavailable);
    await expectFailure(404, null, TransferFailure.server);
    await expectFailure(404, 'PAYMENT_003', TransferFailure.conflict);
  });
  test('only authoritative beneficiary codes show a missing beneficiary', () async {
    await expectFailure(404, 'BENEFICIARY_NOT_FOUND', TransferFailure.notFound);
    await expectFailure(404, 'BEN_002', TransferFailure.notFound);
  });
  test('amount limits keep their specific feedback', () async {
    await expectFailure(422, 'QUOTE_008', TransferFailure.amountBelowMinimum);
    await expectFailure(422, 'QUOTE_009', TransferFailure.amountAboveMaximum);
  });
  test('payment verification failure is distinct from an already confirmed transfer', () async {
    await expectFailure(409, 'PAYMENT_008', TransferFailure.paymentNotCompleted);
    await expectFailure(409, 'QUOTE_003', TransferFailure.conflict);
    await expectFailure(409, null, TransferFailure.conflict);
  });
}
