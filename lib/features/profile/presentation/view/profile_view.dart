import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/localization/app_language.dart';
import '../../../../app/localization/locale_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../active_sessions/domain/exception/active_sessions_exception.dart';
import '../../../active_sessions/presentation/view_model/current_device_view_model.dart';
import '../view_model/profile_view_model.dart';
import '../widget/profile_header_card.dart';
import '../widget/profile_menu_tile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel viewModel = context.watch<ProfileViewModel>();
    final LocaleController localeController = context.watch<LocaleController>();
    final profile = viewModel.profile;

    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final l10n = AppLocalizations.of(context);
    final CurrentDeviceViewModel logoutViewModel = context
        .watch<CurrentDeviceViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.profile,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF302B29),
                ),
              ),
              const SizedBox(height: 22),
              ProfileHeaderCard(profile: profile),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.myAccount),
              _MenuCard(
                children: [
                  ProfileMenuTile(
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFFFF6B35),
                    iconBackgroundColor: const Color(0xFFFFF0E8),
                    title: l10n.accountInformation,
                    subtitle: l10n.accountInformationSubtitle,
                    onTap: () {},
                  ),
                  const _Divider(),
                  ProfileMenuTile(
                    icon: Icons.verified_user_outlined,
                    iconColor: const Color(0xFF167C73),
                    iconBackgroundColor: const Color(0xFFE8F7F5),
                    title: l10n.verificationAndLimits,
                    subtitle: l10n.verificationAndLimitsSubtitle,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SectionTitle(title: l10n.security),
              _MenuCard(
                children: [
                  ProfileMenuTile(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF28A05A),
                    iconBackgroundColor: const Color(0xFFEAF8EF),
                    title: l10n.securityAndPrivacy,
                    subtitle: l10n.securityAndPrivacySubtitle,
                    onTap: () {
                      context.push(AppRoutes.profileSecurity);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _SectionTitle(title: l10n.preferences),
              _MenuCard(
                children: [
                  ProfileMenuTile(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFF168C88),
                    iconBackgroundColor: const Color(0xFFE8F7F5),
                    title: l10n.notificationPreferences,
                    subtitle: l10n.notificationPreferencesSubtitle,
                    onTap: () {},
                  ),
                  const _Divider(),
                  ProfileMenuTile(
                    icon: Icons.language_rounded,
                    iconColor: const Color(0xFF6D5BD0),
                    iconBackgroundColor: const Color(0xFFF0EDFF),
                    title: l10n.language,
                    subtitle: _languageLabel(l10n, localeController.language),
                    onTap: () {
                      _showLanguagePicker(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _SectionTitle(title: l10n.help),
              _MenuCard(
                children: [
                  ProfileMenuTile(
                    icon: Icons.headset_mic_outlined,
                    iconColor: const Color(0xFFE39A19),
                    iconBackgroundColor: const Color(0xFFFFF6DF),
                    title: l10n.helpAndSupport,
                    subtitle: l10n.helpAndSupportSubtitle,
                    onTap: () {},
                  ),
                  const _Divider(),
                  ProfileMenuTile(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF7657C8),
                    iconBackgroundColor: const Color(0xFFF0EDFF),
                    title: l10n.about,
                    subtitle: l10n.aboutSubtitle,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: logoutViewModel.isLoggingOut
                    ? null
                    : () {
                        _confirmProfileLogout(context);
                      },
                icon: logoutViewModel.isLoggingOut
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout_rounded),
                label: Text(l10n.signOut),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD63C3C),
                  side: const BorderSide(color: Color(0xFFF0CACA)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'PayFlow',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFFAAA4A1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showLanguagePicker(BuildContext context) async {
  final LocaleController controller = context.read<LocaleController>();

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (BuildContext sheetContext) {
      final AppLocalizations l10n = AppLocalizations.of(sheetContext);

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.changeLanguage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF302B29),
                ),
              ),
              const SizedBox(height: 10),
              RadioGroup<AppLanguage>(
                groupValue: controller.language,
                onChanged: (AppLanguage? selected) async {
                  if (selected == null) {
                    return;
                  }
                  await controller.setLanguage(selected);
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
                child: Column(
                  children: [
                    for (final AppLanguage language in AppLanguage.values)
                      RadioListTile<AppLanguage>(
                        value: language,
                        activeColor: const Color(0xFF168C88),
                        title: Text(_languageLabel(l10n, language)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String _languageLabel(AppLocalizations l10n, AppLanguage language) {
  return switch (language) {
    AppLanguage.system => l10n.systemLanguage,
    AppLanguage.french => l10n.french,
    AppLanguage.english => l10n.english,
    AppLanguage.spanish => l10n.spanish,
    AppLanguage.mandarin => l10n.mandarin,
    AppLanguage.hindi => l10n.hindi,
  };
}

Future<void> _confirmProfileLogout(BuildContext context) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final CurrentDeviceViewModel viewModel = context
      .read<CurrentDeviceViewModel>();

  // =========================================================
  // CONFIRMATION
  // =========================================================
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

  // =========================================================
  // LOGOUT
  // =========================================================
  final bool success = await viewModel.logoutCurrentDevice();
  /*
   * En cas de succès :
   *
   * logoutCurrentDevice()
   * -> SessionService.clearSession()
   * -> notifyListeners()
   * -> GoRouter
   * -> Login
   *
   * Donc surtout PAS :
   *
   * context.go(AppRoutes.login)
   */
  if (success || !context.mounted) {
    return;
  }
  _showProfileLogoutError(context, viewModel.errorType, l10n);
}

void _showProfileLogoutError(
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

class _MenuCard extends StatelessWidget {
  final List<Widget> children;

  const _MenuCard({required this.children});

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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 72),

      child: Divider(height: 1, thickness: 1, color: Color(0xFFF1EFED)),
    );
  }
}
