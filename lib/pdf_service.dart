import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static Future<Uint8List> fromImages(Map<String, Uint8List> images) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Title - already has teal background with white text
          if (images['marathi_title'] != null)
            pw.ClipRRect(
              horizontalRadius: 8,
              verticalRadius: 8,
              child: pw.Image(pw.MemoryImage(images['marathi_title']!)),
            ),
          pw.SizedBox(height: 20),

          // Marathi Header
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: pw.BoxDecoration(color: PdfColors.teal, borderRadius: pw.BorderRadius.circular(4)),
            child: pw.Text('Marathi', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 10),

          // Welcome - transparent image on teal50 background
          if (images['marathi_welcome'] != null)
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(color: PdfColors.teal50, border: pw.Border.all(color: PdfColors.teal200), borderRadius: pw.BorderRadius.circular(6)),
              child: pw.Image(pw.MemoryImage(images['marathi_welcome']!)),
            ),
          pw.SizedBox(height: 12),

          // Section 1
          if (images['marathi_section1'] != null)
            pw.Image(pw.MemoryImage(images['marathi_section1']!)),
          pw.SizedBox(height: 6),
          if (images['marathi_section1_content1'] != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 15),
              child: pw.Image(pw.MemoryImage(images['marathi_section1_content1']!)),
            ),
          pw.SizedBox(height: 25),

          // Hindi Header
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: pw.BoxDecoration(color: PdfColors.orange, borderRadius: pw.BorderRadius.circular(4)),
            child: pw.Text('Hindi', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 10),

          // Section 5
          if (images['hindi_section5_content1'] != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 15),
              child: pw.Image(pw.MemoryImage(images['hindi_section5_content1']!)),
            ),
          pw.SizedBox(height: 8),
          if (images['hindi_section5_content2'] != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 15),
              child: pw.Image(pw.MemoryImage(images['hindi_section5_content2']!)),
            ),
          pw.SizedBox(height: 20),

          // Conclusion - transparent image on amber50 background
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(color: PdfColors.amber50, border: pw.Border.all(color: PdfColors.amber300), borderRadius: pw.BorderRadius.circular(6)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Conclusion', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.amber800)),
                pw.SizedBox(height: 8),
                if (images['hindi_conclusion'] != null)
                  pw.Image(pw.MemoryImage(images['hindi_conclusion']!)),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
