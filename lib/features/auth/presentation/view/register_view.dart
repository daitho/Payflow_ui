import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';

import '../../../../app/localization/locale_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../view_model/register_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  Country? _selectedCountry;
  final FocusNode _passwordFocusNode = FocusNode();

  bool _showPasswordRules = false;

  // =========================================================
  // CONTROLLERS
  // =========================================================

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCountry = Country.parse('FR');
    _passwordFocusNode.addListener(() {
      setState(() {
        _showPasswordRules = _passwordFocusNode.hasFocus;
      });
    });
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: const ['FR', 'CM'],
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    context.watch<RegisterViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 24),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 4),
              _buildHeader(),
              const SizedBox(height: 10),
              _buildRegisterCard(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // TOP BAR
  // =========================================================

  Widget _buildTopBar() {
    final l10n = AppLocalizations.of(context);
    final String languageCode = Localizations.localeOf(context).languageCode;
    final bool isFrench = languageCode == 'fr';
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // ---------------------------------------------------
          // BACK
          // ---------------------------------------------------
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }
                context.go(AppRoutes.login);
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

          // ---------------------------------------------------
          // LANGUAGE
          // ---------------------------------------------------
          PopupMenuButton<String>(
            tooltip: l10n.changeLanguage,
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
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ---------------------------------------------------
          // GLOBE
          // ---------------------------------------------------
          Positioned(
            right: -3,
            top: -5,
            child: Image.asset(
              'assets/images/login/login_globe.png',
              width: 165,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),

          // ---------------------------------------------------
          // PAYFLOW LOGO
          // ---------------------------------------------------
          Positioned(
            left: 7,
            top: 67,
            child: Image.asset(
              'assets/images/login/payflow_logo.png',
              width: 185,
              fit: BoxFit.contain,
            ),
          ),

          // ---------------------------------------------------
          // TITLE
          // ---------------------------------------------------
          Positioned(
            left: 8,
            top: 122,
            child: Text(
              l10n.createYourAccount,
              style: const TextStyle(
                fontSize: 18,
                height: 1.3,
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
  // REGISTER CARD
  // =========================================================

  Widget _buildRegisterCard() {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
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
          // ===================================================
          // FIRST NAME + LAST NAME
          // ===================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                child: _buildInputBlock(
                  controller: _firstNameController,
                  hint: l10n.firstName,
                  icon: Icons.person_outline_rounded,
                  hasError: context.read<RegisterViewModel>().firstNameHasError,
                  errorText: l10n.firstNameRequired,

                  textInputAction: TextInputAction.next,

                  onChanged: (value) {
                    if (context.read<RegisterViewModel>().firstNameHasError &&
                        value.trim().isNotEmpty) {
                      context.read<RegisterViewModel>().onFirstNameChanged(
                        value,
                      );
                    }
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildInputBlock(
                  controller: _lastNameController,
                  hint: l10n.lastName,
                  icon: Icons.person_outline_rounded,
                  hasError: context.read<RegisterViewModel>().lastNameHasError,
                  errorText: l10n.lastNameRequired,

                  textInputAction: TextInputAction.next,

                  onChanged: (value) {
                    if (context.read<RegisterViewModel>().lastNameHasError &&
                        value.trim().isNotEmpty) {
                      setState(() {
                        context.read<RegisterViewModel>().onLastNameChanged(
                          value,
                        );
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          // ===================================================
          // EMAIL
          // ===================================================
          _buildInputBlock(
            controller: _emailController,

            hint: l10n.email,

            icon: Icons.mail_outline_rounded,

            keyboardType: TextInputType.emailAddress,

            textInputAction: TextInputAction.next,

            hasError: context.read<RegisterViewModel>().emailHasError,

            errorText: l10n.emailRequired,

            onChanged: (value) {
              if (context.read<RegisterViewModel>().emailHasError &&
                  value.trim().isNotEmpty) {
                setState(() {
                  context.read<RegisterViewModel>().onEmailChanged(value);
                });
              }
            },
          ),

          const SizedBox(height: 2),

          // ===================================================
          // PHONE
          // ===================================================
          _buildPhoneBlock(),

          const SizedBox(height: 2),

          // ===================================================
          // PASSWORD
          // ===================================================
          _buildPasswordBlock(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            hint: l10n.password,
            visible: context.read<RegisterViewModel>().passwordVisible,
            hasError: context.read<RegisterViewModel>().passwordHasError,
            errorText: l10n.passwordRequired,
            textInputAction: TextInputAction.next,

            onVisibilityChanged: () {
              setState(() {
                context.read<RegisterViewModel>().togglePasswordVisibility();
              });
            },

            onChanged: (value) {
              context.read<RegisterViewModel>().onPasswordChanged(value);
            },
          ),

          if (_showPasswordRules) _buildPasswordRules(),

          const SizedBox(height: 2),

          // ===================================================
          // CONFIRM PASSWORD
          // ===================================================
          _buildPasswordBlock(
            controller: _confirmPasswordController,

            hint: l10n.confirmPassword,

            visible: context.read<RegisterViewModel>().confirmPasswordVisible,

            hasError:
                context.read<RegisterViewModel>().confirmPasswordHasError ||
                context.read<RegisterViewModel>().passwordMismatch,

            errorText: context.read<RegisterViewModel>().passwordMismatch
                ? l10n.passwordsDoNotMatch
                : l10n.confirmPasswordRequired,

            textInputAction: TextInputAction.done,

            onSubmitted: (_) {
              _register();
            },

            onVisibilityChanged: () {
              setState(() {
                context
                    .read<RegisterViewModel>()
                    .toggleConfirmPasswordVisibility();
              });
            },
            onChanged: context
                .read<RegisterViewModel>()
                .onConfirmPasswordChanged,
          ),

          const SizedBox(height: 4),

          // ===================================================
          // TERMS
          // ===================================================
          _buildTerms(),

          const SizedBox(height: 14),

          // ===================================================
          // CREATE ACCOUNT
          // ===================================================
          SizedBox(
            width: double.infinity,
            height: 58,

            child: ElevatedButton(
              onPressed: _register,

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
                l10n.createAccount,

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ===================================================
          // LOGIN LINK
          // ===================================================
          _buildLoginLink(),
        ],
      ),
    );
  }

  // =========================================================
  // STANDARD INPUT
  // =========================================================

  Widget _buildInputBlock({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool hasError,
    required String errorText,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return SizedBox(
      height: 76,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            height: 58,

            child: TextField(
              controller: controller,

              keyboardType: keyboardType,

              textInputAction: textInputAction,

              onChanged: onChanged,

              style: const TextStyle(fontSize: 15, color: Color(0xFF403B38)),

              decoration: _inputDecoration(
                hint: hint,
                icon: icon,
                hasError: hasError,
              ),
            ),
          ),

          SizedBox(
            height: 18,

            child: hasError
                ? Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),

                    child: Text(
                      errorText,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

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
  // PHONE
  // =========================================================

  Widget _buildPhoneBlock() {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<RegisterViewModel>();
    final country = _selectedCountry!;
    return SizedBox(
      height: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 58,
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,

              // ===============================================
              // CHIFFRES UNIQUEMENT
              // ===============================================
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,

                LengthLimitingTextInputFormatter(15),
              ],

              onChanged: (value) {
                viewModel.onPhoneChanged(value);
              },

              style: const TextStyle(fontSize: 15, color: Color(0xFF403B38)),

              decoration: InputDecoration(
                hintText: l10n.phoneNumber,

                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF77716E),
                ),

                filled: true,
                fillColor: Colors.white,

                // =============================================
                // COUNTRY / DIAL CODE
                // =============================================
                prefixIconConstraints: const BoxConstraints(minWidth: 100),

                prefixIcon: InkWell(
                  borderRadius: BorderRadius.circular(12),

                  onTap: _selectCountry,

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Text(
                          country.flagEmoji,

                          style: const TextStyle(fontSize: 19),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          '+${country.phoneCode}',

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF514843),
                          ),
                        ),

                        const SizedBox(width: 2),

                        const Icon(
                          Icons.keyboard_arrow_down_rounded,

                          size: 18,

                          color: Color(0xFF514843),
                        ),
                      ],
                    ),
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(
                    color: viewModel.phoneHasError
                        ? const Color(0xFFE53935)
                        : const Color(0xFFE5E2E0),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(
                    color: viewModel.phoneHasError
                        ? const Color(0xFFE53935)
                        : AppColors.primary,

                    width: 1.4,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 18,

            child: viewModel.phoneHasError
                ? Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),

                    child: Text(
                      l10n.phoneRequired,

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

  Widget _buildPasswordBlock({
    required TextEditingController controller,
    required String hint,
    required bool visible,
    required bool hasError,
    required String errorText,
    required VoidCallback onVisibilityChanged,
    required ValueChanged<String> onChanged,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
  }) {
    return SizedBox(
      height: 76,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            height: 58,

            child: TextField(
              controller: controller,

              obscureText: !visible,

              textInputAction: textInputAction,

              onSubmitted: onSubmitted,

              onChanged: onChanged,

              focusNode: focusNode,

              style: const TextStyle(fontSize: 15, color: Color(0xFF403B38)),

              decoration: _inputDecoration(
                hint: hint,

                icon: Icons.lock_outline_rounded,

                hasError: hasError,

                suffix: IconButton(
                  onPressed: onVisibilityChanged,

                  icon: Icon(
                    visible
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

            child: hasError
                ? Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),

                    child: Text(
                      errorText,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

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
  // TERMS
  // =========================================================

  Widget _buildTerms() {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 38,
              height: 38,
              child: Checkbox(
                value: context.read<RegisterViewModel>().termsAccepted,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  context.read<RegisterViewModel>().setTermsAccepted(
                    value ?? false,
                  );
                },
              ),
            ),

            const SizedBox(width: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('${l10n.acceptTermsPrefix} '),

                    InkWell(
                      onTap: _openTerms,

                      child: Text(
                        l10n.termsAndConditions,

                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(' ${l10n.and} '),

                    InkWell(
                      onTap: _openPrivacyPolicy,

                      child: Text(
                        l10n.privacyPolicy,

                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: 18,

          child: context.read<RegisterViewModel>().termsHasError
              ? Padding(
                  padding: const EdgeInsets.only(left: 43, top: 2),

                  child: Text(
                    l10n.termsRequired,

                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFFE53935),
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }

  // =========================================================
  // LOGIN LINK
  // =========================================================

  Widget _buildLoginLink() {
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Flexible(
          child: Text(
            '${l10n.alreadyHaveAccount} ',

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 13.5, color: Color(0xFF333333)),
          ),
        ),

        Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius: BorderRadius.circular(8),

            onTap: () {
              context.go(AppRoutes.login);
            },

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),

              child: Text(
                l10n.signIn,

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
    );
  }

  // =========================================================
  // REGISTER ACTION
  // =========================================================

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    final viewModel = context.read<RegisterViewModel>();
    final country = _selectedCountry!;
    final String phoneE164 =
        '+${country.phoneCode}'
        '${_phoneController.text.trim()}';

    final bool valid = await viewModel.submit(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneE164: phoneE164,
      residenceCountryIsoCode2: country.countryCode,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    if (!mounted) {
      return;
    }
    if (!valid) {
      final message = viewModel.errorMessage;
      if (message != null) {
        _showMessage(message);
      }
      return;
    }
    final challenge = viewModel.challenge;
    if (challenge == null) {
      return;
    }
    context.push(AppRoutes.verifyRegistration, extra: challenge);
  }

  // =========================================================
  // TERMS ACTION
  // =========================================================

  void _openTerms() {
    // TODO :
    // route vers Conditions générales
  }

  // =========================================================
  // PRIVACY ACTION
  // =========================================================

  void _openPrivacyPolicy() {
    // TODO :
    // route vers Politique de confidentialité
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

        duration: const Duration(seconds: 4),
      ),
    );
  }

  Widget _buildPasswordRules() {
    final l10n = AppLocalizations.of(context);

    final viewModel = context.watch<RegisterViewModel>();

    final String password = viewModel.password;

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            l10n.passwordRequirementsTitle,

            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 7),

          _PasswordRule(
            valid: viewModel.hasMinLength(password),
            label: l10n.passwordMinLength,
          ),

          _PasswordRule(
            valid: viewModel.hasUppercase(password),
            label: l10n.passwordUppercase,
          ),

          _PasswordRule(
            valid: viewModel.hasLowercase(password),
            label: l10n.passwordLowercase,
          ),

          _PasswordRule(
            valid: viewModel.hasDigit(password),
            label: l10n.passwordDigit,
          ),

          _PasswordRule(
            valid: viewModel.hasSpecialCharacter(password),
            label: l10n.passwordSpecial,
          ),
        ],
      ),
    );
  }
}

class _PasswordRule extends StatelessWidget {
  final bool valid;
  final String label;

  const _PasswordRule({required this.valid, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),

      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle_rounded : Icons.radio_button_unchecked,

            size: 17,

            color: valid ? const Color(0xFF43A047) : const Color(0xFF9E9E9E),
          ),

          const SizedBox(width: 7),

          Text(
            label,

            style: TextStyle(
              fontSize: 12,

              color: valid ? const Color(0xFF43A047) : const Color(0xFF6E6865),
            ),
          ),
        ],
      ),
    );
  }
}
