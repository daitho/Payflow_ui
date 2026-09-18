import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/transfer_history/data/service_api/transfer_history_api_service_impl.dart';

class RecordingAdapter implements HttpClientAdapter {
  RequestOptions? request;
  List<int> bytes = [37, 80, 68, 70, 45, 49, 46, 55];
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    request = options;
    return ResponseBody.fromBytes(bytes, 200,
      headers: {Headers.contentTypeHeader: ['application/pdf']});
  }
  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late RecordingAdapter adapter;
  late TransferHistoryApiServiceImpl api;
  setUp(() {
    adapter = RecordingAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://payflow.test'));
    dio.httpClientAdapter = adapter;
    api = TransferHistoryApiServiceImpl(dio: dio);
  });
  tearDown(() => dio.close(force: true));

  test('statement forwards both filters and language, without pagination', () async {
    final bytes = await api.getStatement(
      beneficiaryId: 'alice', status: 'COMPLETED', locale: 'fr-FR');
    expect(adapter.request!.path, '/api/v1/transfers/history/export/pdf');
    expect(adapter.request!.queryParameters, {
      'beneficiaryId': 'alice', 'status': 'COMPLETED',
      'locale': 'fr-FR', 'download': true,
    });
    expect(bytes, adapter.bytes);
  });

  test('all-transfers export omits optional filters', () async {
    await api.getStatement(locale: 'en');
    expect(adapter.request!.queryParameters, {'locale': 'en', 'download': true});
  });

  test('receipt sends the transfer identifier and requests attachment', () async {
    await api.getReceipt(transferId: 'transfer-1', locale: 'fr', download: true);
    expect(adapter.request!.path, '/api/v1/transfers/receipt/transfer-1');
    expect(adapter.request!.queryParameters, {'locale': 'fr', 'download': true});
  });

  test('JSON disguised as successful PDF response is rejected', () async {
    adapter.bytes = '{"error":"unavailable"}'.codeUnits;
    await expectLater(api.getStatement(locale: 'fr'), throwsStateError);
    await expectLater(api.getReceipt(transferId: 'transfer-1'), throwsStateError);
  });
}
