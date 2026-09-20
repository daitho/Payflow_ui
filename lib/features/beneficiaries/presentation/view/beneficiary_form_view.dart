import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/beneficiary_contact.dart';
import '../view_model/beneficiary_form_view_model.dart';
import '../widget/beneficiary_avatar.dart';
import '../widget/beneficiary_error.dart';

class BeneficiaryFormView extends StatefulWidget {
  const BeneficiaryFormView({super.key});
  @override
  State<BeneficiaryFormView> createState() => _BeneficiaryFormViewState();
}

class _BeneficiaryFormViewState extends State<BeneficiaryFormView> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(), _phone = TextEditingController();
  bool _initialized = false;
  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  InputDecoration _decoration({String? label, String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BeneficiaryFormViewModel>();
    final l10n = AppLocalizations.of(context);
    final countries = vm.catalog?.countries ?? <BeneficiaryCountry>[];
    BeneficiaryCountry? selectedCountry;
    for (final country in countries) {
      if (country.id == vm.countryId) {
        selectedCountry = country;
        break;
      }
    }
    // The prefix comes exclusively from the selected backend country.
    final dialDigits = (selectedCountry?.phoneCode ?? '').replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final dialCode = RegExp(r'^[1-9][0-9]{0,2}$').hasMatch(dialDigits)
        ? '+$dialDigits'
        : '';
    if (vm.ready && !_initialized) {
      _name.text = vm.original?.fullName ?? '';
      final storedPhone = (vm.original?.phoneE164 ?? '').replaceAll(
        RegExp(r'[\s().-]'),
        '',
      );
      // Existing contacts already store the international number. Display only
      // its national part so saving does not prepend the country code twice.
      _phone.text = dialCode.isNotEmpty && storedPhone.startsWith(dialCode)
          ? storedPhone.substring(dialCode.length)
          : '';
      _initialized = true;
    }
    final countryValid = countries.any((c) => c.id == vm.countryId);
    final operatorValid = vm.operators.any((o) => o.id == vm.operatorId);
    final phoneOnlyUnavailable =
        vm.original?.destinationId != null && vm.original?.phoneE164 == null;
    final countryItems = countries
        .map(
          (c) => DropdownMenuItem(
            value: c.id,
            child: Text(
              '${beneficiaryFlag(c.isoCode)}  ${c.name}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
    if (!countryValid && vm.countryId != null && vm.original != null) {
      countryItems.add(
        DropdownMenuItem(
          value: vm.countryId,
          child: Text(
            vm.original!.countryName,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    final operatorItems = vm.operators
        .map(
          (o) => DropdownMenuItem(
            value: o.id,
            child: Text(o.name, overflow: TextOverflow.ellipsis),
          ),
        )
        .toList();
    if (!operatorValid && vm.operatorId != null && vm.original != null) {
      operatorItems.add(
        DropdownMenuItem(
          value: vm.operatorId,
          child: Text(
            vm.original!.operatorName ?? l10n.contactUnavailable,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    final countryField = DropdownButtonFormField<String>(
      key: ValueKey('country-${vm.countryId}'),
      initialValue: vm.countryId,
      isExpanded: true,
      decoration: _decoration(label: l10n.contactCountry),
      hint: Text(l10n.contactChoose),
      items: countryItems,
      onChanged: vm.saving ? null : vm.selectCountry,
      validator: (v) => v == null ? l10n.contactRequired : null,
    );
    final operatorField = DropdownButtonFormField<String>(
      key: ValueKey('operator-${vm.countryId}-${vm.operatorId}'),
      initialValue: vm.operatorId,
      isExpanded: true,
      decoration: _decoration(label: l10n.contactOperator),
      hint: Text(l10n.contactChoose),
      items: operatorItems,
      onChanged: vm.saving || !countryValid ? null : vm.selectOperator,
      validator: (v) => v == null ? l10n.contactRequired : null,
    );
    return PopScope(
      canPop: !vm.saving,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            vm.id == null ? l10n.contactNew : l10n.contactEdit,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
          ),
        ),
        body: vm.loading
            ? const Center(child: CircularProgressIndicator())
            : !vm.ready
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(beneficiaryError(l10n, vm.error!)),
                      TextButton(onPressed: vm.load, child: Text(l10n.retry)),
                    ],
                  ),
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(8, 24, 12, 28),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.contactInformation,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _name,
                          enabled: !vm.saving,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          decoration: _decoration(hint: l10n.contactFullName),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? l10n.contactRequired
                              : v.trim().length > 120
                              ? l10n.contactNameTooLong
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phone,
                          enabled: !vm.saving && dialCode.isNotEmpty,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                              15 - dialDigits.length,
                            ),
                          ],
                          decoration: _decoration(hint: l10n.contactPhone).copyWith(
                            // A separate display widget keeps the prefix visible even
                            // when empty or unfocused, and outside the editable text.
                            prefixIcon: dialCode.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 10,
                                    ),
                                    child: Text(
                                      dialCode,
                                      textDirection: TextDirection.ltr,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                          ),
                          validator: (value) {
                            final digits = value ?? '';
                            if (dialCode.isEmpty ||
                                digits.isEmpty ||
                                !RegExp(r'^[0-9]+$').hasMatch(digits) ||
                                !RegExp(
                                  r'^\+[1-9][0-9]{6,14}$',
                                ).hasMatch('$dialCode$digits')) {
                              return l10n.contactPhoneInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) =>
                              constraints.maxWidth < 300 ||
                                  MediaQuery.textScalerOf(context).scale(14) >
                                      20
                              ? Column(
                                  children: [
                                    countryField,
                                    const SizedBox(height: 16),
                                    operatorField,
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: countryField),
                                    const SizedBox(width: 8),
                                    Expanded(child: operatorField),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          initialValue: switch (vm.gender) {
                            BeneficiaryGender.male => 1,
                            BeneficiaryGender.female => 2,
                            null => 0,
                          },
                          decoration: _decoration(label: l10n.contactGender),
                          items: [
                            DropdownMenuItem(
                              value: 0,
                              child: Text(l10n.contactUnspecified),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text(l10n.contactMale),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(l10n.contactFemale),
                            ),
                          ],
                          onChanged: vm.saving
                              ? null
                              : (v) => vm.selectGender(switch (v) {
                                  1 => BeneficiaryGender.male,
                                  2 => BeneficiaryGender.female,
                                  _ => null,
                                }),
                        ),
                        if (countries.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(l10n.contactNoOperators),
                          ),
                        if (phoneOnlyUnavailable)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(l10n.contactUnavailable),
                          ),
                        if (vm.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              beneficiaryError(l10n, vm.error!),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 40),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9800),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              vm.saving ||
                                  countries.isEmpty ||
                                  phoneOnlyUnavailable
                              ? null
                              : () async {
                                  if (!_form.currentState!.validate()) return;
                                  FocusScope.of(context).unfocus();
                                  final saved = await vm.save(
                                    _name.text,
                                    '$dialCode${_phone.text}',
                                  );
                                  if (saved != null && context.mounted)
                                    context.pop(saved);
                                },
                          child: vm.saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  vm.id == null
                                      ? l10n.contactAdd
                                      : l10n.contactSave,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
