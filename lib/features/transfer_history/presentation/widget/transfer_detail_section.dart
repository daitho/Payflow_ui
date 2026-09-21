import 'package:flutter/material.dart';

class TransferDetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const TransferDetailSection({
    super.key,
    required this.title,
    required this.children,
  });
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    ),
  );
}

class TransferDetailField extends StatelessWidget {
  final String label, value;
  const TransferDetailField({
    super.key,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF948C88),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        SelectableText(value, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Color(0xFFEAE5E2)),
      ],
    ),
  );
}
