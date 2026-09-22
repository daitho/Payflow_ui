import 'package:flutter/widgets.dart';

class BeneficiaryFormCopy {
  final String confirmPhone;
  final String phoneMismatch;
  final String chooseDialCode;

  const BeneficiaryFormCopy({
    required this.confirmPhone,
    required this.phoneMismatch,
    required this.chooseDialCode,
  });

  static BeneficiaryFormCopy of(BuildContext context) =>
      _values[Localizations.localeOf(context).languageCode] ??
      _values['fr']!;

  static const _values = <String, BeneficiaryFormCopy>{
    'fr': BeneficiaryFormCopy(
      confirmPhone: 'Confirmer le numéro de téléphone',
      phoneMismatch: 'Les deux numéros ne correspondent pas.',
      chooseDialCode: 'Choisir le pays et l’indicatif',
    ),
    'en': BeneficiaryFormCopy(
      confirmPhone: 'Confirm phone number',
      phoneMismatch: 'The two phone numbers do not match.',
      chooseDialCode: 'Choose country and calling code',
    ),
    'es': BeneficiaryFormCopy(
      confirmPhone: 'Confirmar número de teléfono',
      phoneMismatch: 'Los dos números no coinciden.',
      chooseDialCode: 'Elegir país y prefijo',
    ),
    'zh': BeneficiaryFormCopy(
      confirmPhone: '确认手机号码',
      phoneMismatch: '两次输入的号码不一致。',
      chooseDialCode: '选择国家和区号',
    ),
    'hi': BeneficiaryFormCopy(
      confirmPhone: 'फ़ोन नंबर की पुष्टि करें',
      phoneMismatch: 'दोनों फ़ोन नंबर मेल नहीं खाते।',
      chooseDialCode: 'देश और कॉलिंग कोड चुनें',
    ),
  };
}
