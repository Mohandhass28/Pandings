import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pendings/controller/auth_controller.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/presentation/auth/widgets/login_continue_btn/login_continue_btn.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Pendings",
                  style: TextStyle(
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "Create your account and manage\nyour business",
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 35.h,
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await controller.loginWithGoogle();
                    if (result != null) {
                      Get.offAllNamed(RouterName.ROOT);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(55, 52, 52, 0.22),
                      ),
                      borderRadius: BorderRadius.circular(34.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 25.w,
                      children: [
                        SvgPicture.asset(AppAssets.googleSvg),
                        Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Or",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Color.fromRGBO(157, 157, 157, 1),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter email address",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(157, 157, 157, 1),
                      fontSize: 14.sp,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(55, 52, 52, 0.22),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(55, 52, 52, 0.22),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(55, 52, 52, 0.22),
                      ),

                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(157, 157, 157, 1),
                      fontSize: 14.sp,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(55, 52, 52, 0.22),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(55, 52, 52, 0.22),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(55, 52, 52, 0.22),
                      ),

                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 35.h,
                ),
                LoginContinueBtn(
                  onTap: () async {
                    final result = await controller
                        .createAccountEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                    if (result != null) {
                      Get.offAllNamed(RouterName.ROOT);
                    }
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By continuing you agree to our ",
                        style: TextStyle(
                          color: Color.fromRGBO(157, 157, 157, 1),
                          fontSize: 12.sp,
                        ),
                      ),
                      TextSpan(
                        text: "Teems ",
                        style: TextStyle(
                          color: Color.fromRGBO(157, 157, 157, 1),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          decorationThickness: 3,
                          decorationColor: Color.fromRGBO(157, 157, 157, 1),
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 12.sp,
                        ),
                      ),
                      TextSpan(
                        text: "and ",
                        style: TextStyle(
                          color: Color.fromRGBO(157, 157, 157, 1),
                          fontSize: 12.sp,
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          color: Color.fromRGBO(157, 157, 157, 1),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          decorationThickness: 3,
                          decorationColor: Color.fromRGBO(157, 157, 157, 1),
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Color.fromRGBO(157, 157, 157, 1),
                          fontSize: 12.sp,
                        ),
                      ),
                      TextSpan(
                        text: "Sign up",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.offAllNamed(RouterName.LOGIN);
                          },
                        style: TextStyle(
                          color: Color.fromRGBO(157, 157, 157, 1),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          decorationThickness: 3,
                          decorationColor: Color.fromRGBO(157, 157, 157, 1),
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
