import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/theme/app_theme.dart';
import 'package:pendings/core/widgets/E_blackButtons/black_button.dart';
import 'package:pendings/presentation/auth/model/user_model.dart';
import 'package:pendings/presentation/staffs/controller/staffs_controller.dart';

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
                    Obx(
                      () {
                        return Column(
                          children: [
                            ..._getStaffs(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlackButton(
              btnColor: Color.fromRGBO(0, 0, 0, 1),
              onTap: () {
                Get.back();
              },
              textWidget: Text(
                "Done",
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

  List<Widget> _getStaffs() {
    final StaffsController staffController = Get.find();
    return List.generate(
      staffController.allUserList.length,
      (index) {
        return StaffWidget(
          key: ValueKey(staffController.allUserList[index].id),
          staff: staffController.allUserList[index],
        );
      },
    );
  }
}

class StaffWidget extends StatelessWidget {
  const StaffWidget({super.key, required this.staff});

  final UserModel staff;

  @override
  Widget build(BuildContext context) {
    final StaffsController staffController = Get.find();

    return GestureDetector(
      onTap: () {
        if (staffController.addUserList
            .map(
              (element) => element.id,
            )
            .contains(staff.id)) {
          staffController.removeStaffToLocalList(staff);
          return;
        }
        staffController.addStaffToLocalList(staff);
      },
      child: Obx(() {
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
              if (staff.photoUrl != null &&
                  !staffController.addUserList
                      .map(
                        (element) => element.id,
                      )
                      .contains(staff.id))
                ClipOval(
                  child: Image.network(
                    staff.photoUrl as String,
                    width: 40.w,
                  ),
                ),
              if (staff.photoUrl == null &&
                  !staffController.addUserList
                      .map(
                        (element) => element.id,
                      )
                      .contains(staff.id))
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(228, 215, 255, 1),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Center(
                    child: Text(
                      staff.name.split("").first,
                      style: AppTheme.albertFont(
                        TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(78, 39, 153, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              if (staffController.addUserList
                  .map(
                    (element) => element.id,
                  )
                  .contains(staff.id))
                AnimatedContainer(
                  duration: Duration(seconds: 2),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(15, 212, 1, 1),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              Text(
                staff.name,
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
      }),
    );
  }
}
