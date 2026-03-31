import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/services/qr_payment_service.dart';

/// QR Code Payment Page
/// User selects plan + payment method → sees QR code → pays
/// Developed by Tavoo — DupZero

class QRPaymentPage extends StatefulWidget {
  const QRPaymentPage({super.key});

  @override
  State<QRPaymentPage> createState() => _QRPaymentPageState();
}

class _QRPaymentPageState extends State<QRPaymentPage>
    with SingleTickerProviderStateMixin {

  final _service = QRPaymentService();
  int _selectedPlan = 0;
  PaymentMethod _selectedMethod = PaymentMethod.mpesaTanzania;
  String? _qrData;
  String? _txId;
  DateTime? _expiresAt;
  Timer? _timer;
  int _secondsLeft = 1800; // 30 minutes
  bool _paymentConfirmed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _generateQR();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _generateQR() {
    _timer?.cancel();
    final plan = QRPaymentService.plans[_selectedPlan];
    _txId = _service.generateTransactionId();
    _qrData = _service.generateQRData(
      method: _selectedMethod,
      plan: plan,
      transactionId: _txId!,
    );
    _expiresAt = DateTime.now().add(const Duration(minutes: 30));
    _secondsLeft = 1800;

    setState(() {});

    // Countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          t.cancel();
          _generateQR(); // Auto-refresh QR
        }
      });
    });
  }

  String get _timeLeft {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';
  }

  Color get _timerColor {
    if (_secondsLeft > 600) return Colors.green;
    if (_secondsLeft > 300) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final plan = QRPaymentService.plans[_selectedPlan];
    final currency = _selectedMethod.currency;
    final methodColor = Color(_selectedMethod.colorValue);

    if (_paymentConfirmed) return _buildSuccess(cs, theme, plan);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with QR Code'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan QR Code',
            onPressed: () => Navigator.pushNamed(context, '/qr-scanner'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [

          // ── Step 1 — Choose Plan ───────────────────────────
          _buildSection('1. Chagua Mpango', child: Column(
            children: QRPaymentService.plans.asMap().entries.map((e) {
              final i = e.key;
              final p = e.value;
              final sel = _selectedPlan == i;
              return GestureDetector(
                onTap: () { setState(() => _selectedPlan = i); _generateQR(); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: sel ? cs.primaryContainer : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: sel ? cs.primary : cs.outline.withOpacity(0.3),
                      width: sel ? 2 : 1,
                    ),
                  ),
                  child: Row(children: [
                    // Radio
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: sel ? cs.primary : cs.outline, width: 2),
                        color: sel ? cs.primary : Colors.transparent,
                      ),
                      child: sel ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(p.name, style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: sel ? cs.primary : cs.onSurface,
                        )),
                        if (p.badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(p.badge!, style: TextStyle(
                              color: cs.onPrimary, fontSize: 10, fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ]),
                      Text(
                        '${p.formattedAmount(currency)} ${p.period}',
                        style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                      ),
                    ])),
                  ]),
                ),
              );
            }).toList(),
          )),

          // ── Step 2 — Choose Payment Method ────────────────
          _buildSection('2. Chagua Njia ya Malipo', child: Column(children: [
            // Tanzania
            _buildMethodGroup('🇹🇿 Tanzania', [
              PaymentMethod.mpesaTanzania,
              PaymentMethod.airtelTanzania,
              PaymentMethod.crdb,
              PaymentMethod.nmb,
            ], cs),
            const SizedBox(height: 12),
            // Kenya
            _buildMethodGroup('🇰🇪 Kenya', [
              PaymentMethod.mpesaKenya,
            ], cs),
            const SizedBox(height: 12),
            // Worldwide
            _buildMethodGroup('🌍 Duniani Kote', [
              PaymentMethod.visaMastercard,
              PaymentMethod.paypal,
            ], cs),
          ])),

          // ── Step 3 — QR Code ──────────────────────────────
          _buildSection('3. Scan QR Code Kulipa', child: Column(
            children: [
              // Payment summary
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: methodColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: methodColor.withOpacity(0.3)),
                ),
                child: Row(children: [
                  Text(_selectedMethod.icon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_selectedMethod.displayName,
                      style: TextStyle(fontWeight: FontWeight.w700, color: methodColor)),
                    Text(
                      '${plan.formattedAmount(_selectedMethod.currency)} ${plan.period}',
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                    ),
                  ])),
                  // Transaction ID
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _txId ?? ''));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transaction ID copied!'),
                          behavior: SnackBarBehavior.floating));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_txId ?? '', style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 20),

              // QR Code
              if (_qrData != null) ...[
                ScaleTransition(
                  scale: _pulseAnim,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: methodColor.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _qrData!,
                      version: QrVersions.auto,
                      size: 220,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      embeddedImage: const AssetImage('assets/icons/app_icon.png'),
                      embeddedImageStyle: const QrEmbeddedImageStyle(
                        size: Size(40, 40),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Timer
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.timer, color: _timerColor, size: 18),
                  const SizedBox(width: 6),
                  Text('QR inakwisha: $_timeLeft',
                    style: TextStyle(color: _timerColor, fontWeight: FontWeight.w700)),
                ]),

                const SizedBox(height: 8),

                // Refresh button
                TextButton.icon(
                  onPressed: _generateQR,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tengeneza QR Mpya'),
                ),
              ],

              const SizedBox(height: 16),

              // Instructions
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Jinsi ya kulipa:',
                    style: TextStyle(fontWeight: FontWeight.w700, color: cs.primary)),
                  const SizedBox(height: 8),
                  ..._getInstructions(_selectedMethod).asMap().entries.map((e) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 22, height: 22,
                          margin: const EdgeInsets.only(right: 10, top: 1),
                          decoration: BoxDecoration(
                            color: cs.primary, shape: BoxShape.circle),
                          child: Center(child: Text('${e.key + 1}',
                            style: TextStyle(color: cs.onPrimary,
                              fontSize: 11, fontWeight: FontWeight.w700))),
                        ),
                        Expanded(child: Text(e.value,
                          style: const TextStyle(fontSize: 13, height: 1.4))),
                      ]),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 20),

              // Confirm payment button
              FilledButton.icon(
                onPressed: _showConfirmDialog,
                icon: const Icon(Icons.check_circle),
                label: const Text('Nimemaliza Kulipa'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: Colors.green,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Ukiwa na tatizo — wasiliana: support@dupzero.app',
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _buildSection(String title, {required Widget child}) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 20),
        Row(children: [
          Container(width: 4, height: 18,
            decoration: BoxDecoration(
              color: cs.primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Text(title, style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 15, color: cs.primary)),
        ]),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }

  Widget _buildMethodGroup(String label, List<PaymentMethod> methods, ColorScheme cs) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
        color: cs.onSurfaceVariant)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: methods.map((m) {
        final sel = _selectedMethod == m;
        final color = Color(m.colorValue);
        return GestureDetector(
          onTap: () { setState(() => _selectedMethod = m); _generateQR(); },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: sel ? color.withOpacity(0.15) : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: sel ? color : cs.outline.withOpacity(0.3),
                width: sel ? 2 : 1,
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(m.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(m.displayName, style: TextStyle(
                fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: sel ? color : cs.onSurface,
              )),
            ]),
          ),
        );
      }).toList()),
    ]);
  }

  List<String> _getInstructions(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.mpesaTanzania:
        return [
          'Fungua M-Pesa kwenye simu yako',
          'Chagua "Lipa na M-Pesa" → "Scan QR"',
          'Piga picha QR code hii',
          'Thibitisha kiasi na bonyeza Lipa',
          'Utapata SMS ya uthibitisho',
        ];
      case PaymentMethod.airtelTanzania:
        return [
          'Fungua Airtel Money app',
          'Chagua "Lipa" → "Scan QR Code"',
          'Piga picha QR code hii',
          'Thibitisha na weka PIN yako',
        ];
      case PaymentMethod.crdb:
        return [
          'Fungua CRDB Tembo app',
          'Chagua "Pay" → "QR Payment"',
          'Scan QR code hii',
          'Ingiza PIN yako kuthibitisha',
        ];
      case PaymentMethod.nmb:
        return [
          'Fungua NMB Mobile app',
          'Chagua "Payments" → "QR Code"',
          'Scan QR code hii',
          'Thibitisha malipo',
        ];
      case PaymentMethod.mpesaKenya:
        return [
          'Fungua M-Pesa kwenye simu yako',
          'Chagua "Lipa na M-Pesa" → "Scan QR"',
          'Piga picha QR code hii',
          'Ingiza PIN yako kuthibitisha',
        ];
      case PaymentMethod.visaMastercard:
        return [
          'Fungua app ya benki yako',
          'Chagua "Pay" → "Scan QR"',
          'Scan QR code hii',
          'Au tumia Google Pay / Apple Pay',
          'Thibitisha malipo yako',
        ];
      case PaymentMethod.paypal:
        return [
          'Fungua PayPal app',
          'Bonyeza "Scan" chini ya screen',
          'Scan QR code hii',
          'Au fungua link iliyopo QR kwenye browser',
          'Login na thibitisha malipo',
        ];
    }
  }

  void _showConfirmDialog() {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Text('✅', style: TextStyle(fontSize: 40)),
        title: const Text('Thibitisha Malipo',
          style: TextStyle(fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Je, umefanya malipo kwa ${_selectedMethod.displayName}?',
            textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              const Icon(Icons.receipt, size: 16),
              const SizedBox(width: 8),
              Text('Kumb. Namba: $_txId',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hapana, bado'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _paymentConfirmed = true);
            },
            child: const Text('Ndiyo, nimelipa'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(ColorScheme cs, ThemeData theme, PaymentPlan plan) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Success animation
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 70),
            ),
            const SizedBox(height: 24),
            Text('Malipo Yamekamilika! 🎉',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text(
              'Asante Tavoo! DupZero ${plan.name} imewezeshwa.\n'
              'Furahia vipengele vyote vya Pro!',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text('Kumb: $_txId',
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            const SizedBox(height: 32),
            // What's unlocked
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Umefungua:', style: TextStyle(
                    fontWeight: FontWeight.w700, color: cs.primary)),
                  const SizedBox(height: 10),
                  ...[
                    'Cloud Storage Scan (Drive, OneDrive, iCloud)',
                    'AI Similar Image Detection',
                    'Scan zisizo na kikomo',
                    'Usafi wa kiotomatiki',
                    'Analytics ya kina',
                  ].map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(f, style: const TextStyle(fontSize: 13)),
                    ]),
                  )),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context)
                ..pop()..pop(),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52)),
              child: const Text('Rudi Nyumbani'),
            ),
          ]),
        ),
      ),
    );
  }
}
