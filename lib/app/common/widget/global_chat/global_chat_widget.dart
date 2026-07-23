import 'dart:async';
import 'dart:math' as math;
import '../../constant/app_imports.dart';

class GlobalChatWidget extends StatefulWidget {
  final double bottomMargin;
  final double rightMargin;

  const GlobalChatWidget({
    super.key,
    this.bottomMargin = 90.0,
    this.rightMargin = 16.0,
  });

  @override
  State<GlobalChatWidget> createState() => _GlobalChatWidgetState();
}

// 1. Changed to TickerProviderStateMixin because we now need TWO animation controllers
class _GlobalChatWidgetState extends State<GlobalChatWidget>
    with TickerProviderStateMixin {
  bool _isExpanded = true;
  Timer? _timer;

  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  // 2. Added a new controller specifically for the swirling gradient
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();

    // Pulse animation (starts when collapsed)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 3. Gradient rotation animation (spins continuously)
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Speed of the swirl
    )..repeat();

    // Timer to collapse text after 3 seconds
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isExpanded = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.bottomMargin,
      right: widget.rightMargin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(Routes.CHAT);
          },
          borderRadius: BorderRadius.circular(30),
          child: ScaleTransition(
            scale: _isExpanded ? const AlwaysStoppedAnimation(1.0) : _scaleAnimation,
            // 4. Wrap AnimatedContainer in AnimatedBuilder to rebuild on gradient tick
            child: AnimatedBuilder(
              animation: _gradientController,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: _isExpanded ? 14 : 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: SweepGradient(
                      center: FractionalOffset.center,
                      colors: [
                        AppColors.primaryPurple,
                        AppColors.secondary, // Using the second color you requested
                        AppColors.primaryPurple, // Loop back to the first color for a smooth transition
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      transform: GradientRotation(_gradientController.value * 2 * math.pi),
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              // The child inside the builder won't rebuild unnecessarily, saving performance
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.support_agent_rounded,
                        color: AppColors.white,
                        size: 24,
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.statusGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                    child: _isExpanded
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(width: 8),
                        Text(
                          'Need Help?',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}