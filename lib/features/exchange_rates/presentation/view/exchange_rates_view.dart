import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../view_model/exchange_rates_view_model.dart';
import '../widget/exchange_rate_tile.dart';

class ExchangeRatesView extends StatefulWidget {
  const ExchangeRatesView({super.key});

  @override
  State<ExchangeRatesView> createState() => _ExchangeRatesViewState();
}

class _ExchangeRatesViewState extends State<ExchangeRatesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final ExchangeRatesViewModel viewModel = context
          .read<ExchangeRatesViewModel>();

      if (viewModel.status == ExchangeRatesViewStatus.initial) {
        viewModel.load();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ExchangeRatesViewModel viewModel = context
        .watch<ExchangeRatesViewModel>();

    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      body: SafeArea(
        child: Column(
          children: [
            // ===============================================
            // HEADER
            // ===============================================

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: SizedBox(
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20,
                                color: Color(0xFF514843),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Text(
                      l10n.exchangeRatesTitle,
                      style: const TextStyle(
                        color: Color(0xFF272321),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===============================================
            // SEARCH
            // ===============================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: TextField(
                controller: _searchController,
                onChanged: viewModel.search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.exchangeRatesSearchHint,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 21,
                    color: Color(0xFF7A7470),
                  ),
                  suffixIcon: viewModel.query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();

                            viewModel.clearSearch();
                          },
                          icon: const Icon(Icons.close_rounded, size: 19),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8E3E0),
                      width: 0.8,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFF008B80),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            // ===============================================
            // SILENT REFRESH
            // ===============================================
            if (viewModel.isRefreshing)
              const LinearProgressIndicator(minHeight: 2),

            // ===============================================
            // REFRESH ERROR WITH OLD DATA
            // ===============================================
            if (viewModel.refreshFailed)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 17,
                      color: Color(0xFF8B6C38),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        l10n.exchangeRatesRefreshError,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF655E5A),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: viewModel.retry,
                      icon: const Icon(Icons.refresh_rounded, size: 19),
                    ),
                  ],
                ),
              ),

            // ===============================================
            // CONTENT
            // ===============================================
            Expanded(child: _buildContent(context, viewModel)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ExchangeRatesViewModel viewModel) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    // =======================================================
    // INITIAL LOADING
    // =======================================================

    if (viewModel.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // =======================================================
    // INITIAL ERROR
    // =======================================================

    if (viewModel.hasInitialError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 38,
                color: Color(0xFF8A8480),
              ),

              const SizedBox(height: 12),

              Text(
                l10n.exchangeRatesLoadError,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF655E5A), fontSize: 14),
              ),

              const SizedBox(height: 14),

              OutlinedButton(
                onPressed: viewModel.retry,
                child: Text(l10n.exchangeRatesRetry),
              ),
            ],
          ),
        ),
      );
    }

    // =======================================================
    // NO AVAILABLE CORRIDOR
    // =======================================================

    if (viewModel.rates.isEmpty) {
      return RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 90, left: 24, right: 24),
          children: [
            const Icon(
              Icons.currency_exchange_rounded,
              size: 40,
              color: Color(0xFFAAA39F),
            ),

            const SizedBox(height: 12),

            Text(
              l10n.exchangeRatesEmpty,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF655E5A), fontSize: 14),
            ),
          ],
        ),
      );
    }

    // =======================================================
    // SEARCH WITHOUT RESULT
    // =======================================================

    if (viewModel.visibleRates.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 38,
            color: Color(0xFFAAA39F),
          ),

          const SizedBox(height: 12),

          Text(
            l10n.exchangeRatesNoSearchResult,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF655E5A), fontSize: 14),
          ),
        ],
      );
    }

    // =======================================================
    // AVAILABLE RATES
    // =======================================================

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
        itemCount: viewModel.visibleRates.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
            thickness: 0.7,
            color: Color(0xFFE3DEDB),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          final exchangeRate = viewModel.visibleRates[index];

          return ExchangeRateTile(
            exchangeRate: exchangeRate,

            /*
             * Pas encore de navigation vers Transfert.
             *
             * On branchera corridorId lorsque nous
             * travaillerons ce parcours.
             */
            onTap: null,
          );
        },
      ),
    );
  }
}
