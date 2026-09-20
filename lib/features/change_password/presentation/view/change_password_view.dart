import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/exception/change_password_exception.dart';
import '../view_model/change_password_view_model.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController =
      TextEditingController();
  final TextEditingController _confirmationPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmationPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ChangePasswordViewModel viewModel =
        context.watch<ChangePasswordViewModel>();

    return PopScope(
      canPop: !viewModel.isSubmitting,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F7F6),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF8F7F6),
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: viewModel.isSubmitting ? null : context.pop,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          title: Text(
            l10n.changePassword,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: AutofillGroup(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                _PasswordField(
                  controller: _currentPasswordController,
                  label: l10n.currentPassword,
                  obscureText: !viewModel.currentPasswordVisible,
                  enabled: !viewModel.isSubmitting,
                  autofillHints: const <String>[AutofillHints.password],
                  errorText: _currentPasswordError(
                    l10n,
                    viewModel.currentPasswordError,
                  ),
                  onChanged: viewModel.onCurrentPasswordChanged,
                  onVisibilityPressed:
                      viewModel.toggleCurrentPasswordVisibility,
                ),
                const SizedBox(height: 18),
                _PasswordField(
                  controller: _newPasswordController,
                  label: l10n.newPassword,
                  obscureText: !viewModel.newPasswordVisible,
                  enabled: !viewModel.isSubmitting,
                  autofillHints: const <String>[AutofillHints.newPassword],
                  errorText: _newPasswordError(
                    l10n,
                    viewModel.newPasswordError,
                  ),
                  onChanged: viewModel.onNewPasswordChanged,
                  onVisibilityPressed: viewModel.toggleNewPasswordVisibility,
                ),
                const SizedBox(height: 12),
                _PasswordRequirements(viewModel: viewModel),
                const SizedBox(height: 18),
                _PasswordField(
                  controller: _confirmationPasswordController,
                  label: l10n.confirmNewPassword,
                  obscureText: !viewModel.confirmationPasswordVisible,
                  enabled: !viewModel.isSubmitting,
                  autofillHints: const <String>[AutofillHints.newPassword],
                  errorText: _confirmationPasswordError(
                    l10n,
                    viewModel.confirmationPasswordError,
                  ),
                  onChanged: viewModel.onConfirmationPasswordChanged,
                  onVisibilityPressed:
                      viewModel.toggleConfirmationPasswordVisibility,
                  onSubmitted: (_) {
                    _submit(context, viewModel);
                  },
                ),
                const SizedBox(height: 20),
                _SecurityInformation(message: l10n.passwordChangeSessionInfo),
                if (viewModel.errorType != null) ...[
                  const SizedBox(height: 16),
                  _InlineError(
                    message: _requestError(l10n, viewModel.errorType!),
                  ),
                ],
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: viewModel.isSubmitting
                      ? null
                      : () {
                          _submit(context, viewModel);
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9400),
                    disabledBackgroundColor: const Color(0xFFFFC779),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: viewModel.isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.changePasswordAction,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(
    BuildContext context,
    ChangePasswordViewModel viewModel,
  ) async {
    final bool success = await viewModel.submit(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmationPassword: _confirmationPasswordController.text,
    );

    if (!success || !context.mounted) {
      return;
    }

    TextInput.finishAutofillContext();

    final AppLocalizations l10n = AppLocalizations.of(context);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF28A05A),
            size: 42,
          ),
          title: Text(l10n.passwordChangedTitle),
          content: Text(l10n.passwordChangedMessage),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.continueAction),
            ),
          ],
        );
      },
    );

    if (context.mounted) {
      context.pop();
    }
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool enabled;
  final List<String> autofillHints;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final VoidCallback onVisibilityPressed;
  final ValueChanged<String>? onSubmitted;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.enabled,
    required this.autofillHints,
    required this.errorText,
    required this.onChanged,
    required this.onVisibilityPressed,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      autofillHints: autofillHints,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction:
          onSubmitted == null ? TextInputAction.next : TextInputAction.done,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          onPressed: enabled ? onVisibilityPressed : null,
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0DCD9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0DCD9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF168C88),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  final ChangePasswordViewModel viewModel;

  const _PasswordRequirements({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAE6E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.passwordRequirementsTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF302B29),
            ),
          ),
          const SizedBox(height: 9),
          _Requirement(
            valid: viewModel.hasMinLength,
            label: l10n.passwordMinLength,
          ),
          _Requirement(
            valid: viewModel.hasUppercase,
            label: l10n.passwordUppercase,
          ),
          _Requirement(
            valid: viewModel.hasLowercase,
            label: l10n.passwordLowercase,
          ),
          _Requirement(
            valid: viewModel.hasDigit,
            label: l10n.passwordDigit,
          ),
          _Requirement(
            valid: viewModel.hasSpecialCharacter,
            label: l10n.passwordSpecial,
          ),
        ],
      ),
    );
  }
}

class _Requirement extends StatelessWidget {
  final bool valid;
  final String label;

  const _Requirement({required this.valid, required this.label});

  @override
  Widget build(BuildContext context) {
    final Color color = valid
        ? const Color(0xFF28A05A)
        : const Color(0xFF8A8582);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            valid
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 17,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.5, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityInformation extends StatelessWidget {
  final String message;

  const _SecurityInformation({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: Color(0xFF6B5C54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;

  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFD63C3C),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

String? _currentPasswordError(
  AppLocalizations l10n,
  CurrentPasswordFieldError? error,
) {
  return switch (error) {
    CurrentPasswordFieldError.required => l10n.currentPasswordRequired,
    CurrentPasswordFieldError.invalid => l10n.currentPasswordIncorrect,
    null => null,
  };
}

String? _newPasswordError(
  AppLocalizations l10n,
  NewPasswordFieldError? error,
) {
  return switch (error) {
    NewPasswordFieldError.required => l10n.newPasswordRequired,
    NewPasswordFieldError.weak => l10n.passwordInvalid,
    NewPasswordFieldError.unchanged => l10n.newPasswordUnchanged,
    null => null,
  };
}

String? _confirmationPasswordError(
  AppLocalizations l10n,
  ConfirmationPasswordFieldError? error,
) {
  return switch (error) {
    ConfirmationPasswordFieldError.required =>
      l10n.confirmNewPasswordRequired,
    ConfirmationPasswordFieldError.mismatch => l10n.passwordsDoNotMatch,
    null => null,
  };
}

String _requestError(
  AppLocalizations l10n,
  ChangePasswordErrorType error,
) {
  return switch (error) {
    ChangePasswordErrorType.passwordLoginUnavailable =>
      l10n.passwordLoginUnavailable,
    ChangePasswordErrorType.sessionExpired =>
      l10n.contactSessionError,
    ChangePasswordErrorType.network => l10n.changePasswordNetworkError,
    ChangePasswordErrorType.server => l10n.changePasswordServerError,
    ChangePasswordErrorType.unexpected =>
      l10n.changePasswordUnexpectedError,
    ChangePasswordErrorType.invalidCurrentPassword =>
      l10n.currentPasswordIncorrect,
    ChangePasswordErrorType.weakPassword => l10n.passwordInvalid,
    ChangePasswordErrorType.unchangedPassword =>
      l10n.newPasswordUnchanged,
  };
}
