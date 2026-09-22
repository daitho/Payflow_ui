import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../auth/domain/model/verification_channel.dart';
import '../view_model/authentication_methods_view_model.dart';
import 'authentication_methods_copy.dart';

class AuthenticationMethodsView extends StatelessWidget {
  const AuthenticationMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthenticationMethodsViewModel>();
    final copy = AuthenticationMethodsCopy.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          copy.title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: vm.loading && vm.email.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                _Section(copy.identifiers),
                _Card(
                  children: [
                    _MethodTile(
                      icon: Icons.alternate_email_rounded,
                      title: copy.email,
                      subtitle: vm.email,
                      verified: vm.emailVerified,
                      verifiedLabel: copy.verified,
                      verifyLabel: copy.verify,
                      onTap: vm.emailVerified || vm.loading
                          ? null
                          : () =>
                                _start(context, vm, VerificationChannel.email),
                    ),
                    const Divider(height: 1, indent: 68),
                    _MethodTile(
                      icon: Icons.phone_iphone_rounded,
                      title: copy.phone,
                      subtitle: vm.phone,
                      verified: vm.phoneVerified,
                      verifiedLabel: copy.verified,
                      verifyLabel: copy.verify,
                      onTap: vm.phoneVerified || vm.loading
                          ? null
                          : () =>
                                _start(context, vm, VerificationChannel.phone),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _Section(copy.linkedAccounts),
                _Card(
                  children: [
                    _ProviderTile(name: 'Google', status: copy.notLinked),
                    const Divider(height: 1, indent: 68),
                    _ProviderTile(name: 'Apple', status: copy.notLinked),
                    const Divider(height: 1, indent: 68),
                    _ProviderTile(name: 'Facebook', status: copy.notLinked),
                  ],
                ),
                if (vm.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    copy.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFD43C3C)),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  copy.providersLater,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF8B8582),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _start(
    BuildContext context,
    AuthenticationMethodsViewModel vm,
    VerificationChannel channel,
  ) async {
    final challenge = await vm.start(channel);
    if (!context.mounted || challenge == null) return;

    final verified = await context.push<bool>(
      AppRoutes.verifyIdentifier,
      extra: challenge,
    );
    if (verified == true) {
      await vm.load();
    }
  }
}

class _Section extends StatelessWidget {
  final String label;
  const _Section(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF8E8885),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: .7,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EDEB)),
      ),
      child: Column(children: children),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool verified;
  final String verifiedLabel;
  final String verifyLabel;
  final VoidCallback? onTap;

  const _MethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.verified,
    required this.verifiedLabel,
    required this.verifyLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE8F7F5),
        child: Icon(icon, color: const Color(0xFF167C73)),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: verified
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF2E9B62),
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  verifiedLabel,
                  style: const TextStyle(
                    color: Color(0xFF2E9B62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              verifyLabel,
              style: const TextStyle(
                color: Color(0xFFFF8A00),
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  final String name;
  final String status;
  const _ProviderTile({required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF4F2F1),
        child: Text(
          name.substring(0, 1),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      title: Text(name),
      subtitle: Text(status),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFFC1BCB9),
      ),
    );
  }
}
