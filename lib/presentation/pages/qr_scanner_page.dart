import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// QR Code Scanner Page
/// Scans any QR code — payment QRs, links, text, etc.
/// Developed by Tavoo — DupZero

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;
  bool _torchOn = false;
  String? _lastResult;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    setState(() {
      _scanned = true;
      _lastResult = barcode!.rawValue;
    });

    _controller.stop();
    _showResult(barcode!.rawValue!);
  }

  void _showResult(String value) {
    final cs = Theme.of(context).colorScheme;

    // Detect QR type
    final type = _detectQRType(value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Handle
              Center(child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2)),
              )),
              const SizedBox(height: 20),

              // Type badge
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(type.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(type.label, style: TextStyle(
                      fontWeight: FontWeight.w700, color: cs.primary)),
                  ]),
                ),
                const Spacer(),
                // Copy button
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy',
                  onPressed: () {
                    // Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied!'),
                        behavior: SnackBarBehavior.floating));
                  },
                ),
              ]),

              const SizedBox(height: 16),

              // Content
              Text('Yaliyomo:', style: TextStyle(
                fontWeight: FontWeight.w700, color: cs.onSurface)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(value,
                  style: const TextStyle(fontSize: 13, height: 1.5)),
              ),

              const SizedBox(height: 20),

              // Actions based on type
              ..._getActions(type, value, cs),

              const SizedBox(height: 12),

              // Scan again
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _scanned = false);
                  _controller.start();
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Nyingine'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48)),
              ),
            ]),
          ),
        ),
      ),
    ).then((_) {
      if (!_scanned) _controller.start();
    });
  }

  _QRType _detectQRType(String value) {
    if (value.startsWith('http://') || value.startsWith('https://')) {
      if (value.contains('paypal')) return _QRType.paypal;
      if (value.contains('mpesa') || value.contains('safaricom'))
        return _QRType.mpesa;
      return _QRType.url;
    }
    if (value.startsWith('MPESA') || value.contains('MPESA_TZ') ||
        value.contains('MPESA_KE')) return _QRType.mpesa;
    if (value.contains('AIRTEL')) return _QRType.airtel;
    if (value.contains('CRDB') || value.contains('NMB')) return _QRType.bank;
    if (value.startsWith('000201')) return _QRType.emvco; // EMVCo standard
    if (value.startsWith('tel:')) return _QRType.phone;
    if (value.startsWith('mailto:')) return _QRType.email;
    if (value.contains('DUPZERO') || value.contains('dupzero'))
      return _QRType.dupzero;
    return _QRType.text;
  }

  List<Widget> _getActions(_QRType type, String value, ColorScheme cs) {
    switch (type) {
      case _QRType.url:
      case _QRType.paypal:
        return [FilledButton.icon(
          onPressed: () {
            // launchUrl(Uri.parse(value));
          },
          icon: const Icon(Icons.open_in_browser),
          label: const Text('Fungua Browser'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48)),
        )];
      case _QRType.mpesa:
        return [FilledButton.icon(
          onPressed: () {
            // launchUrl(Uri.parse('mpesa://...'));
          },
          icon: const Text('📱'),
          label: const Text('Fungua M-Pesa'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: const Color(0xFF00A651),
          ),
        )];
      case _QRType.dupzero:
        return [FilledButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.verified),
          label: const Text('Thibitisha Malipo ya DupZero'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48)),
        )];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan QR Code'),
        centerTitle: true,
        actions: [
          // Torch toggle
          IconButton(
            icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off,
              color: _torchOn ? Colors.yellow : Colors.white),
            onPressed: () {
              _controller.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
          ),
          // Flip camera
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(children: [
        // Camera view
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
        ),

        // Scan overlay
        CustomPaint(
          painter: _ScanOverlayPainter(color: cs.primary),
          child: const SizedBox.expand(),
        ),

        // Bottom instructions
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
            child: Column(children: [
              Text(
                'Elekeza kamera kwenye QR code',
                style: TextStyle(color: Colors.white.withOpacity(0.9),
                  fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'M-Pesa · Airtel · CRDB · NMB · Visa · PayPal · Zote',
                style: TextStyle(color: Colors.white.withOpacity(0.6),
                  fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

// QR type classification
enum _QRType {
  url, mpesa, airtel, bank, emvco, paypal, phone, email, dupzero, text;

  String get label {
    switch (this) {
      case url:     return 'Website';
      case mpesa:   return 'M-Pesa';
      case airtel:  return 'Airtel Money';
      case bank:    return 'Benki';
      case emvco:   return 'Card Payment';
      case paypal:  return 'PayPal';
      case phone:   return 'Simu';
      case email:   return 'Email';
      case dupzero: return 'DupZero Pay';
      case text:    return 'Maandishi';
    }
  }

  String get icon {
    switch (this) {
      case url:     return '🌐';
      case mpesa:   return '📱';
      case airtel:  return '📡';
      case bank:    return '🏦';
      case emvco:   return '💳';
      case paypal:  return '🅿️';
      case phone:   return '📞';
      case email:   return '📧';
      case dupzero: return '⬡';
      case text:    return '📝';
    }
  }
}

// Scan frame overlay painter
class _ScanOverlayPainter extends CustomPainter {
  final Color color;
  const _ScanOverlayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    final frameSize = size.width * 0.7;
    final frameLeft = (size.width - frameSize) / 2;
    final frameTop = (size.height - frameSize) / 2;
    final frame = Rect.fromLTWH(frameLeft, frameTop, frameSize, frameSize);

    // Darken outside frame
    canvas.drawPath(
      Path.combine(PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(frame, const Radius.circular(16))),
      ),
      paint,
    );

    // Corner brackets
    final cornerPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const cLen = 24.0;

    // Top-left
    canvas.drawLine(Offset(frameLeft, frameTop + cLen), Offset(frameLeft, frameTop), cornerPaint);
    canvas.drawLine(Offset(frameLeft, frameTop), Offset(frameLeft + cLen, frameTop), cornerPaint);
    // Top-right
    canvas.drawLine(Offset(frameLeft + frameSize - cLen, frameTop), Offset(frameLeft + frameSize, frameTop), cornerPaint);
    canvas.drawLine(Offset(frameLeft + frameSize, frameTop), Offset(frameLeft + frameSize, frameTop + cLen), cornerPaint);
    // Bottom-left
    canvas.drawLine(Offset(frameLeft, frameTop + frameSize - cLen), Offset(frameLeft, frameTop + frameSize), cornerPaint);
    canvas.drawLine(Offset(frameLeft, frameTop + frameSize), Offset(frameLeft + cLen, frameTop + frameSize), cornerPaint);
    // Bottom-right
    canvas.drawLine(Offset(frameLeft + frameSize - cLen, frameTop + frameSize), Offset(frameLeft + frameSize, frameTop + frameSize), cornerPaint);
    canvas.drawLine(Offset(frameLeft + frameSize, frameTop + frameSize - cLen), Offset(frameLeft + frameSize, frameTop + frameSize), cornerPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
