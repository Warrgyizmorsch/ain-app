import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/custom_app_button.dart';
import '../../../common/widget/text_field/custom_text_field.dart';
import '../../../common/widget/button/social_button.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';
class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image.asset(
                  ImageConstant.loginBackground,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  bottom: -35,
                  child: Container(
                    height: 75,
                    width: 75,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      ImageConstant.appLogo,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 55),

            const Text(
              "Welcome Back To Your Account",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                   TextFieldCustom(
                    hintText: "Enter Email or Phone",
                    labelText: "Email or Phone",
                  ),
                  const SizedBox(height: 16),
                   TextFieldCustom(
                    hintText: "Enter Password",
                    labelText: "Password",

                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (v) {},
                      ),
                      const Text(
                        "Remember Me",
                        style: TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forget Password?",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),

                  AppButton(
                    title: "LOGIN",
                    onTap: () {
                      Get.toNamed(Routes.BOTTOM_NAV_BAR);
                    },
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Or"),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialButton(
                        imagePath: ImageConstant.googleIcon,
                        onTap: () {},
                      ),

                      SocialButton(
                        imagePath: ImageConstant.appleIcon,
                        onTap: () {},
                      ),

                      SocialButton(
                        imagePath: ImageConstant.facebookIcon,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have An Account ? "),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.SIGNUP);
                        },
                        child: const Text(
                          "SIGNUP",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}