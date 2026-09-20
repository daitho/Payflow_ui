import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/beneficiary_contact.dart';
import '../view_model/beneficiaries_view_model.dart';
import '../widget/beneficiary_avatar.dart';
import '../widget/beneficiary_error.dart';

class BeneficiariesView extends StatelessWidget {
  final ValueChanged<BeneficiaryContact>? onBeneficiaryTap;
  final bool selectionMode;

  const BeneficiariesView({
    super.key,
    this.onBeneficiaryTap,
    this.selectionMode = false,
  });
  Future<void> _open(BuildContext context, {String? id}) async {
    final vm = context.read<BeneficiariesViewModel>();
    final saved = await context.push<BeneficiaryContact>(id == null
      ? AppRoutes.beneficiaryCreate : AppRoutes.beneficiaryEditPath(id));
    if (saved != null && context.mounted) await vm.load();
  }
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BeneficiariesViewModel>();
    final l10n = AppLocalizations.of(context);
    final items = vm.items;
    return ColoredBox(color: Colors.white, child: SafeArea(bottom: false, child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(12, 28, 12, 16),
          child: Text(selectionMode ? l10n.transferChooseBeneficiary : l10n.contactTitle,
            style: const TextStyle(fontSize: 24,
            fontWeight: FontWeight.w700, color: Color(0xFF242327)))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: TextField(
          onChanged: vm.search,
          decoration: InputDecoration(hintText: l10n.contactSearch,
            prefixIcon: const Icon(Icons.search, color: Color(0xFF9E9E9E)),
            filled: true, fillColor: const Color(0xFFF4F4F4),
            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(14)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(14)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12)),
        )),
        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: ListTile(
          onTap: () => _open(context), contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: const Icon(Icons.person_add_alt_1, color: Color(0xFF0C9F93)),
          title: Text(l10n.contactAdd, style: const TextStyle(color: Color(0xFF0C9F93), fontWeight: FontWeight.w700)),
          trailing: const Icon(Icons.chevron_right, color: Color(0xFF0C9F93)),
        )),
        Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 10), child: Text(
          l10n.contactSection, style: const TextStyle(fontSize: 12, color: Color(0xFF808080),
            fontWeight: FontWeight.w700, letterSpacing: .5))),
        if (vm.loading) const LinearProgressIndicator(minHeight: 2),
        if (vm.error != null) Padding(padding: const EdgeInsets.all(12), child: Row(children: [
          Expanded(child: Text(beneficiaryError(l10n, vm.error!))),
          TextButton(onPressed: vm.loading ? null : vm.load, child: Text(l10n.retry)),
        ])),
        Expanded(child: RefreshIndicator(onRefresh: vm.load, child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 110),
          itemCount: items.isEmpty ? 1 : items.length,
          separatorBuilder: (_, index) => const Divider(height: 1, indent: 60, color: Color(0xFFD0CAD5)),
          itemBuilder: (context, index) {
            if (items.isEmpty) return Padding(padding: const EdgeInsets.all(32),
              child: Text(vm.loading || vm.error != null ? '' : l10n.contactEmpty, textAlign: TextAlign.center));
            final contact = items[index];
            final currency = contact.currencyCode;
            return InkWell(
              onTap: onBeneficiaryTap == null
                  ? null
                  : () => onBeneficiaryTap!(contact),
              child: Padding(padding: const EdgeInsets.fromLTRB(12, 12, 8, 12), child: Row(children: [
              BeneficiaryAvatar(contact: contact), const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(contact.fullName, style: const TextStyle(fontWeight: FontWeight.w700,
                  fontSize: 14, color: Color(0xFF29272C))),
                const SizedBox(height: 5),
                Text.rich(TextSpan(children: [
                  TextSpan(text: contact.phoneE164 ?? l10n.contactNoPhone,
                    style: const TextStyle(color: Color(0xFF929292))),
                  if (contact.operatorName != null) TextSpan(text: '  ${contact.operatorName}',
                    style: const TextStyle(color: Color(0xFF353535), fontWeight: FontWeight.w600)),
                ]), style: const TextStyle(fontSize: 12)),
              ])),
              if (currency != null) Container(
                margin: const EdgeInsets.only(left: 6), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF0ECE9), borderRadius: BorderRadius.circular(3)),
                child: Text(currency == 'XAF' || currency == 'XOF' ? 'CFA' : currency,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF896759), fontWeight: FontWeight.w700))),
              if (!selectionMode)
                IconButton(tooltip: '${l10n.contactEdit}: ${contact.fullName}',
                  onPressed: () => _open(context, id: contact.id),
                  icon: const Icon(Icons.edit, size: 20, color: Color(0xFF0C9F93))),
              if (selectionMode)
                const Icon(Icons.chevron_right, color: Color(0xFF0C9F93)),
            ])),
            );
          },
        ))),
      ],
    )));
  }
}
