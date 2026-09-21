import 'home_beneficiary_dto.dart';
import 'home_exchange_rate_dto.dart';
import 'home_transfer_dto.dart';
import 'home_user_dto.dart';

class HomeDto {
  final HomeUserDto user;

  final HomeExchangeRateDto? exchangeRate;

  final List<HomeBeneficiaryDto> recentBeneficiaries;

  final List<HomeTransferDto> recentTransactions;

  const HomeDto({
    required this.user,
    required this.exchangeRate,
    required this.recentBeneficiaries,
    required this.recentTransactions,
  });

  factory HomeDto.fromJson(Map<String, dynamic> json) {
    final dynamic rawExchangeRate = json['exchangeRate'];

    final List<dynamic> rawBeneficiaries =
        json['recentBeneficiaries'] as List<dynamic>? ?? const [];

    final List<dynamic> rawTransactions =
        json['recentTransactions'] as List<dynamic>? ?? const [];

    return HomeDto(
      user: HomeUserDto.fromJson(json['user'] as Map<String, dynamic>),

      exchangeRate: rawExchangeRate == null
          ? null
          : HomeExchangeRateDto.fromJson(
              rawExchangeRate as Map<String, dynamic>,
            ),

      recentBeneficiaries: rawBeneficiaries
          .map(
            (item) => HomeBeneficiaryDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),

      recentTransactions: rawTransactions
          .map((item) => HomeTransferDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
