import '../../../../l10n/app_localizations.dart';
import '../../domain/exception/beneficiary_exception.dart';

String beneficiaryError(AppLocalizations l10n, BeneficiaryFailure failure) => switch (failure) {
  BeneficiaryFailure.network => l10n.contactNetworkError,
  BeneficiaryFailure.sessionExpired => l10n.contactSessionError,
  BeneficiaryFailure.invalid => l10n.contactInvalidError,
  BeneficiaryFailure.notFound => l10n.contactNotFoundError,
  BeneficiaryFailure.server => l10n.contactServerError,
};
