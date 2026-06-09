import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constant/image_constant.dart';
import '../../../common/widget/button/custom_app_button.dart';
import '../../../common/widget/button/social_button.dart';
import '../../../common/widget/text_field/custom_text_field.dart';
import '../../../routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

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
                  ImageConstant.signupBackground,
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
                    child: Image.asset(ImageConstant.appLogo),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 55),

            const Text(
              "Create A New Account",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  TextFieldCustom(hintText: "Enter Name",labelText: "Name",),
                  SizedBox(height: 12),
                  TextFieldCustom(
                      labelText: "Email or Phone",
                      hintText: "Enter Email or Phone"),
                  SizedBox(height: 12),
                  TextFieldCustom(
                    hintText: "Enter Password",
                    labelText: "Password",
                  ),
                  SizedBox(height: 12),
                  TextFieldCustom(hintText: "Enter Country",labelText: "Country",),
                  SizedBox(height: 12),
                  AppButton(title: "SIGN UP", onTap: () {}),

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

                  const SizedBox(height: 15),

                  Text(
                    "By clicking Sign Up I have read and agree\nwith Terms Sheet & Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have An Account ? "),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.LOGIN);
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
