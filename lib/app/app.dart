import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import 'localization/locale_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PayFlowApp extends StatelessWidget {
  final LocaleController localeController;

  const PayFlowApp({required this.localeController, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: localeController,
      child: const _PayFlowMaterialApp(),
    );
  }
}

class _PayFlowMaterialApp extends StatelessWidget {
  const _PayFlowMaterialApp();

  @override
  Widget build(BuildContext context) {
    final localeController = context.watch<LocaleController>();

    return MaterialApp.router(
      title: 'PayFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: localeController.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
    );
  }
}
