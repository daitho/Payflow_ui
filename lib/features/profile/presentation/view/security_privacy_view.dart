import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../active_sessions/domain/exception/active_sessions_exception.dart';
import '../../../active_sessions/presentation/view_model/active_sessions_view_model.dart';
import '../view_model/security_privacy_view_model.dart';

class SecurityPrivacyView extends StatelessWidget {
  const SecurityPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SecurityPrivacyViewModel>();
    final ActiveSessionsViewModel activeSessionsViewModel = context
        .watch<ActiveSessionsViewModel>();
    final l10n = AppLocalizations.of(context);
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
          l10n.securityAndPrivacy,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // =================================================
          // AUTHENTICATION
          // =================================================
          _SectionTitle(title: l10n.authentication),
          _SecurityCard(
            children: [
              _SecurityTile(
                icon: Icons.fingerprint_rounded,
                iconColor: const Color(0xFF167C73),
                iconBackground: const Color(0xFFE8F7F5),

                title: l10n.biometrics,

                subtitle: viewModel.isInitializing
                    ? l10n.checkingBiometrics
                    : viewModel.biometricsAvailable
                    ? l10n.biometricsSubtitle
                    : l10n.biometricsUnavailable,

                trailing: Switch.adaptive(
                  value: viewModel.biometricsEnabled,

                  onChanged:
                      viewModel.isInitializing ||
                          viewModel.isBiometricActionLoading
                      ? null
                      : (bool value) async {
                          final result = await viewModel.setBiometricsEnabled(
                            enabled: value,
                            localizedReason: value
                                ? l10n.enableBiometricsReason
                                : l10n.disableBiometricsReason,
                          );

                          if (!context.mounted) {
                            return;
                          }
                          switch (result) {
                            case BiometricToggleResult.success:
                              break;
                            case BiometricToggleResult.unavailable:
                              _showMessage(context, l10n.biometricsUnavailable);
                              break;
                            case BiometricToggleResult.authenticationFailed:
                              _showMessage(
                                context,
                                l10n.biometricAuthenticationFailed,
                              );
                              break;
                            case BiometricToggleResult.technicalError:
                              _showMessage(
                                context,
                                l10n.biometricTechnicalError,
                              );
                              break;
                          }
                        },
                ),
              ),

              const _Divider(),
              _SecurityTile(
                icon: Icons.lock_outline_rounded,
                iconColor: const Color(0xFFFF6B35),
                iconBackground: const Color(0xFFFFF0E8),

                title: l10n.changePassword,
                subtitle: l10n.changePasswordSubtitle,

                onTap: () {
                  context.push(AppRoutes.changePassword);
                },
              ),
              const _Divider(),
              _SecurityTile(
                icon: Icons.key_rounded,
                iconColor: const Color(0xFF167C73),
                iconBackground: const Color(0xFFE8F7F5),
                title: _authenticationMethodsLabel(context),
                subtitle: _authenticationMethodsSubtitle(context),
                onTap: () {
                  context.push(AppRoutes.authenticationMethods);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================================================
          // SESSIONS
          // =================================================
          _SectionTitle(title: l10n.sessionsAndDevices),
          _SecurityCard(
            children: [
              _SecurityTile(
                icon: Icons.smartphone_rounded,
                iconColor: const Color(0xFF4D75C9),
                iconBackground: const Color(0xFFEDF2FC),
                title: l10n.thisDevice,
                subtitle: l10n.thisDeviceSubtitle,
                onTap: () {
                  context.push(AppRoutes.currentDevice);
                },
              ),
              const _Divider(),
              _SecurityTile(
                icon: Icons.devices_outlined,
                iconColor: const Color(0xFF7657C8),
                iconBackground: const Color(0xFFF0EDFF),
                title: l10n.activeSessions,
                subtitle: l10n.activeSessionsSubtitle,
                onTap: () {
                  context.push(AppRoutes.activeSessions);
                },
              ),
              const _Divider(),
              _SecurityTile(
                icon: Icons.phonelink_erase_rounded,
                iconColor: const Color(0xFFD63C3C),
                iconBackground: const Color(0xFFFFECEC),
                title: l10n.disconnectOtherDevices,
                subtitle: l10n.disconnectOtherDevicesSubtitle,
                trailing: activeSessionsViewModel.isDisconnectingOthers
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,

                onTap: activeSessionsViewModel.isDisconnectingOthers
                    ? null
                    : () {
                        _confirmDisconnectOtherDevices(context);
                      },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // =================================================
          // INFORMATION
          // =================================================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6ED),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.security_rounded,
                  color: Color(0xFFFF6B35),
                  size: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.biometricPrivacyInfo,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: Color(0xFF6B5C54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _confirmDisconnectOtherDevices(BuildContext context) async {
  final AppLocalizations l10n = AppLocalizations.of(context);

  final ActiveSessionsViewModel viewModel = context
      .read<ActiveSessionsViewModel>();

  // =========================================================
  // CONFIRMATION
  // =========================================================

  final bool? confirmed = await showDialog<bool>(
    context: context,

    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(l10n.disconnectOtherDevicesConfirmTitle),

        content: Text(l10n.disconnectOtherDevicesConfirmMessage),

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

  // =========================================================
  // API
  // =========================================================

  final bool success = await viewModel.logoutOthers();

  if (!context.mounted) {
    return;
  }

  // =========================================================
  // RESULT
  // =========================================================

  if (success) {
    _showMessage(context, l10n.disconnectOtherDevicesSuccess);

    return;
  }

  _showMessage(context, _activeSessionsErrorMessage(l10n, viewModel.errorType));
}

void _showMessage(BuildContext context, String message) {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

  messenger.hideCurrentSnackBar();

  messenger.showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}

// ===========================================================
// SECTION TITLE
// ===========================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),

      child: Text(
        title.toUpperCase(),

        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
          color: Color(0xFF918A87),
        ),
      ),
    );
  }
}

// ===========================================================
// CARD
// ===========================================================

class _SecurityCard extends StatelessWidget {
  final List<Widget> children;

  const _SecurityCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFF0EDEB)),
      ),

      child: Column(children: children),
    );
  }
}

String _activeSessionsErrorMessage(
  AppLocalizations l10n,
  ActiveSessionsErrorType? type,
) {
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

// ===========================================================
// TILE
// ===========================================================
class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SecurityTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: iconBackground,

                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: iconColor, size: 22),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,

                      color: Color(0xFF302B29),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.3,

                      color: Color(0xFF8A8481),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,

                  color: Color(0xFFB0AAA7),
                ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================
// DIVIDER
// ===========================================================

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 72),

      child: Divider(height: 1, color: Color(0xFFF1EFED)),
    );
  }
}

String _authenticationMethodsLabel(BuildContext context) {
  return switch (Localizations.localeOf(context).languageCode) {
    'en' => 'Sign-in methods',
    'es' => 'Métodos de acceso',
    'zh' => '登录方式',
    'hi' => 'साइन-इन के तरीके',
    _ => 'Moyens de connexion',
  };
}

String _authenticationMethodsSubtitle(BuildContext context) {
  return switch (Localizations.localeOf(context).languageCode) {
    'en' => 'Verify identifiers and link your accounts',
    'es' => 'Verifica identificadores y vincula tus cuentas',
    'zh' => '验证登录信息并关联账户',
    'hi' => 'पहचान सत्यापित करें और खाते जोड़ें',
    _ => 'Vérifier vos identifiants et lier vos comptes',
  };
}
