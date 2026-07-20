import 'package:ain/app/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: controller.pageController,
            builder: (context, child) {
              double pageOffset = 0;
              if (controller.pageController.hasClients &&
                  controller.pageController.page != null) {
                pageOffset = controller.pageController.page!;
              }
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ContinuousWavePainter(pageOffset: pageOffset),
                    ),
                  ),
                  child!,
                ],
              );
            },
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.onboardingData.length,
              itemBuilder: (context, index) {
                return _OnboardingPage(
                  data: controller.onboardingData[index],
                  index: index,
                  pageController: controller.pageController,
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomControls(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Continuous Wave Painter
// ─────────────────────────────────────────────
class _ContinuousWavePainter extends CustomPainter {
  const _ContinuousWavePainter({required this.pageOffset});
  final double pageOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    // SLIDE 1 — Ascending ribbon: low-left → high-right
    final s1LeftTopY  = h * 0.28;
    final s1TopCtrlX1 = w * 0.35;
    final s1TopCtrlY1 = h * 0.22;
    final s1TopCtrlX2 = w * 0.65;
    final s1TopCtrlY2 = h * 0.08;
    final s1RightTopY = h * 0.10;
    final s1RightBotY = h * 0.34;
    final s1BotCtrlX2 = w * 0.65;
    final s1BotCtrlY2 = h * 0.32;
    final s1BotCtrlX1 = w * 0.35;
    final s1BotCtrlY1 = h * 0.46;
    final s1LeftBotY  = h * 0.52;

    // SLIDE 2 — Very shallow U-curve
    final s2LeftTopY  = h * 0.14;
    final s2TopCtrlX1 = w * 0.30;
    final s2TopCtrlY1 = h * 0.22;
    final s2TopCtrlX2 = w * 0.70;
    final s2TopCtrlY2 = h * 0.22;
    final s2RightTopY = h * 0.14;
    final s2RightBotY = h * 0.38;
    final s2BotCtrlX2 = w * 0.70;
    final s2BotCtrlY2 = h * 0.42;
    final s2BotCtrlX1 = w * 0.30;
    final s2BotCtrlY1 = h * 0.42;
    final s2LeftBotY  = h * 0.38;

    // SLIDE 3 — Descending ribbon: high-left → low-right
    final s3LeftTopY  = h * 0.10;
    final s3TopCtrlX1 = w * 0.35;
    final s3TopCtrlY1 = h * 0.08;
    final s3TopCtrlX2 = w * 0.65;
    final s3TopCtrlY2 = h * 0.22;
    final s3RightTopY = h * 0.28;
    final s3RightBotY = h * 0.52;
    final s3BotCtrlX2 = w * 0.65;
    final s3BotCtrlY2 = h * 0.46;
    final s3BotCtrlX1 = w * 0.35;
    final s3BotCtrlY1 = h * 0.32;
    final s3LeftBotY  = h * 0.34;

    double leftTopY, topCtrlX1, topCtrlY1, topCtrlX2, topCtrlY2, rightTopY;
    double rightBotY, botCtrlX2, botCtrlY2, botCtrlX1, botCtrlY1, leftBotY;
    List<Color> gradientColors;

    if (pageOffset <= 1.0) {
      final t = pageOffset;
      leftTopY  = s1LeftTopY  + (s2LeftTopY  - s1LeftTopY)  * t;
      topCtrlX1 = s1TopCtrlX1 + (s2TopCtrlX1 - s1TopCtrlX1) * t;
      topCtrlY1 = s1TopCtrlY1 + (s2TopCtrlY1 - s1TopCtrlY1) * t;
      topCtrlX2 = s1TopCtrlX2 + (s2TopCtrlX2 - s1TopCtrlX2) * t;
      topCtrlY2 = s1TopCtrlY2 + (s2TopCtrlY2 - s1TopCtrlY2) * t;
      rightTopY = s1RightTopY + (s2RightTopY - s1RightTopY) * t;
      rightBotY = s1RightBotY + (s2RightBotY - s1RightBotY) * t;
      botCtrlX2 = s1BotCtrlX2 + (s2BotCtrlX2 - s1BotCtrlX2) * t;
      botCtrlY2 = s1BotCtrlY2 + (s2BotCtrlY2 - s1BotCtrlY2) * t;
      botCtrlX1 = s1BotCtrlX1 + (s2BotCtrlX1 - s1BotCtrlX1) * t;
      botCtrlY1 = s1BotCtrlY1 + (s2BotCtrlY1 - s1BotCtrlY1) * t;
      leftBotY  = s1LeftBotY  + (s2LeftBotY  - s1LeftBotY)  * t;
      gradientColors = [
        Color.lerp(const Color(0xFF6A35E8), const Color(0xFF4C66EF), t)!,
        Color.lerp(const Color(0xFF9C42E0), const Color(0xFF3B82F6), t)!,
      ];
    } else {
      final t = pageOffset - 1.0;
      leftTopY  = s2LeftTopY  + (s3LeftTopY  - s2LeftTopY)  * t;
      topCtrlX1 = s2TopCtrlX1 + (s3TopCtrlX1 - s2TopCtrlX1) * t;
      topCtrlY1 = s2TopCtrlY1 + (s3TopCtrlY1 - s2TopCtrlY1) * t;
      topCtrlX2 = s2TopCtrlX2 + (s3TopCtrlX2 - s2TopCtrlX2) * t;
      topCtrlY2 = s2TopCtrlY2 + (s3TopCtrlY2 - s2TopCtrlY2) * t;
      rightTopY = s2RightTopY + (s3RightTopY - s2RightTopY) * t;
      rightBotY = s2RightBotY + (s3RightBotY - s2RightBotY) * t;
      botCtrlX2 = s2BotCtrlX2 + (s3BotCtrlX2 - s2BotCtrlX2) * t;
      botCtrlY2 = s2BotCtrlY2 + (s3BotCtrlY2 - s2BotCtrlY2) * t;
      botCtrlX1 = s2BotCtrlX1 + (s3BotCtrlX1 - s2BotCtrlX1) * t;
      botCtrlY1 = s2BotCtrlY1 + (s3BotCtrlY1 - s2BotCtrlY1) * t;
      leftBotY  = s2LeftBotY  + (s3LeftBotY  - s2LeftBotY)  * t;
      gradientColors = [
        Color.lerp(const Color(0xFF4C66EF), const Color(0xFF2575FC), t)!,
        Color.lerp(const Color(0xFF3B82F6), const Color(0xFF1AABCB), t)!,
      ];
    }

    path.moveTo(0, leftTopY);
    path.cubicTo(topCtrlX1, topCtrlY1, topCtrlX2, topCtrlY2, w, rightTopY);
    path.lineTo(w, rightBotY);
    path.cubicTo(botCtrlX2, botCtrlY2, botCtrlX1, botCtrlY1, 0, leftBotY);
    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ContinuousWavePainter old) =>
      old.pageOffset != pageOffset;
}

// ─────────────────────────────────────────────
// Single Onboarding Page — with parallax + fade
// ─────────────────────────────────────────────
class _OnboardingPage extends StatefulWidget {
  const _OnboardingPage({
    required this.data,
    required this.index,
    required this.pageController,
  });
  final OnboardingModel data;
  final int index;
  final PageController pageController;

  @override
  State<_OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<_OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final imageAreaTop = topPadding + 20;
    final imageAreaHeight = screenHeight * 0.46;

    return AnimatedBuilder(
      animation: widget.pageController,
      builder: (context, child) {
        double delta = 0.0;
        if (widget.pageController.hasClients &&
            widget.pageController.page != null) {
          delta = widget.pageController.page! - widget.index;
        }
        delta = delta.clamp(-1.0, 1.0);
        final opacity = (1.0 - delta.abs()).clamp(0.0, 1.0);
        final imageParallax = delta * 30.0;
        final textSlide = delta * 20.0;

        return Stack(
          children: [
            Positioned(
              top: imageAreaTop,
              left: 0,
              right: 0,
              height: imageAreaHeight,
              child: Opacity(
                opacity: opacity,
                child: AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(imageParallax, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: Center(
                    child: Image.asset(
                      widget.data.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const _PlaceholderIllustration(),
                    ),
                  ),
                ),
              ),
            ),

            // ── Text with fade + slide ──
            Positioned(
              top: screenHeight * 0.60,
              left: 0,
              right: 0,
              bottom: 110,
              child: Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, textSlide),
                  child: _TextSection(
                    title: widget.data.title,
                    description: widget.data.description,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Placeholder illustration
// ─────────────────────────────────────────────
class _PlaceholderIllustration extends StatelessWidget {
  const _PlaceholderIllustration();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(painter: _DeskPersonPainter()),
    );
  }
}

class _DeskPersonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withValues(alpha:0.9);
    final lb = Paint()..color = const Color(0xFFB3D4F5);
    final skin = Paint()..color = const Color(0xFFFFD6B0);
    final dark = Paint()..color = const Color(0xFF2D2D2D);
    final dp = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final db = Paint()
      ..color = Colors.white.withValues(alpha:0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final cx = size.width / 2;
    for (final p in [
      Offset(cx - 70, 20),
      Offset(cx + 40, 10),
      Offset(cx - 40, 50),
      Offset(cx + 60, 50),
      Offset(cx - 80, 70),
      Offset(cx + 20, 30),
    ]) {
      final r = RRect.fromRectAndRadius(
          Rect.fromCenter(center: p, width: 28, height: 36),
          const Radius.circular(3));
      canvas.drawRRect(r, dp);
      canvas.drawRRect(r, db);
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 80, size.height * .58, 160, 14),
            const Radius.circular(4)),
        white);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 32, size.height * .50, 64, 10),
            const Radius.circular(3)),
        lb);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 28, size.height * .36, 56, 36),
            const Radius.circular(3)),
        lb);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 22, size.height * .55, 44, 30),
            const Radius.circular(8)),
        lb);
    canvas.drawCircle(Offset(cx, size.height * .46), 18, skin);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 20, size.height * .72, 16, 28),
            const Radius.circular(4)),
        lb);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx + 4, size.height * .72, 16, 28),
            const Radius.circular(4)),
        lb);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 24, size.height * .90, 20, 9),
            const Radius.circular(4)),
        dark);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx + 4, size.height * .90, 20, 9),
            const Radius.circular(4)),
        dark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ─────────────────────────────────────────────
// Text Section
// ─────────────────────────────────────────────
class _TextSection extends StatelessWidget {
  const _TextSection({required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7A7A9D),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom Controls — animated dot + button pulse
// ─────────────────────────────────────────────
class _BottomControls extends GetView<OnboardingController> {
  const _BottomControls();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).padding.bottom + 20,
        top: 10,
      ),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.onboardingData.length,
                  (i) => _DotIndicator(
                  isActive: controller.currentIndex.value == i),
            ),
          )),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.skipOnboarding,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                        color: Color(0xFFDDDDEE), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Skip',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7A7A9D))),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _AnimatedNextButton(
                  onPressed: controller.nextPage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated Next Button — scale pulse on tap
// ─────────────────────────────────────────────
class _AnimatedNextButton extends StatefulWidget {
  const _AnimatedNextButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_AnimatedNextButton> createState() => _AnimatedNextButtonState();
}

class _AnimatedNextButtonState extends State<_AnimatedNextButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.forward();
  void _onTapUp(_) => _ctrl.reverse();
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Dot Indicator
// ─────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ?  AppColors.secondary
            : const Color(0xFFD0D0E8),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}