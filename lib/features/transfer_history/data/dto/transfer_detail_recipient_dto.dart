final class TransferDetailRecipientDto {
  // ===========================================================
  // BENEFICIARY
  // ===========================================================

  final String beneficiaryId;
  final String beneficiaryName;

  // ===========================================================
  // COUNTRY
  // ===========================================================

  final String countryId;
  final String countryIsoCode2;
  final String? countryFlagUrl;

  // ===========================================================
  // DESTINATION
  // ===========================================================

  final String destinationId;
  final String? phoneE164;
  final String? maskedReference;

  // ===========================================================
  // OPERATOR
  // ===========================================================

  final String operatorId;
  final String operatorCode;
  final String operatorName;
  final String? operatorType;
  final String? operatorLogoUrl;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================

  const TransferDetailRecipientDto({
    required this.beneficiaryId,
    required this.beneficiaryName,
    required this.countryId,
    required this.countryIsoCode2,
    required this.countryFlagUrl,
    required this.destinationId,
    required this.phoneE164,
    required this.maskedReference,
    required this.operatorId,
    required this.operatorCode,
    required this.operatorName,
    required this.operatorType,
    required this.operatorLogoUrl,
  });

  // ===========================================================
  // JSON
  // ===========================================================

  factory TransferDetailRecipientDto.fromJson(Map<String, dynamic> json) {
    return TransferDetailRecipientDto(
      // -------------------------------------------------------
      // BENEFICIARY
      // -------------------------------------------------------
      beneficiaryId: json['beneficiaryId'] as String,
      beneficiaryName: json['beneficiaryName'] as String,

      // -------------------------------------------------------
      // COUNTRY
      // -------------------------------------------------------
      countryId: json['countryId'] as String,
      countryIsoCode2: json['countryIsoCode2'] as String,
      countryFlagUrl: json['countryFlagUrl'] as String?,

      // -------------------------------------------------------
      // DESTINATION
      // -------------------------------------------------------
      destinationId: json['destinationId'] as String,
      phoneE164: json['phoneE164'] as String?,
      maskedReference: json['maskedReference'] as String?,

      // -------------------------------------------------------
      // OPERATOR
      // -------------------------------------------------------
      operatorId: json['operatorId'] as String,
      operatorCode: json['operatorCode'] as String,
      operatorName: json['operatorName'] as String,
      operatorType: json['operatorType'] as String?,
      operatorLogoUrl: json['operatorLogoUrl'] as String?,
    );
  }
}
