import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';

import '../../domain/model/home_beneficiary_model.dart';

import '../../domain/model/home_transfer_model.dart';
import '../view_model/home_error_type.dart';
import '../view_model/home_view_model.dart';
import '../view_model/home_view_status.dart';

import '../widget/exchange_rate_card.dart';
import '../widget/home_header.dart';
import '../widget/recent_beneficiaries_section.dart';
import '../widget/recent_transactions_section.dart';

class HomeView extends StatefulWidget {
  // =========================================================
  // BENEFICIARY
  // =========================================================

  final HomeBeneficiaryModel? selectedBeneficiary;

  final ValueChanged<HomeBeneficiaryModel>
  onBeneficiarySelected;

  /*
   * Conservé pour rester compatible avec ton HomePage actuel.
   *
   * Visuellement nous n'affichons plus le bouton X dans le
   * bénéficiaire sélectionné, conformément à la maquette.
   */
  final VoidCallback onBeneficiaryCleared;

  // =========================================================
  // ACTIONS
  // =========================================================
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onExchangeRatesTap;
  final VoidCallback? onTransferTap;
  final VoidCallback? onSeeAllBeneficiaries;
  final VoidCallback? onViewAllTransactions;
  final VoidCallback? onMoreTransactions;
  final ValueChanged<HomeTransferModel>? onTransactionTap;

  const HomeView({
    super.key,
    required this.selectedBeneficiary,
    required this.onBeneficiarySelected,
    required this.onBeneficiaryCleared,
    this.onProfileTap,
    this.onNotificationsTap,
    this.onExchangeRatesTap,
    this.onTransferTap,
    this.onSeeAllBeneficiaries,
    this.onViewAllTransactions,
    this.onMoreTransactions,
    this.onTransactionTap,
  });

  @override
  State<HomeView> createState() =>
      _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        final HomeViewModel viewModel =
        context.read<HomeViewModel>();

        if (viewModel.status ==
            HomeViewStatus.initial) {
          viewModel.load();
        }
      },
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel =
    context.watch<HomeViewModel>();

    // =======================================================
    // FIRST LOADING
    // =======================================================

    if (viewModel.isLoading &&
        viewModel.home == null) {
      return const SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // =======================================================
    // FIRST ERROR
    // =======================================================

    if (viewModel.hasError &&
        viewModel.home == null) {
      return _HomeErrorView(
        errorType: viewModel.errorType,
        onRetry: viewModel.retry,
      );
    }

    final home = viewModel.home;

    if (home == null) {
      return const SizedBox.shrink();
    }

    // =======================================================
    // CONTENT
    // =======================================================

    return SafeArea(
      /*
       * Le header doit commencer sous :
       * - heure
       * - Dynamic Island
       * - zone système
       */
      top: true,

      /*
       * La bottom navigation appartient à HomePage
       * et flotte par-dessus HomeView.
       */
      bottom: false,

      child: RefreshIndicator(
        onRefresh: viewModel.load,

        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          /*
           * 14 px après SafeArea pour éviter que le header
           * soit trop collé en haut.
           *
           * 180 px en bas pour :
           * - le CTA "Transfert"
           * - la barre de navigation flottante
           */
          padding: const EdgeInsets.fromLTRB(
            20,
            14,
            20,
            180,
          ),

          children: [
            // =================================================
            // BACKGROUND REFRESH INDICATOR
            // =================================================

            if (viewModel.isLoading)
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 12,
                ),
                child: LinearProgressIndicator(
                  minHeight: 2,
                ),
              ),

            // =================================================
            // REFRESH ERROR WHILE OLD DATA REMAINS VISIBLE
            // =================================================

            if (viewModel.hasError)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 14,
                ),
                child: _InlineHomeError(
                  errorType:
                  viewModel.errorType,
                  onRetry:
                  viewModel.retry,
                ),
              ),

            // =================================================
            // HEADER
            // =================================================

            HomeHeader(
              user: home.user,
              onProfileTap:
              widget.onProfileTap,
              onNotificationsTap:
              widget.onNotificationsTap,
            ),

            const SizedBox(height: 28),

            // =================================================
            // EXCHANGE RATE
            // =================================================

            ExchangeRateCard(
              exchangeRate:
              home.exchangeRate,
              onTap:
              widget.onExchangeRatesTap,
            ),

            const SizedBox(height: 26),

            // =================================================
            // BENEFICIARIES
            // =================================================

            RecentBeneficiariesSection(
              beneficiaries:
              home.recentBeneficiaries,

              selectedBeneficiary:
              widget.selectedBeneficiary,

              onBeneficiaryTap:
              widget.onBeneficiarySelected,

              onSeeAll:
              widget.onSeeAllBeneficiaries,
            ),

            const SizedBox(height: 28),

            // =================================================
            // TRANSACTIONS
            // =================================================
            RecentTransactionsSection(
              transactions: home.recentTransactions,

              onViewAll:
              widget.onViewAllTransactions,
              onTransactionTap:
              widget.onTransactionTap,
            ),

            // =================================================
            // BOTTOM "SEE MORE"
            // =================================================

            /*
             * On conserve volontairement les deux accès
             * présents dans la maquette d'origine :
             *
             * 1. Voir plus dans le titre Historique
             * 2. Voir plus sous les transactions
             *
             * Les deux ouvriront plus tard l'historique complet.
             */

            if (home.recentTransactions.isNotEmpty) ...[
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed:
                  widget.onMoreTransactions,

                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                    const Color(
                      0xFFE96C15,
                    ),

                    side: const BorderSide(
                      color: Color(
                        0xFFE2DDDA,
                      ),
                    ),

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 13,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),

                  child: Text(
                    AppLocalizations.of(context)
                        .homeViewMoreTransactions,

                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ===========================================================
// FULL PAGE ERROR
// ===========================================================

class _HomeErrorView extends StatelessWidget {
  final HomeErrorType? errorType;

  final Future<void> Function() onRetry;

  const _HomeErrorView({
    required this.errorType,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
    AppLocalizations.of(context);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              // =================================================
              // ICON
              // =================================================

              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEEE3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  color: Color(0xFFE96C15),
                  size: 30,
                ),
              ),

              const SizedBox(height: 18),

              // =================================================
              // TITLE
              // =================================================

              Text(
                l10n.homeLoadErrorTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF302B28),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              // =================================================
              // MESSAGE
              // =================================================

              Text(
                _homeErrorMessage(
                  l10n,
                  errorType,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF847C78),
                  fontSize: 13.5,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // RETRY
              // =================================================

              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: Text(
                  l10n.homeRetry,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor:
                  const Color(
                    0xFFE96C15,
                  ),
                  foregroundColor:
                  Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// INLINE ERROR
// ===========================================================

class _InlineHomeError extends StatelessWidget {
  final HomeErrorType? errorType;

  final Future<void> Function() onRetry;

  const _InlineHomeError({
    required this.errorType,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
    AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(
          0xFFFFF2EA,
        ),
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFE96C15),
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              _homeErrorMessage(
                l10n,
                errorType,
              ),
              style: const TextStyle(
                color: Color(0xFF6D5A50),
                fontSize: 12.5,
              ),
            ),
          ),

          IconButton(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh_rounded,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// ERROR MESSAGE
// ===========================================================

String _homeErrorMessage(
    AppLocalizations l10n,
    HomeErrorType? type,
    ) {
  switch (type) {
    case HomeErrorType.network:
      return l10n.homeNetworkError;

    case HomeErrorType.timeout:
      return l10n.homeTimeoutError;

    case HomeErrorType.server:
      return l10n.homeServerError;

    case HomeErrorType.sessionExpired:
      return l10n.homeSessionExpiredError;

    case HomeErrorType.invalidResponse:
      return l10n.homeInvalidResponseError;

    case HomeErrorType.unexpected:
    case null:
      return l10n.homeUnexpectedError;
  }
}