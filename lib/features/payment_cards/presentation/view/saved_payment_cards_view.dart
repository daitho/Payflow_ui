import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../domain/model/saved_payment_card.dart';
import '../view_model/saved_payment_cards_view_model.dart';
import 'card_text.dart';

class SavedPaymentCardsView extends StatelessWidget {
  const SavedPaymentCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SavedPaymentCardsViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: AppBar(title: Text(cardText(context, 'title'))),
      body: vm.loading && vm.cards.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                Text(cardText(context, 'intro')),
                const SizedBox(height: 8),
                Text(cardText(context, 'notice'),
                    style: const TextStyle(color: Color(0xFF777274), fontSize: 12)),
                if (vm.failed) ...[
                  const SizedBox(height: 12),
                  Text(cardText(context, 'error'),
                      style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 22),
                if (vm.cards.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Center(child: Text(cardText(context, 'empty'))),
                  ),
                for (final card in vm.cards)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const Icon(Icons.credit_card_rounded,
                          color: Color(0xFF167C73), size: 32),
                      title: Text('${card.brand}  ${card.maskedNumber}',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text([
                        card.holderName,
                        card.expiry,
                        if (card.expired) cardText(context, 'expired'),
                      ].join(' · ')),
                      trailing: IconButton(
                        tooltip: cardText(context, 'remove'),
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: vm.saving ? null : () => _remove(context, vm, card),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: vm.saving ? null : () => _add(context, vm),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(cardText(context, 'add')),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFFFF9400),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _add(BuildContext context, SavedPaymentCardsViewModel vm) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _AddCardForm(vm: vm),
    );
  }

  Future<void> _remove(BuildContext context, SavedPaymentCardsViewModel vm,
      SavedPaymentCard card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(cardText(dialog, 'confirmRemove')),
        content: Text('${card.brand}  ${card.maskedNumber}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialog, false),
              child: Text(cardText(dialog, 'cancel'))),
          TextButton(onPressed: () => Navigator.pop(dialog, true),
              child: Text(cardText(dialog, 'remove'))),
        ],
      ),
    );
    if (confirmed != true) return;
    final removed = await vm.remove(card.id);
    if (!removed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cardText(context, 'error'))));
    }
  }
}

class _AddCardForm extends StatefulWidget {
  const _AddCardForm({required this.vm});
  final SavedPaymentCardsViewModel vm;

  @override
  State<_AddCardForm> createState() => _AddCardFormState();
}

class _AddCardFormState extends State<_AddCardForm> {
  final _form = GlobalKey<FormState>();
  final _holder = TextEditingController();
  final _lastFour = TextEditingController();
  final _month = TextEditingController();
  final _year = TextEditingController();
  String _brand = 'VISA';
  bool _submitting = false;
  bool _error = false;

  @override
  void dispose() {
    _holder.dispose();
    _lastFour.dispose();
    _month.dispose();
    _year.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate() || _submitting) return;
    final month = int.parse(_month.text);
    final year = int.parse(_year.text);
    final now = DateTime.now();
    if (year < now.year || year == now.year && month < now.month ||
        year > now.year + 20) {
      setState(() => _error = true);
      return;
    }
    setState(() { _submitting = true; _error = false; });
    final saved = await widget.vm.add(NewSavedPaymentCard(
      holderName: _holder.text.trim(), brand: _brand,
      lastFour: _lastFour.text, expiryMonth: month, expiryYear: year,
    ));
    if (!mounted) return;
    if (saved) {
      Navigator.pop(context);
    } else {
      setState(() { _submitting = false; _error = true; });
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20, 8, 20,
        MediaQuery.viewInsetsOf(context).bottom + 24),
    child: SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(cardText(context, 'add'),
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(cardText(context, 'notice'),
                style: const TextStyle(color: Color(0xFF777274), fontSize: 12)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _holder,
              decoration: InputDecoration(labelText: cardText(context, 'holder')),
              textCapitalization: TextCapitalization.words,
              maxLength: 120,
              validator: (v) => v == null || v.trim().isEmpty
                  ? cardText(context, 'invalid') : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _brand,
              decoration: InputDecoration(labelText: cardText(context, 'brand')),
              items: const [
                DropdownMenuItem(value: 'VISA', child: Text('Visa')),
                DropdownMenuItem(value: 'MASTERCARD', child: Text('Mastercard')),
              ],
              onChanged: (v) { if (v != null) setState(() => _brand = v); },
            ),
            TextFormField(
              controller: _lastFour,
              decoration: InputDecoration(labelText: cardText(context, 'lastFour')),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)],
              validator: (v) => RegExp(r'^\d{4}$').hasMatch(v ?? '')
                  ? null : cardText(context, 'invalid'),
            ),
            Row(children: [
              Expanded(child: TextFormField(
                controller: _month,
                decoration: InputDecoration(labelText: cardText(context, 'month')),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2)],
                validator: (v) { final n = int.tryParse(v ?? '');
                  return n != null && n >= 1 && n <= 12
                      ? null : cardText(context, 'invalid'); },
              )),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(
                controller: _year,
                decoration: InputDecoration(labelText: cardText(context, 'year')),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)],
                validator: (v) => (int.tryParse(v ?? '') ?? 0) >= DateTime.now().year
                    ? null : cardText(context, 'invalid'),
              )),
            ]),
            if (_error) ...[
              const SizedBox(height: 12),
              Text(cardText(context, 'invalid'),
                  style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _submitting ? null : _save,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52),
                  backgroundColor: const Color(0xFFFF9400)),
              child: _submitting ? const CircularProgressIndicator(color: Colors.white)
                  : Text(cardText(context, 'save')),
            ),
          ],
        ),
      ),
    ),
  );
}
