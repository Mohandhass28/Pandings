import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pendings/presentation/auth/controller/auth_controller.dart';
import 'package:pendings/core/theme/app_theme.dart';
import 'package:pendings/core/widgets/E_blackButtons/black_button.dart';
import 'package:pendings/firebase/firebase_db.dart';
import 'package:pendings/firebase/shop/index.dart';
import 'package:pendings/presentation/auth/model/user_model.dart';
import 'package:pendings/presentation/shop/controller/shop_controller.dart';
import 'package:pendings/presentation/staffs/controller/staffs_controller.dart';
import 'package:pendings/presentation/staffs/model/staff_model.dart';

class StaffsShopPage extends StatefulWidget {
  const StaffsShopPage({super.key});

  @override
  State<StaffsShopPage> createState() => _StaffsShopPageState();
}

class _StaffsShopPageState extends State<StaffsShopPage> {
  final StaffsController staffController = Get.put(StaffsController());
  final ShopController shopController = Get.find<ShopController>();
  final AuthController auth = Get.find<AuthController>();

  @override
  void initState() {
    staffController.getShopStaffs(shopController.shop.value!.id);
    super.initState();
  }

  @override
  void dispose() {
    staffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Staffs"),
        surfaceTintColor: Colors.white,
      ),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_getShopStaffs().any(
                        (widget) => widget is ShopStaffWidget,
                      ))
                        Text(
                          "Added Staffs",
                        ),
                      ..._getShopStaffs(),
                      if (_getAllStaffs().any(
                        (widget) => widget is StaffWidget,
                      ))
                        Text(
                          "All Staffs",
                        ),
                      ..._getAllStaffs(),
                    ],
                  ),
                ),
              ),
              BlackButton(
                btnColor: Color.fromRGBO(0, 0, 0, 1),
                onTap: () async {
                  final fireshop = await db
                      .collection("shop")
                      .where("id", isEqualTo: shopController.shop.value!.id)
                      .limit(1)
                      .get();

                  await shopController.addStaffsToShop(
                    staffController.addUserList.toList(),
                    fireshop.docs.first.id,
                  );

                  staffController.addUserList([]);
                },
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
        );
      }),
    );
  }

  List<Widget> _getShopStaffs() {
    return List.generate(
      staffController.shopStaffs.length,
      (index) {
        if (auth.user?.uid != staffController.allUserList[index].id) {
          return ShopStaffWidget(
            key: ValueKey(staffController.shopStaffs[index].id),
            staff: staffController.shopStaffs[index],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  List<Widget> _getAllStaffs() {
    return List.generate(
      staffController.allUserList.length,
      (index) {
        if (!staffController.shopStaffs
                .map(
                  (element) => element.id,
                )
                .toList()
                .contains(
                  staffController.allUserList[index].id,
                ) &&
            auth.user?.uid != staffController.allUserList[index].id) {
          return StaffWidget(
            key: ValueKey(staffController.allUserList[index].id),
            staff: staffController.allUserList[index],
          );
        }
        return SizedBox.shrink();
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

class ShopStaffWidget extends StatelessWidget {
  const ShopStaffWidget({super.key, required this.staff});

  final StaffModel staff;

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
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
              SizedBox(
                width: 14.w,
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
          TextButton(
            onPressed: () async {
              print(staff.id);
              final shopDoc = await db
                  .collection("shop")
                  .where("id", isEqualTo: shopController.shop.value!.id)
                  .limit(1)
                  .get();
              if (shopDoc.docs.isEmpty) return;
              final shopDocumentId = shopDoc.docs.first.id;
              final staffDocId = await db
                  .collection("shop")
                  .doc(shopDocumentId)
                  .collection("staffs")
                  .where("id", isEqualTo: staff.id)
                  .get();
              if (staffDocId.docs.isEmpty) return;
              print(staffDocId.docs.first.id);
              await db
                  .collection("shop")
                  .doc(shopDocumentId)
                  .collection("staffs")
                  .doc(staffDocId.docs.first.id)
                  .delete();
            },
            child: Text(
              "Remove",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
