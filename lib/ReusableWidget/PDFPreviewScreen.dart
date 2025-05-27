import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewPage extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const PdfPreviewPage({Key? key, required this.pdfUrl, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF161B22),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        interactionMode: PdfInteractionMode.pan,
        enableDoubleTapZooming: true,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          print("Document load failed: ${details.error}");
        },
      ),
    );
  }
}
