import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/exception/verification_exception.dart';
import '../../domain/model/verification_channel.dart';
import '../view_model/verification_view_model.dart';
import 'verification_copy.dart';

class VerificationCodeView extends StatefulWidget {
  const VerificationCodeView({super.key});

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VerificationViewModel>();
    final copy = VerificationCopy.of(context);
    final isEmail = viewModel.channel == VerificationChannel.email;

    if (_codeController.text != viewModel.code) {
      _codeController.value = TextEditingValue(
        text: viewModel.code,
        selection: TextSelection.collapsed(offset: viewModel.code.length),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (viewModel.isRegistration) {
              context.go(AppRoutes.login);
            } else {
              context.pop(false);
            }
          },
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF1DE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isEmail ? Icons.mark_email_read_outlined : Icons.sms_outlined,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isEmail ? copy.emailTitle : copy.phoneTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF292524),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                copy.sentTo + '\n' + viewModel.maskedDestination,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  color: Color(0xFF7A7471),
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
                onSubmitted: (_) => _confirm(viewModel),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 13,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  hintStyle: const TextStyle(
                    color: Color(0xFFD0CBC8),
                    letterSpacing: 13,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: viewModel.error == null
                          ? const Color(0xFFE4E0DE)
                          : const Color(0xFFD94343),
                    ),
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
                    color: Color(0xFFD43C3C),
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: viewModel.canSubmit
                      ? () => _confirm(viewModel)
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
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          copy.confirm,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: viewModel.canResend
                    ? () => viewModel.resend()
                    : null,
                child: viewModel.isResending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        viewModel.canResend
                            ? copy.resend
                            : copy.resendIn +
                                  ' ' +
                                  viewModel.secondsUntilResend.toString() +
                                  's',
                      ),
              ),
              TextButton.icon(
                onPressed: viewModel.canResend
                    ? () => viewModel.resend(
                        channel: viewModel.channel.alternative,
                      )
                    : null,
                icon: Icon(
                  isEmail ? Icons.sms_outlined : Icons.alternate_email_rounded,
                  size: 19,
                ),
                label: Text(isEmail ? copy.usePhone : copy.useEmail),
              ),
              const SizedBox(height: 22),
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

  Future<void> _confirm(VerificationViewModel viewModel) async {
    final success = await viewModel.confirm();
    if (!mounted || !success) return;
    if (viewModel.isRegistration) {
      context.go(AppRoutes.home);
    } else {
      context.pop(true);
    }
  }

  String _error(VerificationCopy copy, VerificationErrorType type) {
    return switch (type) {
      VerificationErrorType.invalidCode => copy.invalidCode,
      VerificationErrorType.expired => copy.expired,
      VerificationErrorType.tooManyAttempts => copy.tooManyAttempts,
      VerificationErrorType.resendTooSoon => copy.resendIn,
      VerificationErrorType.channelUnavailable => copy.channelUnavailable,
      VerificationErrorType.network => copy.networkError,
      VerificationErrorType.unexpected => copy.unexpectedError,
    };
  }
}
