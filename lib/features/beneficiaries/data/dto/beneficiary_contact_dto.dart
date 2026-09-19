import '../../domain/model/beneficiary_contact.dart';

class BeneficiaryContactDto {
  final Map<String, dynamic> json;
  BeneficiaryContactDto(this.json);
  BeneficiaryContact toModel() => BeneficiaryContact(
    id: json['id'] as String, fullName: json['fullName'] as String,
    countryId: json['countryId'] as String, countryName: json['countryName'] as String,
    countryCode: json['countryCode'] as String,
    destinationId: json['destinationId'] as String?, operatorId: json['operatorId'] as String?,
    operatorName: json['operatorName'] as String?, phoneE164: json['phoneE164'] as String?,
    currencyCode: json['currencyCode'] as String?, favorite: json['favorite'] as bool? ?? false,
    gender: switch (json['gender']) {
      'MALE' => BeneficiaryGender.male, 'FEMALE' => BeneficiaryGender.female, _ => null,
    },
  );
}

class BeneficiaryCatalogDto {
  final Map<String, dynamic> json;
  BeneficiaryCatalogDto(this.json);
  BeneficiaryCatalog toModel() => BeneficiaryCatalog(
    (json['countries'] as List).map((r) => BeneficiaryCountry(
      r['id'] as String, r['name'] as String, r['isoCode'] as String,
      r['phoneCode'] as String)).toList(),
    (json['operators'] as List).map((r) => BeneficiaryOperator(
      r['id'] as String, r['countryId'] as String, r['name'] as String,
      r['currencyCode'] as String)).toList(),
  );
}
