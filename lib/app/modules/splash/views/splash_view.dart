import '../../../common/constant/app_imports.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Obx(() => Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.appBackground,
          image: DecorationImage(
            image: const AssetImage(ImageConstant.splashBackground),
            fit: BoxFit.cover,
            opacity: ThemeService.to.isDarkMode ? 0.10 : 0.9,
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
                            SizedBox(height: screenHeight * 0.03),

                            Container(
                              height: isTablet ? 110 : 90,
                              width: isTablet ? 110 : 90,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightShadow,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                ImageConstant.appLogoFull,
                                fit: BoxFit.contain,
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.025),

                            Text(
                              AppStrings.expertAcademicSupport,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppStrings.whenYouNeedItMost,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPurple,
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                              child: Text(
                                AppStrings.splashSubtext,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
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
                            Obx(() {
                              if (controller.isLoading.value) {
                                return SizedBox(
                                  height: isTablet ? 54 : 48,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryPurple,
                                    ),
                                  ),
                                );
                              }

                              if (controller.hasToken.value) {
                                return const SizedBox.shrink();
                              }

                              return SizedBox(
                                width: double.infinity,
                                height: isTablet ? 54 : 48,
                                child: InkWell(
                                  onTap: () {
                                    Get.offAllNamed(Routes.ONBOARDING);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: AppColors.buttonPrimary,
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppStrings.getStarted,
                                          style: TextStyle(
                                            fontSize: isTablet ? 18 : 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: isTablet ? 24 : 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                            SizedBox(height: screenHeight * 0.02),

                            Text(
                              AppStrings.trustedByStudents,
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.lightTextSecondary,
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
    ));
  }
}