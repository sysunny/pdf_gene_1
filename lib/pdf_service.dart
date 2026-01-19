import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static Future<Uint8List> fromImages(Map<String, Uint8List> images) async {
    final pdf = pw.Document(compress: true);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          if (images['marathi_title'] != null) pw.Image(pw.MemoryImage(images['marathi_title']!), fit: pw.BoxFit.contain),
          pw.SizedBox(height: 15),
          if (images['marathi_welcome'] != null) pw.Image(pw.MemoryImage(images['marathi_welcome']!), fit: pw.BoxFit.contain),
          pw.SizedBox(height: 10),
          if (images['marathi_section1'] != null) pw.Image(pw.MemoryImage(images['marathi_section1']!), fit: pw.BoxFit.contain),
          pw.SizedBox(height: 5),
          if (images['marathi_section1_content1'] != null) pw.Image(pw.MemoryImage(images['marathi_section1_content1']!), fit: pw.BoxFit.contain),
          pw.SizedBox(height: 15),
          if (images['hindi_section5_content1'] != null) pw.Image(pw.MemoryImage(images['hindi_section5_content1']!), fit: pw.BoxFit.contain),
          pw.SizedBox(height: 5),
          if (images['hindi_section5_content2'] != null) pw.Image(pw.MemoryImage(images['hindi_section5_content2']!), fit: pw.BoxFit.contain),
          pw.SizedBox(height: 15),
          if (images['hindi_conclusion'] != null) pw.Image(pw.MemoryImage(images['hindi_conclusion']!), fit: pw.BoxFit.contain),
        ],
      ),
    );

    return pdf.save();
  }
}
