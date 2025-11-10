import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/theme/app_theme.dart';
import 'package:pendings/core/widgets/E_blackButtons/black_button.dart';

class AddStaffsPage extends StatelessWidget {
  const AddStaffsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          "Add staffs",
          style: TextStyle(fontSize: 22.sp),
        ),
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              AppAssets.search,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Member on pendings",
                      style: TextStyle(
                        color: Color.fromRGBO(83, 80, 80, 0.75),
                        fontSize: 14.sp,
                      ),
                    ),
                    StaffWidget(),
                    StaffWidget(),
                    StaffWidget(),
                    StaffWidget(),
                  ],
                ),
              ),
            ),
            BlackButton(
              btnColor: Color.fromRGBO(0, 0, 0, 1),
              onTap: () {},
              textWidget: Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
              btnRadius: 34,
              height: 50,
              border: BorderSide(),
            ),
          ],
        ),
      ),
    );
  }
}

class StaffWidget extends StatelessWidget {
  const StaffWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(223, 222, 222, 1),
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 14.w,
        children: [
          SvgPicture.asset(
            AppAssets.userIconSvg,
            width: 40.w,
          ),
          Text(
            "Username",
            style: AppTheme.albertFont(
              TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
