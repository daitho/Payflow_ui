import 'package:flutter/material.dart';

/// Shared by Login and Profile so provider branding never drifts between them.
class SocialProviderLogo extends StatelessWidget {
  final String provider;

  const SocialProviderLogo({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final name = provider.toUpperCase();
    final (asset, size, label) = switch (name) {
      'APPLE' => ('assets/images/login/apple_logo.png', 31.0, 'Apple'),
      'GOOGLE' => ('assets/images/login/google_logo.png', 32.0, 'Google'),
      'FACEBOOK' => ('assets/images/login/facebook_logo.png', 31.0, 'Facebook'),
      _ => throw ArgumentError.value(provider, 'provider'),
    };
    return Image.asset(
      asset, width: size, height: size, fit: BoxFit.contain,
      semanticLabel: label,
    );
  }
}
