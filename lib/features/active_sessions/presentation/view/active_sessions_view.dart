import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/exception/active_sessions_exception.dart';
import '../../domain/model/active_session_model.dart';
import '../view_model/active_sessions_view_model.dart';

class ActiveSessionsView extends StatefulWidget {
  const ActiveSessionsView({super.key});

  @override
  State<ActiveSessionsView> createState() => _ActiveSessionsViewState();
}

class _ActiveSessionsViewState extends State<ActiveSessionsView> {
  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActiveSessionsViewModel>().load();
    });
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final ActiveSessionsViewModel viewModel = context
        .watch<ActiveSessionsViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(l10n.activeSessionsTitle),
      ),

      body: RefreshIndicator(
        onRefresh: viewModel.load,

        child: _buildContent(context, viewModel, l10n),
      ),
    );
  }

  // =========================================================
  // CONTENT
  // =========================================================

  Widget _buildContent(
    BuildContext context,
    ActiveSessionsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    // ---------------------------------------------------------
    // INITIAL LOADING
    // ---------------------------------------------------------

    if (viewModel.isLoading && viewModel.sessions.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),

        children: [
          SizedBox(height: 250),

          Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ],
      );
    }

    // ---------------------------------------------------------
    // ERROR
    // ---------------------------------------------------------

    if (viewModel.hasError && viewModel.sessions.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.symmetric(horizontal: 24),

        children: [
          const SizedBox(height: 150),

          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.primary,
          ),

          const SizedBox(height: 18),

          Text(
            _errorMessage(l10n, viewModel.errorType),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          Center(
            child: ElevatedButton(
              onPressed: viewModel.isLoading ? null : viewModel.load,

              child: Text(l10n.retry),
            ),
          ),
        ],
      );
    }

    // ---------------------------------------------------------
    // EMPTY
    // ---------------------------------------------------------

    if (viewModel.sessions.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.symmetric(horizontal: 24),

        children: [
          const SizedBox(height: 160),

          const Icon(Icons.devices_rounded, size: 48, color: Color(0xFF777777)),

          const SizedBox(height: 16),

          Text(l10n.noActiveSessions, textAlign: TextAlign.center),
        ],
      );
    }

    // ---------------------------------------------------------
    // LIST
    // ---------------------------------------------------------

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),

      itemCount: viewModel.sessions.length,

      separatorBuilder: (_, __) => const SizedBox(height: 12),

      itemBuilder: (BuildContext context, int index) {
        final ActiveSessionModel session = viewModel.sessions[index];

        final bool isCurrent = viewModel.isCurrentSession(session);

        return _SessionCard(
          session: session,
          isCurrent: isCurrent,

          isRevoking: viewModel.sessionBeingRevokedId == session.sessionId,

          onRevoke: isCurrent
              ? null
              : () {
                  _confirmRevoke(context, viewModel, session, l10n);
                },
        );
      },
    );
  }

  // =========================================================
  // CONFIRM REVOKE
  // =========================================================

  Future<void> _confirmRevoke(
    BuildContext context,
    ActiveSessionsViewModel viewModel,
    ActiveSessionModel session,
    AppLocalizations l10n,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,

      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.revokeSessionTitle),

          content: Text(l10n.revokeSessionMessage(_deviceName(session, l10n))),

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

              child: Text(l10n.disconnect),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final bool success = await viewModel.revoke(sessionId: session.sessionId);

    if (!context.mounted) {
      return;
    }

    if (success) {
      _showMessage(context, l10n.sessionRevokedSuccess);
    } else {
      _showMessage(context, _errorMessage(l10n, viewModel.errorType));
    }
  }

  // =========================================================
  // HELPERS
  // =========================================================

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
        return l10n.activeSessionsUnexpectedError;
    }
  }

  static String _deviceName(ActiveSessionModel session, AppLocalizations l10n) {
    final String? deviceName = session.deviceName?.trim();

    if (deviceName != null && deviceName.isNotEmpty) {
      return deviceName;
    }

    return l10n.unknownDevice;
  }

  void _showMessage(BuildContext context, String message) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

// ===========================================================
// SESSION CARD
// ===========================================================

class _SessionCard extends StatelessWidget {
  final ActiveSessionModel session;
  final bool isCurrent;
  final bool isRevoking;
  final VoidCallback? onRevoke;

  const _SessionCard({
    required this.session,
    required this.isCurrent,
    required this.isRevoking,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final String deviceName = _ActiveSessionsViewState._deviceName(
      session,
      l10n,
    );

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: isCurrent
              ? AppColors.primary.withValues(alpha: 0.35)
              : const Color(0xFFE8E8E8),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Container(
                width: 44,
                height: 44,

                decoration: const BoxDecoration(
                  color: Color(0xFFE8F7F5),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.devices_rounded,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      deviceName,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    if (isCurrent)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),

                        child: Text(
                          l10n.thisDevice,

                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F7F5),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    l10n.currentSession,

                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          _InfoLine(
            label: l10n.lastActivity,

            value: _formatDate(
              context,
              session.lastUsedAt ?? session.sessionCreatedAt,
            ),
          ),

          const SizedBox(height: 8),

          _InfoLine(
            label: l10n.sessionCreated,

            value: _formatDate(context, session.sessionCreatedAt),
          ),

          const SizedBox(height: 8),

          _InfoLine(
            label: l10n.sessionExpires,

            value: _formatDate(context, session.expiresAt),
          ),

          if (session.creationIp != null &&
              session.creationIp!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),

            _InfoLine(label: l10n.ipAddress, value: session.creationIp!),
          ],

          if (!isCurrent) ...[
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,

              child: TextButton.icon(
                onPressed: isRevoking ? null : onRevoke,

                icon: isRevoking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout_rounded),

                label: Text(l10n.disconnect),
              ),
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
}

// ===========================================================
// INFO LINE
// ===========================================================

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(
          width: 125,

          child: Text(
            label,

            style: const TextStyle(fontSize: 13, color: Color(0xFF7B7470)),
          ),
        ),

        Expanded(
          child: Text(
            value,

            textAlign: TextAlign.right,

            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF302D2B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
