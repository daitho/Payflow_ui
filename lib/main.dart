import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/localization/locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeController = LocaleController();
  await localeController.load();

  runApp(PayFlowApp(localeController: localeController));
}
