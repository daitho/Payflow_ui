import 'home_beneficiary_model.dart';
import 'home_exchange_rate_model.dart';
import 'home_transfer_model.dart';
import 'home_user_model.dart';

class HomeModel {
  final HomeUserModel user;

  final HomeExchangeRateModel? exchangeRate;

  final List<HomeBeneficiaryModel> recentBeneficiaries;

  final List<HomeTransferModel> recentTransactions;

  const HomeModel({
    required this.user,
    required this.exchangeRate,
    required this.recentBeneficiaries,
    required this.recentTransactions,
  });
}
