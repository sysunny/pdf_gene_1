import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'app_constants.dart';

class PdfGenerator {
  static Future<Uint8List> generateGuide(String language) async {
    final pdf = pw.Document();
    final content = AppConstants.guideTexts[language]!;
    final now = DateTime.now();
    final dateTime = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.teal,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                content['title']!,
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Generated: $dateTime',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.black),
              ),
            ],
          ),
        ),
        footer: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Page ${context.pageNumber}/${context.pagesCount}', style: const pw.TextStyle(fontSize: 9)),
              pw.Text(dateTime, style: const pw.TextStyle(fontSize: 9)),
            ],
          ),
        ),
        build: (context) => [
          pw.Text(content['welcome']!, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text(content['section1']!, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(content['section1_content1']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 5),
          pw.Text(content['section1_content2']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 15),
          pw.Text(content['section2']!, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(content['section2_content1']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 5),
          pw.Text(content['section2_content2']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 15),
          pw.Text(content['section3']!, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(content['section3_content1']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 5),
          pw.Text(content['section3_content2']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 15),
          pw.Text(content['section4']!, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(content['section4_content1']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 5),
          pw.Text(content['section4_content2']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 15),
          pw.Text(content['section5']!, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(content['section5_content1']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 5),
          pw.Text(content['section5_content2']!, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.amber50,
              border: pw.Border.all(color: PdfColors.amber300),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(content['conclusion']!, style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic)),
          ),
        ],
      ),
    );

    return pdf.save();
  }

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
