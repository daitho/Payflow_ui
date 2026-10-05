import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/beneficiaries/data/dto/beneficiary_contact_dto.dart';

void main() {
  test('catalog marks network-independent services and reads legacy Wave', () {
    final catalog = BeneficiaryCatalogDto({
      'countries': <Object>[],
      'operators': [
        {
          'id': 'orange', 'countryId': 'sn', 'name': 'Orange Money',
          'currencyCode': 'XOF', 'networkIndependent': false,
        },
        {
          'id': 'wave', 'countryId': 'sn', 'name': 'Wave',
          'currencyCode': 'XOF',
        },
        {
          'id': 'wallet', 'countryId': 'sn', 'name': 'Other Wallet',
          'currencyCode': 'XOF', 'networkIndependent': true,
        },
      ],
    }).toModel();

    expect(catalog.operators.map((o) => o.networkIndependent),
        [false, true, true]);
  });
}
