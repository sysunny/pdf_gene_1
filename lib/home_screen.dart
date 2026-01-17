import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'pdf_service.dart';
import 'app_constants.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // All content keys for image capture
  final List<String> _contentKeys = [
    'marathi_title',
    'marathi_welcome', 
    'marathi_section1',
    'marathi_section1_content1',
    'hindi_section5_content1',
    'hindi_section5_content2',
    'hindi_conclusion',
  ];

  final Map<String, GlobalKey> _keys = {};
  Map<String, Uint8List> _images = {};
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    for (var k in _contentKeys) {
      _keys[k] = GlobalKey();
    }
    // Capture after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), _captureAll);
    });
  }

  Future<void> _captureAll() async {
    Map<String, Uint8List> captured = {};
    
    for (var key in _contentKeys) {
      final globalKey = _keys[key];
      if (globalKey?.currentContext == null) continue;
      
      try {
        final boundary = globalKey!.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 5.0); // High quality
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          captured[key] = byteData.buffer.asUint8List();
        }
      } catch (e) {
        print('Error capturing $key: $e');
      }
    }
    
    setState(() {
      _images = captured;
      _ready = captured.isNotEmpty;
    });
    print('Captured ${captured.length} images');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main UI
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade800, Colors.teal.shade500, Colors.cyan.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildPreviewCard(),
                          const SizedBox(height: 16),
                          _buildPdfButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Hidden capture area
          _buildCaptureArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppConstants.marathiContent['title'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          if (_ready) const Icon(Icons.check_circle, color: Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _badge('मराठी', Colors.teal),
          const SizedBox(height: 8),
          Text(AppConstants.marathiContent['welcome'] ?? ''),
          const SizedBox(height: 8),
          Text(AppConstants.marathiContent['section1'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(AppConstants.marathiContent['section1_content1'] ?? ''),
          const SizedBox(height: 16),
          _badge('हिंदी', Colors.orange),
          const SizedBox(height: 8),
          Text(AppConstants.hindiContent['section5_content1'] ?? ''),
          Text(AppConstants.hindiContent['section5_content2'] ?? ''),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8)),
            child: Text(AppConstants.hindiContent['conclusion'] ?? '', style: const TextStyle(fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPdfButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: _ready ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => PdfScreen(images: _images))) : null,
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        label: Text(_ready ? 'Generate PDF' : 'Loading...', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Hidden area for capturing text as images
  Widget _buildCaptureArea() {
    return Positioned(
      left: -5000,
      top: 0,
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _captureTitleWidget('marathi_title', AppConstants.marathiContent['title'] ?? ''),
            _captureWidget('marathi_welcome', AppConstants.marathiContent['welcome'] ?? '', 16, false, Colors.transparent),
            _captureWidget('marathi_section1', AppConstants.marathiContent['section1'] ?? '', 18, true, Colors.transparent),
            _captureWidget('marathi_section1_content1', AppConstants.marathiContent['section1_content1'] ?? '', 14, false, Colors.transparent),
            _captureWidget('hindi_section5_content1', AppConstants.hindiContent['section5_content1'] ?? '', 14, false, Colors.transparent),
            _captureWidget('hindi_section5_content2', AppConstants.hindiContent['section5_content2'] ?? '', 14, false, Colors.transparent),
            _captureWidget('hindi_conclusion', AppConstants.hindiContent['conclusion'] ?? '', 14, false, Colors.transparent),
          ],
        ),
      ),
    );
  }

  Widget _captureWidget(String key, String text, double fontSize, bool bold, Color bgColor) {
    return RepaintBoundary(
      key: _keys[key],
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Special capture for title with teal background and white text
  Widget _captureTitleWidget(String key, String text) {
    return RepaintBoundary(
      key: _keys[key],
      child: Container(
        color: Colors.teal.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class PdfScreen extends StatelessWidget {
  final Map<String, Uint8List> images;
  const PdfScreen({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF'), backgroundColor: Colors.teal),
      body: PdfPreview(build: (_) => PdfGenerator.fromImages(images)),
    );
  }
}
