import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/exception/transfer_history_exception.dart';

String transferMoney(BuildContext context, num amount, String currency) =>
    NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      name: currency, symbol: currency,
    ).format(amount);

String transferDate(BuildContext context, DateTime date) =>
    DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
        .add_Hm().format(date.toLocal());

String transferError(AppLocalizations l10n, TransferHistoryFailure failure) =>
    switch (failure) {
      TransferHistoryFailure.network => l10n.homeNetworkError,
      TransferHistoryFailure.timeout => l10n.homeTimeoutError,
      TransferHistoryFailure.sessionExpired => l10n.homeSessionExpiredError,
      TransferHistoryFailure.notFound => l10n.transferNotFound,
      TransferHistoryFailure.server => l10n.homeServerError,
      TransferHistoryFailure.invalidResponse => l10n.homeInvalidResponseError,
      TransferHistoryFailure.unexpected => l10n.homeUnexpectedError,
    };

String transferStatus(AppLocalizations l10n, String status) => switch (status) {
  'CREATED' => l10n.transferStatusCreated,
  'PENDING' => l10n.transferStatusPending,
  'PROCESSING' => l10n.transferStatusProcessing,
  'COMPLETED' => l10n.transferStatusCompleted,
  'FAILED' => l10n.transferStatusFailed,
  'CANCELLED' => l10n.transferStatusCancelled,
  'REFUNDED' => l10n.transferStatusRefunded,
  _ => l10n.transferStatusUnknown,
};
