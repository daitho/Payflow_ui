import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../beneficiaries/domain/model/beneficiary_contact.dart';
import '../../../beneficiaries/presentation/widget/beneficiary_avatar.dart';
import '../../domain/exception/transfer_exception.dart';
import '../../domain/model/transfer_quote.dart';
import '../view_model/transfer_view_model.dart';

class TransferView extends StatefulWidget {
  const TransferView({super.key});
  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  late final TextEditingController _amount;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(
      text: context.read<TransferViewModel>().initialAmountText,
    );
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _chooseBeneficiary(TransferViewModel vm) async {
    final selected = await context.push<BeneficiaryContact>(
      AppRoutes.transferBeneficiaryPicker,
    );
    if (selected != null && mounted) vm.selectBeneficiary(selected);
  }

  Future<void> _continue(TransferViewModel vm) async {
    FocusScope.of(context).unfocus();
    final quote = await vm.ensureQuote();
    if (!mounted) return;
    if (quote == null) {
      _showError(vm.error);
      return;
    }
    final confirmedTransferId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => _TransferReviewSheet(
        viewModel: vm,
        onConfirmed: (transferId) {
          Navigator.of(sheetContext).pop(transferId);
        },
      ),
    );
    if (mounted && confirmedTransferId != null) {
      context.pop(confirmedTransferId);
    }
  }

  void _showError(TransferFailure? failure) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(_errorText(l10n, failure))));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferViewModel>();
    final l10n = AppLocalizations.of(context);
    final contact = vm.beneficiary;
    final quote = vm.quote;
    final flag = contact == null ? '' : beneficiaryFlag(contact.countryCode);
    return PopScope(
      canPop: !vm.confirming,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFDFD),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: vm.confirming ? null : () => context.pop(),
                          icon: const Icon(Icons.close_rounded, size: 28),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.transferSendTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF262329),
                              ),
                            ),
                          ),
                          if (contact != null)
                            Text(
                              ('$flag ' + contact.countryName).trim(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF38333A),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _BeneficiaryCard(
                        contact: contact,
                        loading: vm.initializing,
                        onTap: vm.confirming
                            ? null
                            : () => _chooseBeneficiary(vm),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _AmountField(
                              label: l10n.transferYouSend,
                              controller: _amount,
                              currency: vm.sentCurrency,
                              enabled: !vm.confirming,
                              onChanged: vm.setSentAmount,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ReceivedAmountCard(
                              label: l10n.transferAmountReceived,
                              amount: quote?.receivedAmount,
                              currency:
                                  quote?.receivedCurrency ??
                                  contact?.currencyCode,
                              loading: vm.quoting,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Text(
                        l10n.transferFundingLabel.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF777274),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 9),
                      DropdownButtonFormField<TransferFundingMethod>(
                        initialValue: vm.fundingMethod,
                        decoration: _fieldDecoration().copyWith(
                          prefixIcon: const Icon(
                            Icons.credit_card_rounded,
                            color: Color(0xFF24466E),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: TransferFundingMethod.card,
                            child: Text(l10n.transferFundingCard),
                          ),
                        ],
                        onChanged: vm.confirming
                            ? null
                            : (value) {
                                if (value != null) {
                                  vm.selectFundingMethod(value);
                                }
                              },
                      ),
                      const SizedBox(height: 24),
                      if (quote != null) ...[
                        _QuoteLine(
                          label: l10n.transferCurrentRate,
                          value:
                              '1 ${quote.sentCurrency} = ${_decimal(quote.customerRate)} ${quote.receivedCurrency}',
                        ),
                        const SizedBox(height: 8),
                        _QuoteLine(
                          label: l10n.transferFee,
                          value: _money(context, quote.fee, quote.sentCurrency),
                        ),
                      ] else if (contact == null)
                        Text(
                          l10n.transferChooseForQuote,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF8A8587),
                            height: 1.4,
                          ),
                        ),
                      if (vm.error != null) ...[
                        const SizedBox(height: 20),
                        _InlineError(
                          message: _errorText(l10n, vm.error),
                          onRetry: vm.canContinue ? vm.ensureQuote : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: FilledButton(
                  onPressed: vm.canContinue ? () => _continue(vm) : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    backgroundColor: const Color(0xFFFF9400),
                    disabledBackgroundColor: const Color(0xFFFFD49A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: vm.quoting
                      ? const SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.transferContinue,
                          style: const TextStyle(
                            fontSize: 18,
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
}

class _BeneficiaryCard extends StatelessWidget {
  final BeneficiaryContact? contact;
  final bool loading;
  final VoidCallback? onTap;
  const _BeneficiaryCard({
    required this.contact,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: contact == null
              ? const Color(0xFFFF9800)
              : const Color(0xFFE0DCDD),
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: loading
              ? const SizedBox(
                  height: 42,
                  child: Center(child: CircularProgressIndicator()),
                )
              : contact == null
              ? Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFFFFF3DF),
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Color(0xFFFF9400),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.transferBeneficiary.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9B9598),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.transferChooseBeneficiary,
                            style: const TextStyle(
                              color: Color(0xFFFF9400),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFFF9400),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.transferBeneficiary.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9B9598),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.swap_horiz_rounded,
                          color: Color(0xFFFF9400),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      '${beneficiaryFlag(contact!.countryCode)}  ${contact!.fullName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF332F34),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      [
                        if (contact!.phoneE164?.isNotEmpty == true)
                          contact!.phoneE164!,
                        if (contact!.operatorName?.isNotEmpty == true)
                          contact!.operatorName!,
                      ].join('  '),
                      style: const TextStyle(
                        color: Color(0xFF898487),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String currency;
  final bool enabled;
  final ValueChanged<String> onChanged;
  const _AmountField({
    required this.label,
    required this.controller,
    required this.currency,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    enabled: enabled,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      LengthLimitingTextInputFormatter(12),
    ],
    onChanged: onChanged,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    decoration: _fieldDecoration().copyWith(
      labelText: label.toUpperCase(),
      suffixText: currency,
      suffixStyle: const TextStyle(
        color: Color(0xFF777274),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _ReceivedAmountCard extends StatelessWidget {
  final String label;
  final num? amount;
  final String? currency;
  final bool loading;
  const _ReceivedAmountCard({
    required this.label,
    required this.amount,
    required this.currency,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) => InputDecorator(
    decoration: _fieldDecoration().copyWith(labelText: label.toUpperCase()),
    child: Row(
      children: [
        Expanded(
          child: loading
              ? const LinearProgressIndicator(minHeight: 2)
              : Text(
                  amount == null ? '—' : _decimal(amount!),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
        if (currency != null) ...[
          const SizedBox(width: 8),
          Text(
            currency == 'XAF' || currency == 'XOF' ? 'CFA' : currency!,
            style: const TextStyle(
              color: Color(0xFF777274),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    ),
  );
}

class _QuoteLine extends StatelessWidget {
  final String label;
  final String value;
  const _QuoteLine({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Text(
    '$label : $value',
    textAlign: TextAlign.center,
    style: const TextStyle(color: Color(0xFF8A8587), fontSize: 14),
  );
}

class _InlineError extends StatelessWidget {
  final String message;
  final Future<Object?> Function()? onRetry;
  const _InlineError({required this.message, this.onRetry});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1E8),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline, color: Color(0xFFE96C15)),
        const SizedBox(width: 10),
        Expanded(child: Text(message)),
        if (onRetry != null)
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
          ),
      ],
    ),
  );
}

class _TransferReviewSheet extends StatelessWidget {
  final TransferViewModel viewModel;
  final ValueChanged<String> onConfirmed;
  const _TransferReviewSheet({
    required this.viewModel,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: viewModel,
    builder: (context, _) {
      final l10n = AppLocalizations.of(context);
      final quote = viewModel.quote!;
      final contact = viewModel.beneficiary!;
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          24 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7D2D3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.transferReviewTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            _ReviewLine(
              label: l10n.transferBeneficiary,
              value: contact.fullName,
            ),
            _ReviewLine(
              label: l10n.contactPhone,
              value: contact.phoneE164 ?? l10n.contactNoPhone,
            ),
            _ReviewLine(
              label: l10n.transferOperator,
              value: contact.operatorName ?? '—',
            ),
            _ReviewLine(
              label: l10n.transferSent,
              value: _money(context, quote.sentAmount, quote.sentCurrency),
            ),
            _ReviewLine(
              label: l10n.transferFee,
              value: _money(context, quote.fee, quote.sentCurrency),
            ),
            _ReviewLine(
              label: l10n.transferRate,
              value:
                  '1 ${quote.sentCurrency} = ${_decimal(quote.customerRate)} ${quote.receivedCurrency}',
            ),
            _ReviewLine(
              label: l10n.transferReceived,
              value: _money(
                context,
                quote.receivedAmount,
                quote.receivedCurrency,
              ),
            ),
            _ReviewLine(
              label: l10n.transferFundingLabel,
              value: l10n.transferFundingCard,
            ),
            _ReviewLine(
              label: l10n.transferTotalAmount,
              value: _money(context, quote.totalDebited, quote.sentCurrency),
              emphasized: true,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2DC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.transferTrustWarning,
                style: const TextStyle(color: Color(0xFF765143), height: 1.4),
              ),
            ),
            if (viewModel.error != null) ...[
              const SizedBox(height: 14),
              Text(
                _errorText(l10n, viewModel.error),
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: viewModel.confirming
                  ? null
                  : () async {
                      final result = await viewModel.confirm();
                      if (result != null) onConfirmed(result.id);
                    },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: const Color(0xFFFF9400),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: viewModel.confirming
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      l10n.transferConfirm,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ],
        ),
      );
    },
  );
}

class _ReviewLine extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;
  const _ReviewLine({
    required this.label,
    required this.value,
    this.emphasized = false,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF777274),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF2D292E),
              fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
              fontSize: emphasized ? 17 : 15,
            ),
          ),
        ),
      ],
    ),
  );
}

InputDecoration _fieldDecoration() => InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: const BorderSide(color: Color(0xFFE0DCDD)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: const BorderSide(color: Color(0xFFE0DCDD)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: const BorderSide(color: Color(0xFFFF9400), width: 1.3),
  ),
  labelStyle: const TextStyle(
    color: Color(0xFF9B9598),
    fontSize: 11,
    fontWeight: FontWeight.w700,
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
);

String _decimal(num value) {
  final asDouble = value.toDouble();
  return asDouble == asDouble.roundToDouble()
      ? asDouble.toStringAsFixed(0)
      : asDouble.toStringAsFixed(2);
}

String _money(BuildContext context, num amount, String currency) =>
    NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      name: currency,
      symbol: currency == 'XAF' || currency == 'XOF' ? 'CFA' : null,
      decimalDigits: currency == 'XAF' || currency == 'XOF' ? 0 : 2,
    ).format(amount);

String _errorText(AppLocalizations l10n, TransferFailure? failure) =>
    switch (failure) {
      TransferFailure.invalid => l10n.transferInvalidError,
      TransferFailure.sessionExpired => l10n.contactSessionError,
      TransferFailure.notFound => l10n.transferBeneficiaryUnavailable,
      TransferFailure.conflict => l10n.transferConflictError,
      TransferFailure.quoteExpired => l10n.transferQuoteExpired,
      TransferFailure.unavailable => l10n.transferUnavailableError,
      TransferFailure.network => l10n.contactNetworkError,
      TransferFailure.timeout => l10n.homeTimeoutError,
      TransferFailure.server ||
      TransferFailure.invalidResponse ||
      TransferFailure.unexpected ||
      null => l10n.contactServerError,
    };
