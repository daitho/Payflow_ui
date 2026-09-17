import 'package:flutter/foundation.dart';

import '../../../../core/service/session_service.dart';
import '../../domain/model/profile_model.dart';

class ProfileViewModel
    extends ChangeNotifier {
  final SessionService _sessionService;

  ProfileViewModel({
    required SessionService sessionService,
  }) : _sessionService =
      sessionService {
    _sessionService.addListener(
      _onSessionChanged,
    );
  }

  // =========================================================
  // PROFILE
  // =========================================================
  ProfileModel? get profile {
    final user =
        _sessionService.currentUser;
    if (user == null) {
      return null;
    }

    return ProfileModel(
      publicId: user.publicId,
      firstName:
      user.firstName ?? '',
      lastName: user.lastName,
      email: user.email,
      phone: user.phoneE164,
      role: user.role,
      status: user.status,
      verified: user.verified,
    );
  }

  // =========================================================
  // SESSION CHANGED
  // =========================================================
  void _onSessionChanged() {
    notifyListeners();
  }

  // =========================================================
  // DISPOSE
  // =========================================================
  @override
  void dispose() {
    _sessionService.removeListener(
      _onSessionChanged,
    );
    super.dispose();
  }
}