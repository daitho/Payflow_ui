import '../../domain/model/home_beneficiary_model.dart';
import '../../domain/model/home_exchange_rate_model.dart';
import '../../domain/model/home_exchange_rate_source.dart';
import '../../domain/model/home_model.dart';
import '../../domain/model/home_transfer_model.dart';
import '../../domain/model/home_transfer_status.dart';
import '../../domain/model/home_user_model.dart';
import '../dto/home_beneficiary_dto.dart';
import '../dto/home_dto.dart';
import '../dto/home_exchange_rate_dto.dart';
import '../dto/home_transfer_dto.dart';
import '../dto/home_user_dto.dart';

class HomeMapper {
  const HomeMapper._();

  static HomeModel toModel(HomeDto dto) {
    return HomeModel(
      user: _mapUser(dto.user),
      exchangeRate: dto.exchangeRate == null
          ? null
          : _mapExchangeRate(dto.exchangeRate!),
      recentBeneficiaries: dto.recentBeneficiaries
          .map(_mapBeneficiary)
          .toList(),
      recentTransactions: dto.recentTransactions.map(_mapTransfer).toList(),
    );
  }

  static HomeUserModel _mapUser(HomeUserDto dto) {
    return HomeUserModel(
      publicId: dto.publicId,
      firstName: dto.firstName,
      lastName: dto.lastName,
      verified: dto.verified,
    );
  }

  static HomeExchangeRateModel _mapExchangeRate(HomeExchangeRateDto dto) {
    return HomeExchangeRateModel(
      sourceCountryIsoCode2: dto.sourceCountryIsoCode2,
      sourceCountryFlagUrl: dto.sourceCountryFlagUrl,
      targetCountryIsoCode2: dto.targetCountryIsoCode2,
      targetCountryFlagUrl: dto.targetCountryFlagUrl,
      sourceCurrencyCode: dto.sourceCurrencyCode,
      sourceCurrencyName: dto.sourceCurrencyName,
      sourceCurrencySymbol: dto.sourceCurrencySymbol,
      targetCurrencyCode: dto.targetCurrencyCode,
      targetCurrencyName: dto.targetCurrencyName,
      targetCurrencySymbol: dto.targetCurrencySymbol,
      rate: dto.rate,
      rateAt: dto.rateAt,
      source: HomeExchangeRateSource.fromApi(dto.source),
    );
  }

  static HomeBeneficiaryModel _mapBeneficiary(HomeBeneficiaryDto dto) {
    return HomeBeneficiaryModel(
      id: dto.id,
      displayName: dto.displayName,
      countryId: dto.countryId,
      countryIsoCode2: dto.countryIsoCode2,
      countryFlagUrl: dto.countryFlagUrl,
      phoneE164: dto.phoneE164,
      operatorName: dto.operatorName,
      favorite: dto.favorite,
    );
  }

  static HomeTransferModel _mapTransfer(HomeTransferDto dto) {
    return HomeTransferModel(
      id: dto.id,
      reference: dto.reference,
      beneficiaryId: dto.beneficiaryId,
      beneficiaryName: dto.beneficiaryName,
      sentAmount: dto.sentAmount,
      receivedAmount: dto.receivedAmount,
      sourceCurrencyId: dto.sourceCurrencyId,
      sourceCurrencyCode: dto.sourceCurrencyCode,
      sourceCurrencySymbol: dto.sourceCurrencySymbol,
      targetCurrencyId: dto.targetCurrencyId,
      targetCurrencyCode: dto.targetCurrencyCode,
      targetCurrencySymbol: dto.targetCurrencySymbol,
      status: HomeTransferStatus.fromApi(dto.status),
      createdAt: dto.createdAt,
      finalizedAt: dto.finalizedAt,
    );
  }
}
