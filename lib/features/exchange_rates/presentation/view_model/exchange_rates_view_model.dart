import 'package:flutter/foundation.dart';

import '../../domain/model/available_exchange_rate_model.dart';
import '../../domain/repository/exchange_rate_repository.dart';

enum ExchangeRatesViewStatus { initial, loading, success, error }

class ExchangeRatesViewModel extends ChangeNotifier {
  final ExchangeRateRepository _repository;

  ExchangeRatesViewModel(this._repository);

  ExchangeRatesViewStatus _status = ExchangeRatesViewStatus.initial;

  ExchangeRatesViewStatus get status => _status;

  List<AvailableExchangeRateModel> _rates = const [];

  List<AvailableExchangeRateModel> get rates => _rates;

  List<AvailableExchangeRateModel> _visibleRates = const [];

  List<AvailableExchangeRateModel> get visibleRates => _visibleRates;

  String _query = '';

  String get query => _query;

  bool _refreshFailed = false;

  bool get refreshFailed => _refreshFailed;

  bool _requestInProgress = false;

  bool get isLoading => _status == ExchangeRatesViewStatus.loading;

  bool get isInitialLoading => isLoading && _rates.isEmpty;

  bool get isRefreshing => isLoading && _rates.isNotEmpty;

  bool get hasInitialError =>
      _status == ExchangeRatesViewStatus.error && _rates.isEmpty;

  bool get isEmpty =>
      _status == ExchangeRatesViewStatus.success && _rates.isEmpty;

  // =========================================================
  // LOAD
  // =========================================================

  Future<void> load() async {
    if (_requestInProgress) {
      return;
    }

    _requestInProgress = true;

    final bool hadData = _rates.isNotEmpty;

    _status = ExchangeRatesViewStatus.loading;
    _refreshFailed = false;

    notifyListeners();

    try {
      final List<AvailableExchangeRateModel> loaded = await _repository
          .getAvailableExchangeRates();

      /*
       * L'API reste la source de vérité.
       *
       * Ici, on ne fait qu'un tri de présentation :
       * pays destination par ordre alphabétique.
       */
      final List<AvailableExchangeRateModel> sorted =
          List<AvailableExchangeRateModel>.from(loaded)..sort((
            AvailableExchangeRateModel first,
            AvailableExchangeRateModel second,
          ) {
            return first.destinationCountryName.toLowerCase().compareTo(
              second.destinationCountryName.toLowerCase(),
            );
          });

      _rates = List.unmodifiable(sorted);

      _applySearch(notify: false);

      _status = ExchangeRatesViewStatus.success;
    } catch (_) {
      /*
       * Si nous avions déjà des données lors d'un refresh,
       * on les conserve.
       */
      if (hadData) {
        _status = ExchangeRatesViewStatus.success;
        _refreshFailed = true;
      } else {
        _status = ExchangeRatesViewStatus.error;
      }
    } finally {
      _requestInProgress = false;

      notifyListeners();
    }
  }

  // =========================================================
  // RETRY
  // =========================================================

  Future<void> retry() {
    return load();
  }

  // =========================================================
  // REFRESH
  // =========================================================

  Future<void> refresh() {
    return load();
  }

  // =========================================================
  // SEARCH
  // =========================================================

  void search(String value) {
    if (_query == value) {
      return;
    }

    _query = value;

    _applySearch();
  }

  void clearSearch() {
    if (_query.isEmpty) {
      return;
    }

    _query = '';

    _applySearch();
  }

  void _applySearch({bool notify = true}) {
    final String normalizedQuery = _normalize(_query);

    if (normalizedQuery.isEmpty) {
      _visibleRates = _rates;
    } else {
      _visibleRates = _rates
          .where((AvailableExchangeRateModel rate) {
            final String searchable = _normalize(
              [
                rate.sourceCountryName,
                rate.sourceCountryCode,
                rate.destinationCountryName,
                rate.destinationCountryCode,
                rate.sourceCurrencyCode,
                rate.sourceCurrencyName,
                rate.targetCurrencyCode,
                rate.targetCurrencyName,
              ].join(' '),
            );

            return searchable.contains(normalizedQuery);
          })
          .toList(growable: false);
    }

    if (notify) {
      notifyListeners();
    }
  }

  // =========================================================
  // SEARCH NORMALIZATION
  // =========================================================

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[àâäáãå]'), 'a')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[îïíì]'), 'i')
        .replaceAll(RegExp(r'[ôöóòõ]'), 'o')
        .replaceAll(RegExp(r'[ùûüú]'), 'u')
        .replaceAll(RegExp(r'[ÿý]'), 'y');
  }
}
