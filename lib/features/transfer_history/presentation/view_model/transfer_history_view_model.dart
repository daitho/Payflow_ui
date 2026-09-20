import 'package:flutter/foundation.dart';
import '../../domain/exception/transfer_history_exception.dart';
import '../../domain/model/transfer_history_filter.dart';
import '../../domain/model/transfer_history_item_model.dart';
import '../../domain/model/transfer_history_page_model.dart';
import '../../domain/service/transfer_history_service.dart';

class TransferHistoryViewModel extends ChangeNotifier {
  final TransferHistoryService _service;
  TransferHistoryViewModel({required TransferHistoryService service})
    : _service = service;

  TransferHistoryFilter _filter = const TransferHistoryFilter();
  TransferHistoryPageModel? _page;
  List<TransferHistoryItemModel> _items = const [];
  TransferHistoryFailure? _error;
  bool _loading = false, _loadingMore = false, _disposed = false;
  int _generation = 0;

  TransferHistoryFilter get filter => _filter;
  TransferHistoryPageModel? get page => _page;
  List<TransferHistoryItemModel> get items => _items;
  TransferHistoryFailure? get error => _error;
  bool get isLoading => _loading;
  bool get isLoadingMore => _loadingMore;

  Future<void> setFilter(TransferHistoryFilter value) async {
    if (_exporting || _disposed) return;
    _filter = value;
    _page = null;
    _items = const [];
    await refresh();
  }

  Future<void> refresh() async {
    if (_exporting) return;
    await _load(append: false);
  }

  Future<void> loadMore() async {
    if (_exporting || _loading || _loadingMore || _page?.hasNext != true)
      return;
    await _load(append: true);
  }

  Future<void> _load({required bool append}) async {
    if (_disposed) return;
    final generation = ++_generation;
    final requestedPage = append ? _page!.page + 1 : 0;
    _loading = !append;
    _loadingMore = append;
    _error = null;
    notifyListeners();
    try {
      final result = await _service.getHistory(
        filter: _filter,
        page: requestedPage,
      );
      if (_disposed || generation != _generation) return;
      // A refresh or filter change invalidates any older page request.
      final combined = append ? [..._items, ...result.items] : result.items;
      final byId = <String, TransferHistoryItemModel>{};
      for (final item in combined) {
        byId[item.id] = item;
      }
      _items = List.unmodifiable(byId.values);
      _page = result;
    } catch (error) {
      if (_disposed || generation != _generation) return;
      _error = error is TransferHistoryException
          ? error.failure
          : TransferHistoryFailure.unexpected;
    } finally {
      if (!_disposed && generation == _generation) {
        _loading = false;
        _loadingMore = false;
        notifyListeners();
      }
    }
  }

  bool _exporting = false;
  TransferHistoryFailure? _exportError;
  bool get isExporting => _exporting;
  TransferHistoryFailure? get exportError => _exportError;

  Future<List<int>?> exportHistory(String locale) async {
    if (_disposed || _exporting) return null;
    if (_loading || _loadingMore || _page == null) return null;
    _exporting = true;
    _exportError = null;
    notifyListeners();
    try {
      final bytes = await _service.getStatement(_filter, locale);
      return _disposed ? null : bytes;
    } catch (error) {
      if (!_disposed) {
        _exportError = error is TransferHistoryException
            ? error.failure
            : TransferHistoryFailure.unexpected;
      }
      return null;
    } finally {
      if (!_disposed) {
        _exporting = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
