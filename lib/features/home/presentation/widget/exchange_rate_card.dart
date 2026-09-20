import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/model/home_exchange_rate_model.dart';
import '../util/country_flag_util.dart';

class ExchangeRateCard extends StatelessWidget {
  final HomeExchangeRateModel? exchangeRate;
  final VoidCallback? onTap;

  const ExchangeRateCard({super.key, required this.exchangeRate, this.onTap});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final HomeExchangeRateModel? rate = exchangeRate;

    final String title;

    if (rate == null) {
      title = l10n.homeExchangeRate;
    } else if (rate.comesFromLastTransaction) {
      title = l10n.homeLastRateUsed;
    } else {
      title = l10n.homeAvailableRate;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // TITLE / MAIN CURRENCY
        // =====================================================

        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF272321),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            if (rate != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${l10n.homeMainCurrency} : ',
                    style: const TextStyle(
                      color: Color(0xFF8A827E),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text(
                    CountryFlagUtil.forCurrency(
                      currencyCode: rate.sourceCurrencyCode,
                      countryIsoCode2: rate.sourceCountryIsoCode2,
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    rate.sourceCurrencyCode,
                    style: const TextStyle(
                      color: Color(0xFF393330),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
          ],
        ),

        const SizedBox(height: 12),

        // =====================================================
        // CARD
        // =====================================================
        Material(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          child: InkWell(
            onTap: onTap,

            borderRadius: BorderRadius.circular(12),

            child: Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: const Color(0xFFE4E0DE)),
              ),

              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // =========================================
                    // GREEN STRIPE
                    // =========================================

                    Container(
                      width: 6,

                      decoration: const BoxDecoration(
                        color: Color(0xFF47B85A),

                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(12),
                        ),
                      ),
                    ),

                    // =========================================
                    // BODY
                    // =========================================
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 15,
                        ),

                        child: rate == null
                            ? Text(l10n.homeNoRateAvailable)
                            : _RateRow(rate: rate),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================
// RATE ROW
// ===========================================================

class _RateRow extends StatelessWidget {
  final HomeExchangeRateModel rate;

  const _RateRow({required this.rate});

  @override
  Widget build(BuildContext context) {
    final String locale = Localizations.localeOf(context).toLanguageTag();

    final NumberFormat formatter = NumberFormat('#,##0.00', locale);

    final String sourceFlag = CountryFlagUtil.forCurrency(
      currencyCode: rate.sourceCurrencyCode,
      countryIsoCode2: rate.sourceCountryIsoCode2,
    );

    final String targetFlag = CountryFlagUtil.fromIsoCode2(
      rate.targetCountryIsoCode2,
    );

    return Row(
      children: [
        // =====================================================
        // FLAGS
        // =====================================================

        SizedBox(
          width: 46,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Text(sourceFlag, style: const TextStyle(fontSize: 23)),

              Positioned(
                left: 17,
                child: Text(targetFlag, style: const TextStyle(fontSize: 23)),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // =====================================================
        // PAIR + EXCHANGE RATE
        // =====================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [
              Text(
                '${rate.sourceCurrencyCode}'
                ' → '
                '${rate.targetCurrencyCode}',

                style: const TextStyle(
                  color: Color(0xFF302B28),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                AppLocalizations.of(context).homeExchangeRateSubtitle,

                style: const TextStyle(
                  color: Color(0xFFAAA3A0),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // =====================================================
        // RATE
        // =====================================================
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),

          decoration: BoxDecoration(
            color: const Color(0xFFEAF8EE),

            borderRadius: BorderRadius.circular(8),

            border: Border.all(color: const Color(0xFFAADDB9)),
          ),

          child: Text(
            '1 ${rate.sourceCurrencyCode}'
            ' = '
            '${formatter.format(rate.rate)} '
            '${rate.targetCurrencyCode}',

            style: const TextStyle(
              color: Color(0xFF3F5748),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
