import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/pricing_constants.dart';
import '../blocs/settings/settings_bloc.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});
  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  int _selected = 1; // 0=monthly, 1=yearly, 2=lifetime
  bool _loading = false;

  final _plans = [
    {
      'label':  'Kila Mwezi',
      'price':  PricingConstants.monthlyPrice,
      'period': '/mwezi',
      'badge':  null,
      'id':     PricingConstants.monthlyProductId,
      'save':   null,
    },
    {
      'label':  'Kila Mwaka',
      'price':  PricingConstants.yearlyPrice,
      'period': '/mwaka',
      'badge':  'OKOA 20%',
      'id':     PricingConstants.yearlyProductId,
      'save':   'Badala ya Tsh 60,000',
    },
    {
      'label':  'Milele',
      'price':  PricingConstants.lifetimePrice,
      'period': 'mara moja',
      'badge':  'BORA ZAIDI',
      'id':     PricingConstants.lifetimeProductId,
      'save':   'Lipa mara moja, tumia daima',
    },
  ];

  final _features = [
    {'icon': '☁️',  'title': 'Cloud Storage Scan',      'sub': 'Google Drive, OneDrive, iCloud'},
    {'icon': '✨',  'title': 'AI Similar Image Detection','sub': 'Perceptual hashing ya hali ya juu'},
    {'icon': '∞',   'title': 'Scan Zisizo na Kikomo',    'sub': 'Bila kikomo cha files 500'},
    {'icon': '📅',  'title': 'Usafi wa Kiotomatiki',     'sub': 'Kila siku, wiki, au mwezi'},
    {'icon': '🔄',  'title': 'Sync Vifaa Vyote',         'sub': 'Historia kwenye simu zote'},
    {'icon': '📲',  'title': 'Futa Baada ya Kutuma',     'sub': 'WhatsApp, Instagram, TikTok'},
    {'icon': '📊',  'title': 'Analytics ya Kina',        'sub': 'Ripoti kamili ya hifadhi'},
    {'icon': '🛡️', 'title': 'Kipaumbele cha Msaada',    'sub': 'Msaada wa haraka 24/7'},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DupZero Pro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // ── Hero ────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(children: [
              const Text('👑', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 12),
              Text('DupZero Pro',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                'Lipa Tsh 5,000 tu kwa mwezi
Upate uzoefu kamili wa kusafisha simu',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🎁 Jaribu Bure Siku 7 — Bila Malipo',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ── Features ────────────────────────────────────
              Text('Unachopata na Pro',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: _features.asMap().entries.map((e) {
                    final f = e.value;
                    return Column(children: [
                      ListTile(
                        leading: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text(f['icon']!, style: const TextStyle(fontSize: 20))),
                        ),
                        title: Text(f['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(f['sub']!, style: const TextStyle(fontSize: 12)),
                        trailing: Icon(Icons.check_circle, color: cs.primary, size: 20),
                      ),
                      if (e.key < _features.length - 1)
                        const Divider(height: 1, indent: 72),
                    ]);
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // ── Plans ────────────────────────────────────────
              Text('Chagua Mpango Wako',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              ..._plans.asMap().entries.map((entry) {
                final i = entry.key;
                final p = entry.value;
                final isSelected = _selected == i;
                return GestureDetector(
                  onTap: () => setState(() => _selected = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? cs.primaryContainer : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? cs.primary : cs.outline.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(color: cs.primary.withOpacity(0.2),
                          blurRadius: 12, offset: const Offset(0, 4))
                      ] : [],
                    ),
                    child: Row(children: [
                      // Radio
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? cs.primary : cs.outline, width: 2),
                          color: isSelected ? cs.primary : Colors.transparent,
                        ),
                        child: isSelected
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                      ),
                      const SizedBox(width: 14),
                      // Info
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(p['label']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15,
                              color: isSelected ? cs.primary : cs.onSurface,
                            )),
                          const SizedBox(width: 8),
                          if (p['badge'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(p['badge']!,
                                style: TextStyle(
                                  color: cs.onPrimary, fontSize: 10, fontWeight: FontWeight.w800)),
                            ),
                        ]),
                        if (p['save'] != null) ...[
                          const SizedBox(height: 2),
                          Text(p['save']!, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
                        ],
                      ])),
                      // Price
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(p['price']!,
                          style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800,
                            color: isSelected ? cs.primary : cs.onSurface,
                          )),
                        Text(p['period']!,
                          style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
                      ]),
                    ]),
                  ),
                );
              }),

              const SizedBox(height: 8),

              // ── CTA Button ───────────────────────────────────
              FilledButton(
                onPressed: _loading ? null : _subscribe,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: _loading
                  ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(
                      _selected == 2
                        ? 'Nunua Milele — ${PricingConstants.lifetimePrice}'
                        : 'Anza Jaribu Bure la Siku 7',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
              ),

              const SizedBox(height: 12),

              // ── QR Code Payment ──────────────────────────────
              OutlinedButton.icon(
                onPressed: () => context.push('/qr-payment'),
                icon: const Icon(Icons.qr_code),
                label: const Text('Lipa kwa QR Code (M-Pesa, Airtel, Benki...)'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),

              const SizedBox(height: 12),

              // ── Fine print ───────────────────────────────────
              Center(
                child: Text(
                  'Ghairi wakati wowote · Malipo salama kupitia Google Play
'
                  'Baada ya jaribu bure, utalipishwa ${_plans[_selected]['price']} ${_plans[_selected]['period']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                ),
              ),

              const SizedBox(height: 24),

              // ── Compare free vs pro ──────────────────────────
              Text('Linganisha Mipango',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Card(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1.5),
                  },
                  children: [
                    // Header
                    TableRow(
                      decoration: BoxDecoration(color: cs.surfaceContainerHighest),
                      children: [
                        const Padding(padding: EdgeInsets.all(12),
                          child: Text('Kipengele', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                        Padding(padding: const EdgeInsets.all(12),
                          child: Text('Bure', textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: cs.onSurfaceVariant))),
                        Padding(padding: const EdgeInsets.all(12),
                          child: Text('Pro', textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: cs.primary))),
                      ],
                    ),
                    ...[
                      ['Scan files za ndani',       '✅', '✅'],
                      ['Futa duplicates',           '✅', '✅'],
                      ['Recycle Bin',               '✅', '✅'],
                      ['Kiasi cha files',           '500', '∞'],
                      ['Cloud scan',                '❌', '✅'],
                      ['AI similar detection',      '❌', '✅'],
                      ['Usafi wa kiotomatiki',      '❌', '✅'],
                      ['Sync vifaa vyote',          '❌', '✅'],
                      ['Analytics ya kina',         '❌', '✅'],
                      ['Msaada wa kipaumbele',      '❌', '✅'],
                    ].map((row) => TableRow(
                      children: row.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Text(e.value,
                          textAlign: e.key == 0 ? TextAlign.left : TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: e.key == 0 ? cs.onSurface : cs.onSurfaceVariant,
                          )),
                      )).toList(),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Developer credit
              Center(child: Text('DupZero v1.1.0 · Developed by Tavoo',
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant))),
              const SizedBox(height: 16),
            ]),
          ),
        ]),
      ),
    );
  }

  Future<void> _subscribe() async {
    setState(() => _loading = true);
    final service = PurchaseService();
    await service.initialize();
    service.onPurchaseSuccess = (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Asante! Pro imewezeshwa. Furahia DupZero Pro!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    };
    service.onPurchaseError = (msg) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $msg'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    };
    final plan = _plans[_selected];
    await service.buySubscription(plan['id'] as String);
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Asante! Unaanza jaribu bure la siku ${PricingConstants.freeTrialDays}.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
