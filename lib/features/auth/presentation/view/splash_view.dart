import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    /*
     * On attend le premier frame car nous avons besoin
     * de AppLocalizations.of(context).
     *
     * IMPORTANT :
     * il n'y a plus de navigation temporaire forcée
     * vers Login.
     */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApplication();
    });
  }

  // =========================================================
  // APPLICATION INITIALIZATION
  // =========================================================

  Future<void> _initializeApplication() async {
    final SplashViewModel viewModel = context.read<SplashViewModel>();

    final AppLocalizations l10n = AppLocalizations.of(context);

    final SplashDestination? destination = await viewModel.initialize(
      biometricReason: l10n.unlockPayFlowBiometricReason,
    );

    if (!mounted || destination == null) {
      return;
    }

    switch (destination) {
      case SplashDestination.login:
        context.go(AppRoutes.login);
        break;

      case SplashDestination.home:
        context.go(AppRoutes.home);
        break;
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final SplashViewModel viewModel = context.watch<SplashViewModel>();

    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),

            child: _buildContent(context, viewModel, l10n),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CONTENT
  // =========================================================

  Widget _buildContent(
    BuildContext context,
    SplashViewModel viewModel,
    AppLocalizations l10n,
  ) {
    // ---------------------------------------------------------
    // TECHNICAL ERROR
    // ---------------------------------------------------------

    if (viewModel.hasTechnicalError) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PayFlowLogo(),

          const SizedBox(height: 32),

          const Icon(
            Icons.wifi_off_rounded,
            size: 42,
            color: AppColors.primary,
          ),

          const SizedBox(height: 16),

          Text(
            l10n.startupConnectionError,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF665F5B),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: viewModel.isLoading ? null : _initializeApplication,
            child: Text(l10n.retry),
          ),
        ],
      );
    }

    // ---------------------------------------------------------
    // BIOMETRIC AUTHENTICATION FAILED / CANCELLED
    // ---------------------------------------------------------

    if (viewModel.biometricState == SplashBiometricState.failed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PayFlowLogo(),

          const SizedBox(height: 32),

          const Icon(
            Icons.fingerprint_rounded,
            size: 52,
            color: AppColors.primary,
          ),

          const SizedBox(height: 18),

          Text(
            l10n.biometricUnlockFailed,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF665F5B),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: viewModel.isLoading ? null : _initializeApplication,

            icon: const Icon(Icons.fingerprint_rounded),

            label: Text(l10n.retryBiometric),
          ),
        ],
      );
    }

    // ---------------------------------------------------------
    // BIOMETRICS NO LONGER AVAILABLE
    // ---------------------------------------------------------

    if (viewModel.biometricState == SplashBiometricState.unavailable) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PayFlowLogo(),

          const SizedBox(height: 32),

          const Icon(
            Icons.fingerprint_rounded,
            size: 52,
            color: Color(0xFF8A8481),
          ),

          const SizedBox(height: 18),

          Text(
            l10n.biometricUnlockUnavailable,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF665F5B),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: viewModel.isLoading ? null : _initializeApplication,

            child: Text(l10n.retry),
          ),
        ],
      );
    }

    // ---------------------------------------------------------
    // BIOMETRIC DIALOG IN PROGRESS
    // ---------------------------------------------------------

    if (viewModel.biometricState == SplashBiometricState.authenticating) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PayFlowLogo(),

          SizedBox(height: 32),

          Icon(Icons.fingerprint_rounded, size: 52, color: AppColors.primary),

          SizedBox(height: 24),

          CircularProgressIndicator(color: AppColors.primary),
        ],
      );
    }

    // ---------------------------------------------------------
    // NORMAL STARTUP
    // ---------------------------------------------------------

    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PayFlowLogo(),

        SizedBox(height: 24),

        CircularProgressIndicator(color: AppColors.primary),
      ],
    );
  }
}

// ===========================================================
// LOGO
// ===========================================================

class _PayFlowLogo extends StatelessWidget {
  const _PayFlowLogo();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800),

        children: [
          TextSpan(
            text: 'Pay',
            style: TextStyle(color: AppColors.secondaryDark),
          ),

          TextSpan(
            text: 'Flow',
            style: TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
