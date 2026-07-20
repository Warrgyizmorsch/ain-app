import '../../../common/constant/app_imports.dart';
import '../../../services/storage_services.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.splashBackground),
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
                      horizontal: screenWidth * 0.06,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: screenHeight * 0.02),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(isTablet ? 32 : 24),
                              child: Image.asset(
                                ImageConstant.appLogo,
                                height: isTablet ? 180 : 250,
                                width: isTablet ? 180 : 300,
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

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                          child: Image.asset(
                            ImageConstant.splash,
                            height: screenHeight * (isTablet ? 0.25 : 0.2),
                            fit: BoxFit.contain,
                          ),
                        ),

                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: isTablet ? 54 : 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  final token = StorageService.to.getToken();

                                  if (token != null && token.isNotEmpty) {
                                    Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
                                  } else {
                                    Get.offAllNamed(Routes.ONBOARDING);
                                  }
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


}