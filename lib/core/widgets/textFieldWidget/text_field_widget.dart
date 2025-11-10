import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.title,
    required this.hitText,
    required this.textController,
  });

  final String title;
  final String hitText;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.h,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        TextField(
          controller: textController,

          decoration: InputDecoration(
            hint: Text(
              hitText,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color.fromRGBO(157, 157, 157, 1),
              ),
            ),
            border: OutlineInputBorder(
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(55, 52, 52, 1),
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
