import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/localization/locale_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../view_model/login_error_type.dart';
import '../view_model/login_view_model.dart';
import '../../domain/model/verification_challenge_model.dart';
import 'verification_copy.dart';
import 'password_reset_copy.dart';

class LoginView extends StatefulWidget {
  final bool passwordResetCompleted;

  const LoginView({
    super.key,
    this.passwordResetCompleted = false,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _identifierController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.passwordResetCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showMessage(PasswordResetCopy.of(context).success);
      });
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenHeight = constraints.maxHeight;

            final double heroHeight = (screenHeight * 0.255)
                .clamp(205.0, 230.0)
                .toDouble();

            final double cardHeight =
                (screenHeight - 48 - 5 - heroHeight - 8 - 14)
                    .clamp(490.0, 540.0)
                    .toDouble();

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 14),
                child: Column(
                  children: [
                    _buildTopBar(),

                    const SizedBox(height: 5),

                    _buildHero(heroHeight),

                    const SizedBox(height: 8),

                    _buildLoginCard(cardHeight),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // TOP BAR
  // =========================================================

  Widget _buildTopBar() {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final bool isFrench = languageCode == 'fr';

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                final navigator = Navigator.of(context);

                if (navigator.canPop()) {
                  navigator.pop();
                }
              },
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Color(0xFF514843),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          PopupMenuButton<String>(
            tooltip: AppLocalizations.of(context).changeLanguage,
            offset: const Offset(0, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (language) {
              context.read<LocaleController>().setLocale(Locale(language));
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(
                  value: 'fr',
                  child: Text('🇫🇷  ${l10n.french}'),
                ),

                PopupMenuItem<String>(
                  value: 'en',
                  child: Text('🇬🇧  ${l10n.english}'),
                ),
              ];
            },
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.055),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isFrench ? '🇫🇷' : '🇬🇧',
                    style: const TextStyle(fontSize: 19),
                  ),

                  const SizedBox(width: 7),

                  Text(
                    isFrench ? 'FR' : 'EN',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 2),

                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 19,
                    color: Color(0xFF272727),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HERO
  // =========================================================

  Widget _buildHero(double height) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ---------------------------------------------------
          // Globe
          // ---------------------------------------------------
          Positioned(
            top: -5,
            right: -2,
            child: Image.asset(
              'assets/images/login/login_globe.png',
              width: 192,
              height: 185,
              fit: BoxFit.contain,
            ),
          ),

          // ---------------------------------------------------
          // Logo PayFlow
          // ---------------------------------------------------
          Positioned(
            left: 7,
            top: 112,
            child: Image.asset(
              'assets/images/login/payflow_logo.png',
              width: 198,
              fit: BoxFit.contain,
            ),
          ),

          // ---------------------------------------------------
          // Slogan
          // ---------------------------------------------------
          Positioned(
            left: 9,
            top: 166,
            right: 50,
            child: Text(
              AppLocalizations.of(context).loginTagline,
              style: const TextStyle(
                fontSize: 17,
                height: 1.38,
                letterSpacing: 0.05,
                color: Color(0xFF68615E),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LOGIN CARD
  // =========================================================

  Widget _buildLoginCard(double cardHeight) {
    final viewModel = context.watch<LoginViewModel>();
    return Container(
      width: double.infinity,
      height: cardHeight,
      padding: const EdgeInsets.fromLTRB(18, 21, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          // ---------------------------------------------------
          // Email / téléphone
          // ---------------------------------------------------
          _buildIdentifierBlock(),

          const SizedBox(height: 2),

          // ---------------------------------------------------
          // Password
          // ---------------------------------------------------
          _buildPasswordBlock(),

          // ---------------------------------------------------
          // Forgotten password
          // ---------------------------------------------------
          SizedBox(
            height: 35,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgotPassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppLocalizations.of(context).forgotPassword,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          // ---------------------------------------------------
          // Login button
          // ---------------------------------------------------
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: viewModel.isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                elevation: 2,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).signIn,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          const _OrDivider(),
          const SizedBox(height: 18),

          // ---------------------------------------------------
          // Apple / Google / Facebook
          // ---------------------------------------------------
          _buildSocialButtons(),

          // ---------------------------------------------------
          // Ce Spacer est maintenant volontaire :
          // la carte a une hauteur calculée selon l'écran.
          //
          // Il garde l'inscription au bas de la carte.
          // ---------------------------------------------------
          const Spacer(),

          _buildRegisterLink(),
        ],
      ),
    );
  }

  // =========================================================
  // IDENTIFIER
  // =========================================================
  Widget _buildIdentifierBlock() {
    final LoginViewModel viewModel = context.watch<LoginViewModel>();
    return SizedBox(
      height: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 58,
            child: TextField(
              controller: _identifierController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                viewModel.onIdentifierChanged(value);
              },
              style: const TextStyle(fontSize: 15, color: Color(0xFF403B38)),
              decoration: _inputDecoration(
                hint: AppLocalizations.of(context).emailOrPhone,
                icon: Icons.mail_outline_rounded,
                hasError: viewModel.identifierHasError,
              ),
            ),
          ),
          SizedBox(
            height: 18,
            child: viewModel.identifierHasError
                ? Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),
                    child: Text(
                      AppLocalizations.of(context).emailOrPhoneRequired,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PASSWORD
  // =========================================================

  Widget _buildPasswordBlock() {
    final LoginViewModel viewModel = context.watch<LoginViewModel>();
    return SizedBox(
      height: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 58,
            child: TextField(
              controller: _passwordController,
              obscureText: !viewModel.passwordVisible,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                _login();
              },
              onChanged: (value) {
                viewModel.onPasswordChanged(value);
              },
              style: const TextStyle(fontSize: 15, color: Color(0xFF403B38)),
              decoration: _inputDecoration(
                hint: AppLocalizations.of(context).password,
                icon: Icons.lock_outline_rounded,
                hasError: viewModel.passwordHasError,
                suffix: IconButton(
                  onPressed: () {
                    viewModel.togglePasswordVisibility();
                  },
                  icon: Icon(
                    viewModel.passwordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 22,
                    color: const Color(0xFF514843),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
            child: viewModel.passwordHasError
                ? Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),
                    child: Text(
                      AppLocalizations.of(context).passwordRequired,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool hasError,
    Widget? suffix,
  }) {
    final Color borderColor = hasError
        ? const Color(0xFFE53935)
        : const Color(0xFFE5E2E0);

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 15, color: Color(0xFF77716E)),
      prefixIcon: Icon(icon, size: 21, color: const Color(0xFF514843)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: hasError ? 1.2 : 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: hasError ? const Color(0xFFE53935) : AppColors.primary,
          width: 1.4,
        ),
      ),
    );
  }

  // =========================================================
  // SOCIAL BUTTONS
  // =========================================================

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          asset: 'assets/images/login/apple_logo.png',
          imageSize: 31,
          onTap: () {
            _socialLogin('Apple');
          },
        ),

        const SizedBox(width: 19),

        _SocialButton(
          asset: 'assets/images/login/google_logo.png',
          imageSize: 32,
          onTap: () {
            _socialLogin('Google');
          },
        ),

        const SizedBox(width: 19),

        _SocialButton(
          asset: 'assets/images/login/facebook_logo.png',
          imageSize: 31,
          onTap: () {
            _socialLogin('Facebook');
          },
        ),
      ],
    );
  }

  // =========================================================
  // REGISTER
  // =========================================================

  Widget _buildRegisterLink() {
    return SizedBox(
      height: 38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).noAccount,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF333333)),
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                context.push(AppRoutes.register);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
                child: Text(
                  AppLocalizations.of(context).signUp,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LOGIN
  // =========================================================
  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    final String identifier = _identifierController.text.trim();
    final String password = _passwordController.text;

    // =========================================================
    // LOGIN
    // =========================================================
    final LoginViewModel viewModel = context.read<LoginViewModel>();
    final bool success = await viewModel.submit(
      email: identifier,
      password: password,
    );
    if (!mounted) {
      return;
    }
    // =========================================================
    // LOGIN FAILED
    // =========================================================
    if (!success) {
      final LoginErrorType? error = viewModel.loginError;

      if (error == LoginErrorType.identifierNotVerified) {
        await _offerVerificationRecovery(viewModel);
      } else if (error != null) {
        _showMessage(_loginErrorMessage(error));
      }
      return;
    }
    // =========================================================
    // LOGIN SUCCESS
    // =========================================================
    debugPrint('[AUTH] Navigating to Home');
    context.go(AppRoutes.home);
  }

  String _loginErrorMessage(LoginErrorType error) {
    final l10n = AppLocalizations.of(context);
    switch (error) {
      case LoginErrorType.invalidCredentials:
        return l10n.invalidCredentials;
      case LoginErrorType.identifierNotVerified:
        return VerificationCopy.of(context).recoveryMessage;
      case LoginErrorType.network:
        return l10n.loginNetworkError;
      case LoginErrorType.timeout:
        return l10n.loginTimeoutError;
      case LoginErrorType.server:
        return l10n.loginServerError;
      case LoginErrorType.unexpected:
        return l10n.loginUnexpectedError;
    }
  }

  Future<void> _offerVerificationRecovery(LoginViewModel viewModel) async {
    final copy = VerificationCopy.of(context);
    final bool? resume = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(copy.recoveryTitle),
        content: Text(copy.recoveryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(copy.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(copy.recoveryAction),
          ),
        ],
      ),
    );

    if (resume != true || !mounted) return;

    final VerificationChallengeModel? challenge = await viewModel
        .recoverVerification(
          identifier: _identifierController.text,
          password: _passwordController.text,
        );

    if (!mounted) return;
    if (challenge == null) {
      _showMessage(
        _loginErrorMessage(viewModel.loginError ?? LoginErrorType.unexpected),
      );
      return;
    }

    context.push(AppRoutes.verifyRegistration, extra: challenge);
  }

  // =========================================================
  // FORGOT PASSWORD
  // =========================================================
  void _forgotPassword() {
    context.push(
      AppRoutes.forgotPassword,
      extra: _identifierController.text.trim(),
    );
  }

  // =========================================================
  // SOCIAL LOGIN
  // =========================================================
  void _socialLogin(String provider) {
    _showMessage(AppLocalizations.of(context).socialLoginMessage(provider));
  }

  // =========================================================
  // MESSAGE
  // =========================================================

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }
}

// ===========================================================
// OR DIVIDER
// ===========================================================

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 20,
      child: Row(
        children: [
          const Expanded(
            child: Divider(color: Color(0xFFE2D1C6), thickness: 1),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              l10n.or,
              style: const TextStyle(fontSize: 13, color: Color(0xFF45413F)),
            ),
          ),

          const Expanded(
            child: Divider(color: Color(0xFFE2D1C6), thickness: 1),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// SOCIAL BUTTON
// ===========================================================

class _SocialButton extends StatelessWidget {
  final String asset;
  final double imageSize;
  final VoidCallback onTap;

  const _SocialButton({
    required this.asset,
    required this.imageSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 58,
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE4E2E0)),
          ),
          child: Image.asset(
            asset,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
