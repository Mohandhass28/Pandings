import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginContinueBtn extends StatefulWidget {
  const LoginContinueBtn({super.key, required this.onTap});

  final Function() onTap;

  @override
  State<LoginContinueBtn> createState() => _LoginContinueBtnState();
}

class _LoginContinueBtnState extends State<LoginContinueBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Color.fromRGBO(0, 0, 0, 1),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadiusGeometry.circular(34.r),
          ),
        ),
        minimumSize: WidgetStatePropertyAll(
          Size(MediaQuery.of(context).size.width, 50.h),
        ),
      ),
      child: Text(
        "Continue",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
    );
  }
}
