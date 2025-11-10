import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/widgets/E_blackButtons/black_button.dart';
import 'package:pendings/core/widgets/textFieldWidget/text_field_widget.dart';

class CreateLoanPage extends StatelessWidget {
  CreateLoanPage({super.key});

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                Get.toNamed(RouterName.CREATELOANAMOUNT);
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
