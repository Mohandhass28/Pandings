import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pendings/controller/auth_controller.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/widgets/E_blackButtons/black_button.dart';
import 'package:pendings/core/widgets/textFieldWidget/text_field_widget.dart';
import 'package:pendings/presentation/loan/controller/loan_controller.dart';
import 'package:pendings/presentation/loan/model/loan_model.dart';
import 'package:pendings/presentation/shop/controller/shop_controller.dart';
import 'package:uuid/uuid.dart';

class CreateLoanPage extends StatelessWidget {
  CreateLoanPage({super.key});

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loanController = Get.put(LoanController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "create loan",
          style: TextStyle(fontSize: 22.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.h),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Name",
                    hitText: "Enter name",
                    textController: _nameController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Loan Description",
                    hitText: "Enter Loan de`scription",
                    textController: _descriptionController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // BlackButton(
                  //   onTap: () {},
                  //   textWidget: Text(
                  //     "Add Loan Profile",
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 20.sp,
                  //     ),
                  //   ),
                  //   btnRadius: 12.r,
                  //   height: 50.h,
                  //   border: BorderSide(),
                  // ),
                ],
              ),
            ),
            BlackButton(
              btnColor: Color.fromRGBO(0, 0, 0, 1),
              onTap: () {
                final auth = Get.find<AuthController>();
                final shop = Get.find<ShopController>();
                try {
                  if (auth.user != null &&
                      auth.user?.displayName != null &&
                      shop.shop.value?.id != null) {
                    final loan = LoanModel(
                      id: Uuid().v4(),
                      shopId: shop.shop.value!.id,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      byUserName: auth.user?.displayName as String,
                      loanTotalAmount: 0,
                      loanPendingAmount: 0,
                      createAt: Timestamp.now(),
                    );
                    loanController.addLocalLoan(loan);
                    Get.toNamed(RouterName.CREATELOANAMOUNT);
                  }
                } catch (e) {
                  Get.snackbar(
                    "User name required",
                    "$e",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                  );
                }
              },
              textWidget: Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
              btnRadius: 34,
              height: 50,
              border: BorderSide(),
            ),

            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
