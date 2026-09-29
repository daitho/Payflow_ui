import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/beneficiaries/data/repository/beneficiary_repository_impl.dart';
import 'package:pay_flow_ui/features/beneficiaries/data/service_api/beneficiary_api_service.dart';

class _DestinationAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  bool existingWave = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = options.method == 'GET'
        ? [
            {
              'id': 'primary-id',
              'operatorId': 'orange-id',
              'phoneE164': '+221770000000',
              'primaryDestination': true,
            },
            if (existingWave)
              {
                'id': 'wave-id',
                'operatorId': 'wave-id-operator',
                'phoneE164': '+221770000000',
                'primaryDestination': false,
              },
          ]
        : {
            'id': 'wave-id',
            'operatorId': 'wave-id-operator',
            'primaryDestination': false,
          };
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(body)),
      options.method == 'GET' ? 200 : 201,
      headers: {Headers.contentTypeHeader: ['application/json']},
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('reuse Wave destination or create it as non-primary', () async {
    final adapter = _DestinationAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://payflow.test'))
      ..httpClientAdapter = adapter;
    final repository = BeneficiaryRepositoryImpl(BeneficiaryApiService(dio));

    Future<String> ensure() => repository.ensureSecondaryDestination(
      beneficiaryId: 'beneficiary-id',
      operatorId: 'wave-id-operator',
      phoneE164: '+221770000000',
    );

    expect(await ensure(), 'wave-id');
    expect(adapter.requests.map((request) => request.method), ['GET', 'POST']);
    expect(
      adapter.requests.last.data,
      {
        'operatorId': 'wave-id-operator',
        'phoneE164': '+221770000000',
        'primaryDestination': false,
      },
    );
    expect(
      adapter.requests.last.path,
      '/api/v1/beneficiaries/beneficiary-id/destinations/create',
    );

    adapter.existingWave = true;
    expect(await ensure(), 'wave-id');
    expect(adapter.requests.last.method, 'GET');
    expect(adapter.requests.length, 3);
    dio.close(force: true);
  });
}
