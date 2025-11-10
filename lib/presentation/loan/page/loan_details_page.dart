import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/theme/app_theme.dart';

class LoanDetailsPage extends StatelessWidget {
  const LoanDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(fontSize: 22.sp),
            ),
            Text(
              "Total amount: 2000000",
              style: TextStyle(fontSize: 12.sp),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    SvgPicture.asset(
                      AppAssets.userIconSvg,
                      width: 70.w,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Name has to pay amount",
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                      "description",
                      style: AppTheme.albertFont(
                        TextStyle(
                          fontSize: 18.sp,
                          color: const Color.fromRGBO(0, 0, 0, .5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      spacing: 14.w,
                      children: [
                        SvgPicture.asset(
                          AppAssets.wallet,
                          width: 30.w,
                          height: 30.h,
                        ),
                        Text(
                          "Pending Amount",
                          style: TextStyle(
                            fontSize: 24.sp,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "₹10000.00",
                      style: TextStyle(fontSize: 36.sp),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      "paid",
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _paidWidget(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(RouterName.PAY_LOAN);
              },
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll(
                  Size(MediaQuery.of(context).size.width, 50.h),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(24.r),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromRGBO(116, 73, 197, 1),
                ),
              ),
              child: Text(
                "Pay Pendaing",
                style: TextStyle(fontSize: 22.sp, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Widget _paidWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(228, 215, 255, 1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "₹1000",
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "description",
                style: AppTheme.albertFont(
                  TextStyle(
                    fontSize: 14.sp,
                    color: const Color.fromRGBO(0, 0, 0, .5),
                  ),
                ),
              ),
            ],
          ),
          Text(
            "12-11-2026/11:20",
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
