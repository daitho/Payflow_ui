import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/payment_operator_logo.dart';
import '../../../beneficiaries/domain/model/beneficiary_contact.dart';
import '../../../beneficiaries/presentation/widget/beneficiary_avatar.dart';
import '../../../payment_cards/presentation/view/card_text.dart';
import '../../domain/exception/transfer_exception.dart';
import '../../domain/model/paypal_return_link.dart';
import '../../domain/model/transfer_amount_input.dart';
import '../../domain/model/transfer_quote.dart';
import '../../domain/service/transfer_funding_availability.dart';
import '../view_model/transfer_view_model.dart';

class TransferView extends StatefulWidget {
  const TransferView({super.key});
  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  late final AppLinks _appLinks;
  late final TextEditingController _sentAmount;
  late final TextEditingController _receivedAmount;
  String? _synchronizedQuoteId;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _sentAmount = TextEditingController(
      text: context.read<TransferViewModel>().initialAmountText,
    );
    _receivedAmount = TextEditingController();
  }

  @override
  void dispose() {
    _sentAmount.dispose();
    _receivedAmount.dispose();
    super.dispose();
  }

  void _synchronizeQuotedAmount(TransferViewModel viewModel) {
    final quote = viewModel.quote;
    if (quote == null || quote.id == _synchronizedQuoteId) return;
    _synchronizedQuoteId = quote.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || viewModel.quote?.id != quote.id) return;
      if (viewModel.amountInput == TransferAmountInput.sent) {
        _setAmountText(_receivedAmount, quote.receivedAmount);
      } else {
        _setAmountText(_sentAmount, quote.sentAmount);
      }
    });
  }

  void _setAmountText(TextEditingController controller, num amount) {
    final text = _editableDecimal(amount);
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _changeSentAmount(TransferViewModel viewModel, String value) {
    _receivedAmount.clear();
    viewModel.setSentAmount(value);
  }

  void _changeReceivedAmount(TransferViewModel viewModel, String value) {
    _sentAmount.clear();
    viewModel.setReceivedAmount(value);
  }

  void _selectSuggestedAmount(TransferViewModel viewModel, num amount) {
    FocusScope.of(context).unfocus();
    _setAmountText(_sentAmount, amount);
    _receivedAmount.clear();
    viewModel.selectSuggestedAmount(amount);
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
        onConfirm: () => _confirmPayment(vm),
        onConfirmed: (transferId) {
          Navigator.of(sheetContext).pop(transferId);
        },
      ),
    );
    if (mounted && confirmedTransferId != null) {
      context.pop(confirmedTransferId);
    }
  }

  Future<ConfirmedTransfer?> _confirmPayment(
    TransferViewModel viewModel,
  ) async {
    if (viewModel.fundingMethod != TransferFundingMethod.paypal) {
      return viewModel.confirm();
    }

    final payment = await viewModel.startPaypalPayment();
    if (!mounted) return null;
    if (payment == null) {
      _showError(viewModel.error);
      return null;
    }

    final approvalUrl = Uri.tryParse(payment.approvalUrl ?? '');
    if (approvalUrl == null || !payment.requiresPayerAction) {
      _showPaypalLaunchError();
      return null;
    }

    BuildContext? returnDialog;
    bool? callbackResult;
    final subscription = _appLinks.uriLinkStream.listen((uri) {
      final action = paypalReturnAction(uri, payment.id);
      if (action == null || callbackResult != null) return;
      callbackResult = action == PaypalReturnAction.approved;
      final dialog = returnDialog;
      if (dialog != null && dialog.mounted) {
        returnDialog = null;
        Navigator.of(dialog).pop(callbackResult);
      }
    });

    try {
      bool launched;
      try {
        launched = await launchUrl(
          approvalUrl,
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {
        launched = false;
      }
      if (!launched) {
        if (mounted) _showPaypalLaunchError();
        return null;
      }

      if (!mounted) return null;
      final l10n = AppLocalizations.of(context);
      bool? shouldVerify = callbackResult;
      if (shouldVerify == null) {
        shouldVerify = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            returnDialog = dialogContext;
            // A callback may arrive between opening and building the dialog.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (callbackResult != null &&
                  returnDialog == dialogContext &&
                  dialogContext.mounted) {
                returnDialog = null;
                Navigator.of(dialogContext).pop(callbackResult);
              }
            });
            return AlertDialog(
              title: Text(l10n.transferPaypalReturnTitle),
              content: Text(l10n.transferPaypalReturnMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    returnDialog = null;
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    returnDialog = null;
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: Text(l10n.transferPaypalVerify),
                ),
              ],
            );
          },
        );
      }
      returnDialog = null;
      if (shouldVerify != true || !mounted) return null;
      final result = await viewModel.capturePaypalAndConfirm();
      if (result == null && mounted) _showError(viewModel.error);
      return result;
    } finally {
      await subscription.cancel();
    }
  }

  void _showPaypalLaunchError() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.transferPaypalLaunchError)),
      );
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
    final fundingMethods = TransferFundingAvailability.resolve(
      supportsGooglePay: _supportsGooglePay,
      hasSavedCard: vm.hasSavedCard,
    );
    _synchronizeQuotedAmount(vm);
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
                              controller: _sentAmount,
                              currency: _displayCurrency(vm.sentCurrency),
                              enabled: !vm.confirming,
                              loading:
                                  vm.quoting &&
                                  vm.amountInput == TransferAmountInput.received,
                              onChanged: (value) => _changeSentAmount(vm, value),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _AmountField(
                              label: l10n.transferAmountReceived,
                              controller: _receivedAmount,
                              currency: _displayCurrency(
                                quote?.receivedCurrency ??
                                    contact?.currencyCode ??
                                    '',
                              ),
                              enabled: !vm.confirming && contact != null,
                              loading:
                                  vm.quoting &&
                                  vm.amountInput == TransferAmountInput.sent,
                              onChanged: (value) =>
                                  _changeReceivedAmount(vm, value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _SuggestedAmounts(
                        title: l10n.transferSuggestedAmounts,
                        amounts: vm.suggestedAmounts,
                        currency: vm.sentCurrency,
                        selectedAmount:
                            vm.amountInput == TransferAmountInput.sent
                            ? vm.sentAmount
                            : null,
                        enabled: !vm.confirming,
                        onSelected: (amount) =>
                            _selectSuggestedAmount(vm, amount),
                      ),
                      if (contact != null && vm.payoutOptions.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          l10n.transferOperator.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF777274),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (final option in vm.payoutOptions) ...[
                          _PayoutOptionTile(
                            name: option.name,
                            selected: option.id == vm.selectedPayoutOperatorId,
                            enabled: !vm.confirming,
                            onTap: () => vm.selectPayoutOperator(option.id),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                      if (contact != null && vm.payoutOptions.isEmpty) ...[
                        const SizedBox(height: 24),
                        _InlineError(message: l10n.transferBeneficiaryUnavailable),
                      ],
                      const SizedBox(height: 18),
                      Text(
                        l10n.transferFundingLabel.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF777274),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 9),
                      SizedBox(
                        height: _transferMethodFieldHeight,
                        child: DropdownButtonFormField<TransferFundingMethod>(
                          key: ValueKey(vm.fundingMethod),
                          initialValue: vm.fundingMethod,
                          decoration: _methodFieldDecoration(),
                          items: fundingMethods
                              .map(
                                (method) => DropdownMenuItem(
                                  value: method,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _fundingIcon(method),
                                        size: 20,
                                        color: const Color(0xFF24466E),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(_fundingLabel(l10n, method)),
                                    ],
                                  ),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: vm.confirming
                              ? null
                              : (value) {
                                  if (value != null) {
                                    vm.selectFundingMethod(value);
                                  }
                                },
                        ),
                      ),
                      if (vm.fundingMethod == TransferFundingMethod.card &&
                          vm.savedCards.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          key: ValueKey(vm.selectedCardId),
                          initialValue: vm.selectedCardId,
                          decoration: _fieldDecoration().copyWith(
                            labelText: cardText(context, 'choose'),
                          ),
                          items: vm.savedCards.map((card) => DropdownMenuItem(
                            value: card.id,
                            child: Text('${card.brand}  ${card.maskedNumber}  ·  ${card.expiry}'),
                          )).toList(),
                          onChanged: vm.confirming ? null : (id) {
                            if (id != null) vm.selectCard(id);
                          },
                        ),
                      ],
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: vm.confirming ? null : () async {
                            await context.push(AppRoutes.paymentCards);
                            if (mounted) await vm.refreshCards();
                          },
                          icon: Icon(vm.hasSavedCard ? Icons.credit_card_rounded
                              : Icons.add_circle_outline_rounded),
                          label: Text(cardText(context,
                              vm.hasSavedCard ? 'manage' : 'add')),
                        ),
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

class _PayoutOptionTile extends StatelessWidget {
  const _PayoutOptionTile({
    required this.name,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: Material(
      color: selected ? const Color(0xFFFFF8EC) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? const Color(0xFFFF9400) : const Color(0xFFE8E5E4),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: SizedBox(
        height: _transferMethodFieldHeight,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                PaymentOperatorLogo(name: name, width: 64, height: 40),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: selected ? const Color(0xFFFF9400) : const Color(0xFFB9B4B3),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _AmountField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String currency;
  final bool enabled;
  final bool loading;
  final ValueChanged<String> onChanged;
  const _AmountField({
    required this.label,
    required this.controller,
    required this.currency,
    required this.enabled,
    this.loading = false,
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
      suffixIcon: loading
          ? const Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : null,
      suffixText: loading ? null : currency,
      suffixStyle: const TextStyle(
        color: Color(0xFF777274),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _SuggestedAmounts extends StatelessWidget {
  final String title;
  final List<num> amounts;
  final String currency;
  final num? selectedAmount;
  final bool enabled;
  final ValueChanged<num> onSelected;

  const _SuggestedAmounts({
    required this.title,
    required this.amounts,
    required this.currency,
    required this.selectedAmount,
    required this.enabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF777274),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final amount in amounts)
            ChoiceChip(
              label: Text(_suggestedAmountLabel(amount, currency)),
              selected: selectedAmount == amount,
              onSelected: enabled ? (_) => onSelected(amount) : null,
              selectedColor: const Color(0xFFFFE4BA),
              side: BorderSide(
                color: selectedAmount == amount
                    ? const Color(0xFFFF9400)
                    : const Color(0xFFE0DCDD),
              ),
              labelStyle: TextStyle(
                color: selectedAmount == amount
                    ? const Color(0xFFC86E00)
                    : const Color(0xFF514B4D),
                fontWeight: FontWeight.w600,
              ),
              showCheckmark: false,
            ),
        ],
      ),
    ],
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
  final Future<ConfirmedTransfer?> Function() onConfirm;
  final ValueChanged<String> onConfirmed;
  const _TransferReviewSheet({
    required this.viewModel,
    required this.onConfirm,
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
            const SizedBox(height: 12),
            _PaymentPartyCard(
              label: l10n.transferFundingLabel,
              name: viewModel.fundingMethod == TransferFundingMethod.card &&
                      viewModel.selectedCard != null
                  ? '${viewModel.selectedCard!.brand}  ${viewModel.selectedCard!.maskedNumber}'
                  : _fundingLabel(l10n, viewModel.fundingMethod),
              logoAsset: _fundingLogoAsset(viewModel.fundingMethod),
              fallbackIcon: _fundingIcon(viewModel.fundingMethod),
            ),
            const SizedBox(height: 12),
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
              label: l10n.transferTotalAmount,
              value: _money(context, quote.totalDebited, quote.sentCurrency),
              emphasized: true,
            ),
            const SizedBox(height: 12),
            _PaymentPartyCard(
              label: l10n.transferOperator,
              name: viewModel.selectedPayoutName ?? '—',
              operatorName: viewModel.selectedPayoutName,
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
                      final result = await onConfirm();
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

class _PaymentPartyCard extends StatelessWidget {
  const _PaymentPartyCard({
    required this.label,
    required this.name,
    this.operatorName,
    this.logoAsset,
    this.fallbackIcon = Icons.account_balance_wallet_outlined,
  });

  final String label;
  final String name;
  final String? operatorName;
  final String? logoAsset;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE9E5E4)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF777274), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (operatorName != null)
          PaymentOperatorLogo(
            name: operatorName,
            width: _reviewLogoWidth,
            height: _reviewLogoHeight,
          )
        else
          ExcludeSemantics(
            child: Container(
              width: _reviewLogoWidth,
              height: _reviewLogoHeight,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE9E5E4)),
              ),
              child: logoAsset == null
                  ? Icon(fallbackIcon)
                  : Image.asset(
                      logoAsset!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(fallbackIcon),
                    ),
            ),
          ),
      ],
    ),
  );
}

const double _transferMethodFieldHeight = 64;
const double _reviewLogoWidth = 96;
const double _reviewLogoHeight = 56;

InputDecoration _methodFieldDecoration() => _fieldDecoration().copyWith(
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
);

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

String _displayCurrency(String currency) {
  final normalized = currency.trim().toUpperCase();
  return normalized == 'XAF' || normalized == 'XOF' ? 'CFA' : normalized;
}

String _editableDecimal(num value) {
  final decimal = value.toDouble();
  return decimal == decimal.roundToDouble()
      ? decimal.toStringAsFixed(0)
      : decimal.toStringAsFixed(2);
}

String _suggestedAmountLabel(num amount, String currency) {
  final code = currency.trim().toUpperCase();
  final symbol = switch (code) {
    'EUR' => '€',
    'USD' => r'$',
    'GBP' => '£',
    'JPY' || 'CNY' => '¥',
    'KRW' => '₩',
    'INR' => '₹',
    'CAD' => r'CA$',
    'AUD' => r'A$',
    'NZD' => r'NZ$',
    'HKD' => r'HK$',
    'SGD' => r'S$',
    _ => null,
  };
  return symbol == null
      ? '${_editableDecimal(amount)} $code'
      : '$symbol${_editableDecimal(amount)}';
}

String? _fundingLogoAsset(TransferFundingMethod method) => switch (method) {
  TransferFundingMethod.applePay => 'assets/images/transfer/apple_pay.png',
  TransferFundingMethod.googlePay => 'assets/images/transfer/google_pay.png',
  TransferFundingMethod.paypal => 'assets/images/transfer/paypal.png',
  TransferFundingMethod.card => null,
};

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
      TransferFailure.amountBelowMinimum =>
        l10n.transferAmountBelowMinimumError,
      TransferFailure.amountAboveMaximum =>
        l10n.transferAmountAboveMaximumError,
      TransferFailure.unavailable => l10n.transferUnavailableError,
      TransferFailure.network => l10n.contactNetworkError,
      TransferFailure.timeout => l10n.homeTimeoutError,
      TransferFailure.server ||
      TransferFailure.invalidResponse ||
      TransferFailure.unexpected ||
      null => l10n.contactServerError,
    };


bool get _supportsGooglePay {
  if (kIsWeb) return true;
  return switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.windows ||
    TargetPlatform.linux ||
    TargetPlatform.macOS => true,
    TargetPlatform.iOS || TargetPlatform.fuchsia => false,
  };
}

String _fundingLabel(
  AppLocalizations l10n,
  TransferFundingMethod method,
) => switch (method) {
  TransferFundingMethod.applePay => l10n.transferFundingApplePay,
  TransferFundingMethod.googlePay => l10n.transferFundingGooglePay,
  TransferFundingMethod.paypal => l10n.transferFundingPaypal,
  TransferFundingMethod.card => l10n.transferFundingCard,
};

IconData _fundingIcon(TransferFundingMethod method) => switch (method) {
  TransferFundingMethod.applePay => Icons.apple,
  TransferFundingMethod.googlePay => Icons.g_mobiledata_rounded,
  TransferFundingMethod.paypal => Icons.account_balance_wallet_rounded,
  TransferFundingMethod.card => Icons.credit_card_rounded,
};
