import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pendings/controller/auth_controller.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/theme/app_theme.dart';
import 'package:pendings/core/widgets/E_blackButtons/black_button.dart';
import 'package:pendings/core/widgets/textFieldWidget/text_field_widget.dart';
import 'package:pendings/firebase/firebase_db.dart';
import 'package:pendings/presentation/auth/model/user_model.dart';
import 'package:pendings/presentation/home/model/shop_model.dart';
import 'package:pendings/presentation/shop/controller/shop_controller.dart';
import 'package:pendings/presentation/staffs/controller/staffs_controller.dart';
import 'package:uuid/uuid.dart';

class CreateShopPage extends StatelessWidget {
  CreateShopPage({super.key});
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final StaffsController staffController = Get.put(StaffsController());
    final ShopController shopController = Get.put(ShopController());
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          "create shop",
          style: TextStyle(fontSize: 22.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldWidget(
                      title: "Shop Name",
                      hitText: "Enter shop name",
                      textController: _nameController,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldWidget(
                      title: "Shop Description",
                      hitText: "Enter shop description",
                      textController: _descriptionController,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlackButton(
                      btnColor: Color.fromRGBO(0, 0, 0, 1),
                      onTap: () {
                        Get.toNamed(RouterName.ADDSTAFFS);
                      },
                      textWidget: Text(
                        "Add Staffs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                      btnRadius: 14,
                      height: 50,
                      border: BorderSide(),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),

                    Obx(
                      () {
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Staffs",
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                            if (staffController.addUserList.isEmpty)
                              Center(child: Text("No Staffs Added")),

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
              onTap: () async {
                final auth = Get.find<AuthController>();
                final newShop = ShopModel(
                  id: const Uuid().v4(), // Generate unique shop ID
                  ownerId: auth.user!.uid, // Set owner as current user
                  shopName: _nameController.text,
                  shopDesDescription: _descriptionController.text,
                  pendingAmount: 0,
                );
                final createdShop = await shopController.createShop(newShop);
                await shopController.addStaffsToShop(
                  staffController.addUserList.toList(),
                  createdShop.id,
                );
                Get.back();
              },
              textWidget: Text(
                "Create",
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
      staffController.addUserList.length,
      (index) {
        return StaffWidget(
          staff: staffController.addUserList[index],
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
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
          if (staff.photoUrl != null)
            ClipOval(
              child: Image.network(
                staff.photoUrl as String,
                width: 40.w,
              ),
            ),
          if (staff.photoUrl == null)
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
  }
}
