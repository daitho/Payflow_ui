enum BeneficiaryFailure { network, sessionExpired, invalid, notFound, server }
class BeneficiaryException implements Exception {
  final BeneficiaryFailure failure;
  const BeneficiaryException(this.failure);
}
