import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/app_imports.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetching screen dimensions for responsive scaling
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06, // 6% of screen width dynamic padding
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Section: Logo & Headings
                        Column(
                          children: [
                            SizedBox(height: screenHeight * 0.03),

                            // 1. App Icon / Logo (Scales dynamically)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(isTablet ? 32 : 24),
                              child: Image.asset(
                                ImageConstant.splashLogo,
                                height: isTablet ? 180 : 140,
                                width: isTablet ? 180 : 140,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'A·I·N',
                                      style: TextStyle(
                                        fontSize: isTablet ? 64 : 48,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF2D3142),
                                        letterSpacing: 4.0,
                                      ),
                                    ),
                                    Text(
                                      'ASSIGNMENT IN NEED',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF6B2CA2),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // 2. Main Header Typography
                            Text(
                              'Expert Academic Support',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2E3246),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'When You Need It Most',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF47946),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // 3. Subtitle Description Text
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                              child: Text(
                                'Get high-quality assignments, essays,\ndissertations & more — on time,\nevery time.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 13,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5E606E),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Middle Section: Central 3D Illustration
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                          child: Image.asset(
                            ImageConstant.splash,
                            height: screenHeight * (isTablet ? 0.25 : 0.2),
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Bottom Section: Action Button & Trust Footer
                        Column(
                          children: [
                            // 5. Action Button ("Get Started ->")
                            SizedBox(
                              width: double.infinity,
                              height: isTablet ? 54 : 46, // Slightly taller button for better tap targets
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.offNamed(Routes.ONBOARDING);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF47946),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Get Started',
                                      style: TextStyle(
                                        fontSize: isTablet ? 22 : 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: isTablet ? 26 : 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // 7. Bottom Trust Text Footer
                            Text(
                              'Trusted by 25,000+ Students',
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4A4C59),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper widget to build the slide indicators (Kept for your onboarding or usage elsewhere)
  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFF47946)
            : const Color(0xFFF47946).withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}