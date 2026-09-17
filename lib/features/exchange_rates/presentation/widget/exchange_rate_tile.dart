import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/model/available_exchange_rate_model.dart';

class ExchangeRateTile extends StatelessWidget {
  final AvailableExchangeRateModel exchangeRate;

  final VoidCallback? onTap;

  const ExchangeRateTile({
    super.key,
    required this.exchangeRate,
    this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final AppLocalizations l10n =
    AppLocalizations.of(context);

    final Locale locale =
    Localizations.localeOf(context);

    final String sourceFlag =
    _countryCodeToFlag(
      exchangeRate.sourceCountryCode,
    );

    final String destinationFlag =
    _countryCodeToFlag(
      exchangeRate.destinationCountryCode,
    );

    final String formattedRate =
    _formatRate(
      exchangeRate.rate,
      locale,
    );

    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [
          // ===================================================
          // FLAGS
          // ===================================================

          Text(
            '$sourceFlag$destinationFlag',
            style: const TextStyle(
              fontSize: 20,
              height: 1,
            ),
          ),

          const SizedBox(
            width: 9,
          ),

          // ===================================================
          // COUNTRIES + RATE
          // ===================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.exchangeRateCorridor(
                    exchangeRate.sourceCountryName,
                    exchangeRate.destinationCountryName,
                  ),
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(
                      0xFF272321,
                    ),
                    fontSize: 15.5,
                    fontWeight:
                    FontWeight.w600,
                    height: 1.25,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  l10n.exchangeRateEquation(
                    exchangeRate.sourceCurrencyCode,
                    formattedRate,
                    exchangeRate.targetCurrencyCode,
                  ),
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(
                      0xFF008B80,
                    ),
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          // ===================================================
          // FUTURE NAVIGATION TO TRANSFER
          // ===================================================

          if (onTap != null) ...[
            const SizedBox(
              width: 6,
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(
                0xFF9B9692,
              ),
              size: 21,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: content,
      ),
    );
  }

  // =========================================================
  // ISO COUNTRY CODE -> EMOJI FLAG
  // =========================================================

  String _countryCodeToFlag(
      String countryCode,
      ) {
    final String normalized =
    countryCode
        .trim()
        .toUpperCase();

    if (!RegExp(
      r'^[A-Z]{2}$',
    ).hasMatch(
      normalized,
    )) {
      return '🌍';
    }

    return String.fromCharCodes(
      normalized.codeUnits.map(
            (int character) {
          return 0x1F1E6 +
              character -
              65;
        },
      ),
    );
  }

  // =========================================================
  // RATE FORMAT
  // =========================================================

  String _formatRate(
      String rawValue,
      Locale locale,
      ) {
    String value =
    rawValue.trim();

    if (value.isEmpty) {
      return value;
    }

    final bool negative =
    value.startsWith('-');

    if (negative) {
      value = value.substring(1);
    }

    final List<String> parts =
    value.split('.');

    String integerPart =
        parts.first;

    String fractionPart =
    parts.length > 1
        ? parts
        .sublist(1)
        .join()
        : '';

    /*
     * Supprime uniquement les zéros inutiles
     * en fin de décimales.
     *
     * 655.957 -> 655.957
     * 53.000   -> 53
     * 13.250   -> 13.25
     */
    fractionPart =
        fractionPart.replaceFirst(
          RegExp(r'0+$'),
          '',
        );

    final bool french =
        locale.languageCode
            .toLowerCase() ==
            'fr';

    final String groupSeparator =
    french ? '\u202F' : ',';

    final String decimalSeparator =
    french ? ',' : '.';

    integerPart =
        _groupInteger(
          integerPart,
          groupSeparator,
        );

    final String sign =
    negative ? '-' : '';

    if (fractionPart.isEmpty) {
      return '$sign$integerPart';
    }

    return '$sign'
        '$integerPart'
        '$decimalSeparator'
        '$fractionPart';
  }

  String _groupInteger(
      String value,
      String separator,
      ) {
    if (value.length <= 3) {
      return value;
    }

    final StringBuffer result =
    StringBuffer();

    final int firstGroupLength =
    value.length % 3 == 0
        ? 3
        : value.length % 3;

    result.write(
      value.substring(
        0,
        firstGroupLength,
      ),
    );

    for (
    int index = firstGroupLength;
    index < value.length;
    index += 3
    ) {
      result.write(
        separator,
      );

      result.write(
        value.substring(
          index,
          index + 3,
        ),
      );
    }

    return result.toString();
  }
}