import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/exception/password_reset_exception.dart';
import '../view_model/password_reset_request_view_model.dart';
import 'password_reset_copy.dart';

class PasswordResetRequestView extends StatefulWidget {
  const PasswordResetRequestView({super.key});

  @override
  State<PasswordResetRequestView> createState() =>
      _PasswordResetRequestViewState();
}

class _PasswordResetRequestViewState
    extends State<PasswordResetRequestView> {
  final TextEditingController _identifierController =
      TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _identifierController.text = context
          .read<PasswordResetRequestViewModel>()
          .identifier;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        context.watch<PasswordResetRequestViewModel>();
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
              const _ResetIcon(icon: Icons.lock_reset_rounded),
              const SizedBox(height: 24),
              Text(
                copy.requestTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                copy.requestSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 34),
              TextField(
                controller: _identifierController,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onChanged: viewModel.setIdentifier,
                onSubmitted: (_) => _submit(viewModel),
                decoration: InputDecoration(
                  hintText: copy.identifierHint,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                  ),
                  errorText: viewModel.identifierHasError
                      ? copy.identifierRequired
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.border,
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
                      : () => _submit(viewModel),
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
                          copy.continueLabel,
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
    PasswordResetRequestViewModel viewModel,
  ) async {
    FocusScope.of(context).unfocus();
    final challenge = await viewModel.submit();
    if (!mounted || challenge == null) return;
    context.push(
      AppRoutes.verifyPasswordReset,
      extra: challenge,
    );
  }

  String _error(
    PasswordResetCopy copy,
    PasswordResetErrorType error,
  ) {
    return switch (error) {
      PasswordResetErrorType.channelUnavailable =>
        copy.channelUnavailable,
      PasswordResetErrorType.network => copy.networkError,
      _ => copy.unexpectedError,
    };
  }
}

class _ResetIcon extends StatelessWidget {
  final IconData icon;

  const _ResetIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 76,
        height: 76,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF1DE),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 38,
        ),
      ),
    );
  }
}
