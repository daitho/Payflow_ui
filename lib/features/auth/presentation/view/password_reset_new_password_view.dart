import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/exception/password_reset_exception.dart';
import '../view_model/password_reset_new_password_view_model.dart';
import 'password_reset_copy.dart';

class PasswordResetNewPasswordView extends StatelessWidget {
  const PasswordResetNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        context.watch<PasswordResetNewPasswordViewModel>();
    final copy = PasswordResetCopy.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1DE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.password_rounded,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                copy.newPasswordTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                copy.newPasswordSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),
              _PasswordField(
                hint: copy.newPasswordHint,
                visible: viewModel.passwordVisible,
                onChanged: viewModel.setPassword,
                onToggle: viewModel.togglePasswordVisibility,
              ),
              const SizedBox(height: 14),
              _PasswordField(
                hint: copy.confirmationHint,
                visible: viewModel.confirmationVisible,
                onChanged: viewModel.setConfirmation,
                onToggle: viewModel.toggleConfirmationVisibility,
                onSubmitted: (_) => _submit(context, viewModel),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      copy.passwordRules,
                      style: const TextStyle(
                        height: 1.35,
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              if (viewModel.error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error(copy, viewModel.error!),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 26),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () => _submit(context, viewModel),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                      : Text(
                          copy.savePassword,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(
    BuildContext context,
    PasswordResetNewPasswordViewModel viewModel,
  ) async {
    FocusScope.of(context).unfocus();
    final success = await viewModel.submit();
    if (!context.mounted || !success) return;
    context.go(AppRoutes.login, extra: true);
  }

  String _error(
    PasswordResetCopy copy,
    PasswordResetErrorType error,
  ) {
    return switch (error) {
      PasswordResetErrorType.weakPassword => copy.weakPassword,
      PasswordResetErrorType.passwordMismatch =>
        copy.passwordMismatch,
      PasswordResetErrorType.passwordUnchanged =>
        copy.passwordUnchanged,
      PasswordResetErrorType.invalidToken ||
      PasswordResetErrorType.expiredToken =>
        copy.invalidToken,
      PasswordResetErrorType.network => copy.networkError,
      _ => copy.unexpectedError,
    };
  }
}

class _PasswordField extends StatelessWidget {
  final String hint;
  final bool visible;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggle;
  final ValueChanged<String>? onSubmitted;

  const _PasswordField({
    required this.hint,
    required this.visible,
    required this.onChanged,
    required this.onToggle,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !visible,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: onSubmitted == null
          ? TextInputAction.next
          : TextInputAction.done,
      autofillHints: const [AutofillHints.newPassword],
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            visible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
