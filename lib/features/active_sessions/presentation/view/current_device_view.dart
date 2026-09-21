import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/exception/active_sessions_exception.dart';
import '../../domain/model/active_session_model.dart';
import '../view_model/current_device_view_model.dart';

class CurrentDeviceView extends StatefulWidget {
  const CurrentDeviceView({super.key});

  @override
  State<CurrentDeviceView> createState() => _CurrentDeviceViewState();
}

class _CurrentDeviceViewState extends State<CurrentDeviceView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrentDeviceViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final CurrentDeviceViewModel viewModel = context
        .watch<CurrentDeviceViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8F7F6),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: Text(
          l10n.currentDeviceTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: _buildContent(context, viewModel, l10n),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CurrentDeviceViewModel viewModel,
    AppLocalizations l10n,
  ) {
    // =======================================================
    // LOADING
    // =======================================================
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // =======================================================
    // ERROR
    // =======================================================
    if (viewModel.hasError || viewModel.currentSession == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage(l10n, viewModel.errorType),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: viewModel.load,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final ActiveSessionModel session = viewModel.currentSession!;
    return RefreshIndicator(
      onRefresh: viewModel.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),

        children: [
          _DeviceHeader(session: session),
          const SizedBox(height: 18),
          _DeviceInformationCard(session: session),
          const SizedBox(height: 24),

          _LogoutCurrentDeviceCard(
            isLoading: viewModel.isLoggingOut,
            onPressed: viewModel.isLoggingOut
                ? null
                : () {
                    _confirmLogout(context, viewModel, l10n);
                  },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LOGOUT CONFIRMATION
  // =========================================================
  Future<void> _confirmLogout(
    BuildContext context,
    CurrentDeviceViewModel viewModel,
    AppLocalizations l10n,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.logoutCurrentDeviceConfirmTitle),
          content: Text(l10n.logoutCurrentDeviceConfirmMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD63C3C),
              ),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }
    final bool success = await viewModel.logoutCurrentDevice();

    /*
   * Si le logout réussit :
   *
   * SessionService.clearSession()
   * déclenche le redirect GoRouter.
   *
   * On ne fait donc PAS context.go(login).
   */
    if (success || !context.mounted) {
      return;
    }
    _showLogoutError(context, viewModel.errorType, l10n);
  }

  void _showLogoutError(
    BuildContext context,
    ActiveSessionsErrorType? error,
    AppLocalizations l10n,
  ) {
    final String message;

    switch (error) {
      case ActiveSessionsErrorType.network:
        message = l10n.logoutCurrentDeviceNetworkError;
        break;

      case ActiveSessionsErrorType.server:
        message = l10n.logoutCurrentDeviceServerError;
        break;

      case ActiveSessionsErrorType.unauthorized:
      case ActiveSessionsErrorType.unexpected:
      case null:
        message = l10n.logoutCurrentDeviceUnexpectedError;
        break;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String _errorMessage(AppLocalizations l10n, ActiveSessionsErrorType? type) {
    switch (type) {
      case ActiveSessionsErrorType.network:
        return l10n.activeSessionsNetworkError;
      case ActiveSessionsErrorType.unauthorized:
        return l10n.activeSessionsUnauthorized;
      case ActiveSessionsErrorType.server:
        return l10n.activeSessionsServerError;
      case ActiveSessionsErrorType.unexpected:
      case null:
        return l10n.currentDeviceLoadError;
    }
  }
}

// ===========================================================
// HEADER
// ===========================================================

class _DeviceHeader extends StatelessWidget {
  final ActiveSessionModel session;
  const _DeviceHeader({required this.session});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String deviceName = session.deviceName?.trim().isNotEmpty == true
        ? session.deviceName!.trim()
        : l10n.unknownDevice;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0EDEB)),
      ),

      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,

            decoration: const BoxDecoration(
              color: Color(0xFFE8F7F5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smartphone_rounded,
              size: 34,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),
          Text(
            deviceName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Color(0xFF302B29),
            ),
          ),

          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F7F5),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              l10n.thisDevice,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// INFORMATION CARD
// ===========================================================
class _DeviceInformationCard extends StatelessWidget {
  final ActiveSessionModel session;
  const _DeviceInformationCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0EDEB)),
      ),
      child: Column(
        children: [
          _InformationRow(label: l10n.deviceStatus, value: l10n.deviceActive),
          const _InformationDivider(),
          _InformationRow(
            label: l10n.lastActivity,
            value: _formatDate(
              context,
              session.lastUsedAt ?? session.sessionCreatedAt,
            ),
          ),
          const _InformationDivider(),

          _InformationRow(
            label: l10n.sessionCreated,
            value: _formatDate(context, session.sessionCreatedAt),
          ),
          const _InformationDivider(),
          _InformationRow(
            label: l10n.sessionExpires,
            value: _formatDate(context, session.expiresAt),
          ),
          if (session.creationIp != null &&
              session.creationIp!.trim().isNotEmpty) ...[
            const _InformationDivider(),
            _InformationRow(label: l10n.ipAddress, value: session.creationIp!),
          ],

          if (session.deviceId != null &&
              session.deviceId!.trim().isNotEmpty) ...[
            const _InformationDivider(),
            _InformationRow(
              label: l10n.deviceIdentifier,
              value: _maskDeviceId(session.deviceId!),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(BuildContext context, DateTime date) {
    final String locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat('dd MMM yyyy • HH:mm', locale).format(date.toLocal());
  }

  static String _maskDeviceId(String deviceId) {
    final String value = deviceId.trim();

    if (value.length <= 8) {
      return '••••••••';
    }
    return '••••••••${value.substring(value.length - 6)}';
  }
}

// ===========================================================
// LOGOUT CURRENT DEVICE
// ===========================================================
class _LogoutCurrentDeviceCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _LogoutCurrentDeviceCard({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFDADA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFECEC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFD63C3C),
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.logoutCurrentDevice,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFD63C3C),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.logoutCurrentDeviceSubtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: Color(0xFF8A8481),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD63C3C),
                side: const BorderSide(color: Color(0xFFD63C3C)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.logout),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// INFORMATION ROW
// ===========================================================

class _InformationRow extends StatelessWidget {
  final String label;
  final String value;

  const _InformationRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Text(
              label,

              style: const TextStyle(fontSize: 13, color: Color(0xFF817A76)),
            ),
          ),

          const SizedBox(width: 16),

          Flexible(
            child: Text(
              value,

              textAlign: TextAlign.right,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF302B29),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationDivider extends StatelessWidget {
  const _InformationDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFF1EFED),
    );
  }
}
