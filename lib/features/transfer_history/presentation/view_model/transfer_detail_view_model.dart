import 'package:flutter/foundation.dart';
import '../../domain/exception/transfer_history_exception.dart';
import '../../domain/model/transfer_detail_model.dart';
import '../../domain/service/transfer_history_service.dart';

class TransferDetailViewModel extends ChangeNotifier {
  final TransferHistoryService _service;
  final String transferId;
  TransferDetailViewModel({
    required TransferHistoryService service, required this.transferId,
  }) : _service = service;

  TransferDetailModel? _detail;
  TransferHistoryFailure? _error;
  bool _loading = false, _disposed = false;
  TransferDetailModel? get detail => _detail;
  TransferHistoryFailure? get error => _error;
  bool get isLoading => _loading;

  Future<void> load() async {
    if (_loading || _disposed) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _service.getDetail(transferId);
      if (!_disposed) _detail = result;
    } catch (error) {
      if (!_disposed) {
        _error = error is TransferHistoryException
            ? error.failure : TransferHistoryFailure.unexpected;
      }
    } finally {
      if (!_disposed) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  bool _exporting = false;
  TransferHistoryFailure? _exportError;
  bool get isExporting => _exporting;
  TransferHistoryFailure? get exportError => _exportError;

  Future<List<int>?> exportReceipt(String locale) async {
    if (_disposed || _exporting) return null;
    if (_detail?.receiptAvailable != true) return null;
    _exporting = true;
    _exportError = null;
    notifyListeners();
    try {
      final bytes = await _service.getReceipt(transferId, locale);
      return _disposed ? null : bytes;
    } catch (error) {
      if (!_disposed) {
        _exportError = error is TransferHistoryException
            ? error.failure : TransferHistoryFailure.unexpected;
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
    super.dispose();
  }
}
