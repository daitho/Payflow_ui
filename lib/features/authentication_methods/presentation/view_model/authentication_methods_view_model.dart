import 'package:flutter/foundation.dart';

import '../../../../core/service/session_service.dart';
import '../../../auth/domain/exception/verification_exception.dart';
import '../../../auth/domain/model/verification_challenge_model.dart';
import '../../../auth/domain/model/verification_channel.dart';
import '../../../auth/domain/service/verification_service.dart';
import '../../domain/model/linked_provider.dart';
import '../../domain/service/linked_provider_service.dart';

class AuthenticationMethodsViewModel extends ChangeNotifier {
  final VerificationService _verificationService;
  final LinkedProviderService _linkedProviderService;
  final SessionService _sessionService;

  bool _loading = false;
  bool _providersLoading = false;
  bool _providersError = false;
  Map<ExternalProvider, LinkedProvider> _providers = {};
  bool _emailVerified = false;
  bool _phoneVerified = false;
  VerificationErrorType? _error;

  AuthenticationMethodsViewModel({
    required VerificationService verificationService,
    required LinkedProviderService linkedProviderService,
    required SessionService sessionService,
  }) : _verificationService = verificationService,
       _linkedProviderService = linkedProviderService,
       _sessionService = sessionService {
    final user = _sessionService.currentUser;
    _emailVerified = user?.emailVerified ?? false;
    _phoneVerified = user?.phoneVerified ?? false;
  }

  bool get loading => _loading;
  bool get providersLoading => _providersLoading;
  bool get providersError => _providersError;
  LinkedProvider? provider(ExternalProvider provider) => _providers[provider];
  bool get emailVerified => _emailVerified;
  bool get phoneVerified => _phoneVerified;
  String get email => _sessionService.currentUser?.email ?? '';
  String get phone => _sessionService.currentUser?.phoneE164 ?? '';
  VerificationErrorType? get error => _error;

  Future<void> load() async {
    _loading = true;
    _providersLoading = true;
    _providersError = false;
    _error = null;
    notifyListeners();
    try {
      final status = await _verificationService.status();
      _emailVerified = status.emailVerified;
      _phoneVerified = status.phoneVerified;
    } on VerificationException catch (exception) {
      _error = exception.type;
    } finally {
      _loading = false;
      notifyListeners();
    }

    try {
      final providers = await _linkedProviderService.list();
      _providers = {for (final provider in providers) provider.provider: provider};
    } catch (_) {
      _providersError = true;
    } finally {
      _providersLoading = false;
      notifyListeners();
    }
  }

  Future<VerificationChallengeModel?> start(VerificationChannel channel) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      return await _verificationService.startAdditional(channel);
    } on VerificationException catch (exception) {
      _error = exception.type;
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
