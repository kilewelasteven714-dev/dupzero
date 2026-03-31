import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _ctrl = PageController();
  int _page = 0;

  final _slides = const [
    _Slide(
      emoji: '🧹',
      title: 'Welcome to DupZero',
      body: 'The most powerful duplicate file cleaner. '
            'Find and remove duplicate files to free up valuable storage space.',
    ),
    _Slide(
      emoji: '🔍',
      title: 'Detect All Duplicates',
      body: 'Finds exact duplicates using SHA-256 hashing AND near-duplicate photos '
            'using AI perceptual hashing. Works 100% offline.',
    ),
    _Slide(
      emoji: '⚠️',
      title: 'Smart Storage Alerts',
      body: 'DupZero notifies you when your storage reaches 70% full, '
            'so you can review and decide what to delete.',
    ),
    _Slide(
      emoji: '🛡️',
      title: 'You Are in Control',
      body: 'Every deletion requires your confirmation. '
            'Files deleted from DupZero are permanently removed. '
            'Use the Recycle Bin to restore files within 30 days.',
    ),
    _Slide(
      emoji: '🌐',
      title: 'Offline First',
      body: 'All scanning, detection, and cleanup works without internet. '
            'Online is only needed for cloud scanning and app updates.',
      isDeveloperSlide: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // Skip button
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: _finish,
              child: const Text('Skip'),
            ),
          ),

          // Pages
          Expanded(
            child: PageView.builder(
              controller: _ctrl,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
            ),
          ),

          // Dot indicators
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(
            _slides.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _page == i ? 24 : 8, height: 8,
              decoration: BoxDecoration(
                color: _page == i ? cs.primary : cs.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          )),

          const SizedBox(height: 32),

          // Action button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FilledButton(
              onPressed: isLast ? _finish : _next,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 54)),
              child: Text(isLast ? 'Get Started' : 'Next',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),

          const SizedBox(height: 12),
          // Developer credit on last slide
          if (isLast)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Developed by Tavoo',
                style: TextStyle(fontSize: 12, color: cs.primary, fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  void _next() {
    _ctrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingKey, true);
    if (mounted) context.go('/auth');
  }
}

class _Slide {
  final String emoji, title, body;
  final bool isDeveloperSlide;
  const _Slide({
    required this.emoji, required this.title, required this.body,
    this.isDeveloperSlide = false,
  });
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  const _SlideView({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(
            color: cs.primaryContainer.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Center(child: Text(slide.emoji, style: const TextStyle(fontSize: 56))),
        ),
        const SizedBox(height: 32),
        Text(slide.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Text(slide.body,
          style: TextStyle(
            fontSize: 15, color: cs.onSurfaceVariant, height: 1.6),
          textAlign: TextAlign.center),
      ]),
    );
  }
}
