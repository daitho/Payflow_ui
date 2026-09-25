import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/exception/password_reset_exception.dart';
import '../../domain/model/verification_channel.dart';
import '../view_model/password_reset_code_view_model.dart';
import 'password_reset_copy.dart';

class PasswordResetCodeView extends StatefulWidget {
  const PasswordResetCodeView({super.key});

  @override
  State<PasswordResetCodeView> createState() =>
      _PasswordResetCodeViewState();
}

class _PasswordResetCodeViewState
    extends State<PasswordResetCodeView> {
  final TextEditingController _codeController =
      TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        context.watch<PasswordResetCodeViewModel>();
    final copy = PasswordResetCopy.of(context);

    if (_codeController.text != viewModel.code) {
      _codeController.value = TextEditingValue(
        text: viewModel.code,
        selection: TextSelection.collapsed(
          offset: viewModel.code.length,
        ),
      );
    }

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
                  child: Icon(
                    viewModel.challenge.channel ==
                            VerificationChannel.email
                        ? Icons.mark_email_read_outlined
                        : Icons.sms_outlined,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                copy.codeTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${copy.codeSent}\n'
                '${viewModel.challenge.maskedDestination}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 34),
              TextField(
                controller: _codeController,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: viewModel.setCode,
                onSubmitted: (_) => _verify(viewModel),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 13,
                ),
                decoration: InputDecoration(
                  hintText: '••••••',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              if (viewModel.error != null) ...[
                const SizedBox(height: 12),
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
                  onPressed: viewModel.canSubmit
                      ? () => _verify(viewModel)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: viewModel.isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                      : Text(
                          copy.verify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: viewModel.canResend
                    ? viewModel.resend
                    : null,
                child: viewModel.isResending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        viewModel.canResend
                            ? copy.resend
                            : '${copy.resendIn} '
                                  '${viewModel.secondsUntilResend}s',
                      ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        copy.securityNote,
                        style: const TextStyle(
                          height: 1.4,
                          fontSize: 12.5,
                          color: Color(0xFF6B5B4C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verify(
    PasswordResetCodeViewModel viewModel,
  ) async {
    FocusScope.of(context).unfocus();
    final token = await viewModel.verify();
    if (!mounted || token == null) return;
    context.pushReplacement(
      AppRoutes.resetPassword,
      extra: token,
    );
  }

  String _error(
    PasswordResetCopy copy,
    PasswordResetErrorType error,
  ) {
    return switch (error) {
      PasswordResetErrorType.invalidCode => copy.invalidCode,
      PasswordResetErrorType.expiredCode => copy.expiredCode,
      PasswordResetErrorType.tooManyAttempts =>
        copy.tooManyAttempts,
      PasswordResetErrorType.resendTooSoon => copy.resendIn,
      PasswordResetErrorType.channelUnavailable =>
        copy.channelUnavailable,
      PasswordResetErrorType.network => copy.networkError,
      _ => copy.unexpectedError,
    };
  }
}
