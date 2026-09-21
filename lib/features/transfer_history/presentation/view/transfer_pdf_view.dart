import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

/// Displays the authenticated server document without regenerating its contents.
/// The preview toolbar provides the platform's print/save/share actions.
class TransferPdfView extends StatelessWidget {
  final Uint8List bytes;
  final String title, filename;
  TransferPdfView({
    super.key,
    required List<int> bytes,
    required this.title,
    required this.filename,
  }) : bytes = Uint8List.fromList(bytes);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: PdfPreview(
      build: (_) async => bytes,
      pdfFileName: filename,
      canChangePageFormat: false,
      canChangeOrientation: false,
      canDebug: false,
      allowPrinting: true,
      allowSharing: true,
    ),
  );
}
