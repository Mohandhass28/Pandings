import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlackButton extends StatefulWidget {
  const BlackButton({
    super.key,
    required this.onTap,
    required this.textWidget,
    required this.height,
    this.btnColor,
    required this.btnRadius,
    this.border,
  });
  const BlackButton.blackBtn({
    Key? key,
    required Function() onTap,
    required Widget textWidget,
    Color? btnColor,
    double? btnRadius,
    BorderSide? border,
  }) : this(
         key: key,
         onTap: onTap,
         textWidget: textWidget,
         height: 50,
         btnColor: btnColor,
         btnRadius: btnRadius ?? 12,
         border: border,
       );

  final Function() onTap;
  final Widget textWidget;
  final double height;
  final Color? btnColor;
  final double btnRadius;
  final BorderSide? border;

  @override
  State<BlackButton> createState() => _BlackButtonState();
}

class _BlackButtonState extends State<BlackButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          widget.btnColor,
        ),
        overlayColor: WidgetStatePropertyAll(Colors.black.withOpacity(.3)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: widget.border ?? BorderSide(),
            borderRadius: BorderRadiusGeometry.circular(widget.btnRadius.r),
          ),
        ),
        minimumSize: WidgetStatePropertyAll(
          Size(MediaQuery.of(context).size.width, widget.height.h),
        ),
      ),
      child: widget.textWidget,
    );
  }
}
