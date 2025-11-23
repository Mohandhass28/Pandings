import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pendings/core/theme/app_color.dart';
import 'package:pendings/presentation/auth/controller/auth_controller.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/widgets/E_blackButtons/black_button.dart';
import 'package:pendings/core/widgets/textFieldWidget/text_field_widget.dart';
import 'package:pendings/presentation/loan/controller/loan_controller.dart';
import 'package:pendings/presentation/loan/model/loan_model.dart';
import 'package:pendings/presentation/loan/model/paid_model.dart';
import 'package:pendings/presentation/shop/controller/shop_controller.dart';
import 'package:uuid/uuid.dart';

class CreateLoanPage extends StatelessWidget {
  const CreateLoanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loanController = Get.put(LoanController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "create Transitions",
            style: TextStyle(fontSize: 22.sp),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Goods",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Cash",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GoodsWidget(),
            CashWiget(),
          ],
        ),
      ),
    );
  }
}

class GoodsWidget extends StatelessWidget {
  GoodsWidget({super.key});
  final _partyNameController = TextEditingController();
  final _areaNameController = TextEditingController();
  final _goodsDateController = TextEditingController();
  final _closingController = TextEditingController();
  final _narrationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loanController = Get.find<LoanController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Party Name",
                    hitText: "Enter Party Name",
                    textController: _partyNameController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Area Name",
                    hitText: "Enter Area Name",
                    textController: _areaNameController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Goods Date",
                    hitText: "Enter Goods Date",
                    textController: _goodsDateController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Closing",
                    hitText: "Enter Closing",
                    textController: _closingController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Narration",
                    hitText: "Enter Narration",
                    textController: _narrationController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(() {
                    return BlackButton.blackBtn(
                      onTap: () {
                        Get.toNamed(
                          RouterName.CREATELOANAMOUNT,
                          arguments: {"type": "amount"},
                        );
                      },
                      btnColor: loanController.goodOrAmount.isEmpty
                          ? Colors.white
                          : AppColor.primaryColor,
                      border: loanController.goodOrAmount.isEmpty
                          ? BorderSide()
                          : BorderSide(color: AppColor.secoundaryColor),
                      textWidget: loanController.goodOrAmount.isEmpty
                          ? Text(
                              "Goods Amount",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              "Goods Amount: ${loanController.goodOrAmount}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColor.secoundaryColor,
                              ),
                            ),
                    );
                  }),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(() {
                    return BlackButton.blackBtn(
                      onTap: () {
                        Get.toNamed(
                          RouterName.CREATELOANAMOUNT,
                          arguments: {"type": "balance"},
                        );
                      },
                      btnColor: loanController.balanceAmount.isEmpty
                          ? Colors.white
                          : AppColor.primaryColor,
                      border: loanController.balanceAmount.isEmpty
                          ? BorderSide(color: Colors.black)
                          : BorderSide(color: AppColor.secoundaryColor),
                      textWidget: loanController.balanceAmount.isEmpty
                          ? Text(
                              "Balance Amount",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              "Balance Amount: ${loanController.balanceAmount}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColor.secoundaryColor,
                              ),
                            ),
                    );
                  }),
                ],
              ),
            ),
          ),
          BlackButton(
            btnColor: Color.fromRGBO(0, 0, 0, 1),
            onTap: () async {
              final auth = Get.find<AuthController>();
              final shop = Get.find<ShopController>();
              try {
                if (auth.user != null &&
                    auth.user?.displayName != null &&
                    shop.shop.value?.id != null) {
                  if (loanController.balanceAmount.isNotEmpty ||
                      loanController.goodOrAmount.isNotEmpty) {
                    final loan = LoanModel(
                      id: Uuid().v4(),
                      shopId: shop.shop.value!.id,
                      partyName: _partyNameController.text,
                      closing: _closingController.text,
                      narration: _narrationController.text,
                      date: DateTime.now(),
                      areaName: _areaNameController.text,
                      byUserName: auth.user?.displayName as String,
                      loanTotalAmount:
                          double.tryParse(loanController.goodOrAmount.value) ??
                          0.0,
                      loanPendingAmount:
                          double.tryParse(loanController.balanceAmount.value) ??
                          0.0,
                      createAt: Timestamp.now(),
                      type: TransitionsType.goods,
                    );
                    await loanController.addLocalLoan(loan);
                    await loanController.create();
                    Get.toNamed(RouterName.SHOP);
                  }
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

          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}

class CashWiget extends StatelessWidget {
  CashWiget({super.key});
  final _partyNameController = TextEditingController();
  final _areaNameController = TextEditingController();
  final _closingController = TextEditingController();
  final _narrationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loanController = Get.find<LoanController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Party Name",
                    hitText: "Enter Party Name",
                    textController: _partyNameController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Area Name",
                    hitText: "Enter Area Name",
                    textController: _areaNameController,
                  ),

                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Closing",
                    hitText: "Enter Closing",
                    textController: _closingController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    title: "Narration",
                    hitText: "Enter Narration",
                    textController: _narrationController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(() {
                    return BlackButton.blackBtn(
                      onTap: () {
                        Get.toNamed(
                          RouterName.CREATELOANAMOUNT,
                          arguments: {"type": "amount"},
                        );
                      },
                      border: loanController.goodOrAmount.isEmpty
                          ? BorderSide()
                          : BorderSide(
                              color: AppColor.secoundaryColor,
                            ),
                      btnColor: loanController.goodOrAmount.isEmpty
                          ? Colors.white
                          : AppColor.primaryColor,
                      textWidget: loanController.goodOrAmount.isEmpty
                          ? Text(
                              "Amount",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              "Amount: ${loanController.goodOrAmount}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColor.secoundaryColor,
                              ),
                            ),
                    );
                  }),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(() {
                    return BlackButton.blackBtn(
                      onTap: () {
                        Get.toNamed(
                          RouterName.CREATELOANAMOUNT,
                          arguments: {"type": "balance"},
                        );
                      },
                      border: loanController.balanceAmount.isEmpty
                          ? BorderSide()
                          : BorderSide(
                              color: AppColor.secoundaryColor,
                            ),
                      btnColor: loanController.balanceAmount.isEmpty
                          ? Colors.white
                          : AppColor.primaryColor,
                      textWidget: loanController.balanceAmount.isEmpty
                          ? Text(
                              "Balance Amount",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              "Balance Amount: ${loanController.balanceAmount}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColor.secoundaryColor,
                              ),
                            ),
                    );
                  }),
                ],
              ),
            ),
          ),
          BlackButton(
            btnColor: Color.fromRGBO(0, 0, 0, 1),
            onTap: () async {
              final auth = Get.find<AuthController>();
              final shop = Get.find<ShopController>();
              try {
                if (auth.user != null &&
                    auth.user?.displayName != null &&
                    shop.shop.value?.id != null) {
                  if (loanController.balanceAmount.isNotEmpty ||
                      loanController.goodOrAmount.isNotEmpty) {
                    final loan = LoanModel(
                      id: Uuid().v4(),
                      shopId: shop.shop.value!.id,
                      partyName: _partyNameController.text,
                      closing: _closingController.text,
                      narration: _narrationController.text,
                      date: DateTime.now(),
                      areaName: _areaNameController.text,
                      byUserName: auth.user?.displayName as String,
                      loanTotalAmount:
                          double.tryParse(loanController.goodOrAmount.value) ??
                          0.0,
                      loanPendingAmount:
                          double.tryParse(loanController.balanceAmount.value) ??
                          0.0,
                      createAt: Timestamp.now(),
                      type: TransitionsType.goods,
                    );
                    await loanController.addLocalLoan(loan);
                    await loanController.create();
                    final paidModel = PaidModel(
                      amount: double.parse(loanController.goodOrAmount.value),
                      paidAt: Timestamp.now(),
                      paidType: PaidType.debit,
                      paymentType: PaymentType.cash,
                    );
                    await loanController.payLoad(
                      loan.shopId,
                      loan.id,
                      paidModel,
                    );
                    Get.toNamed(RouterName.SHOP);
                  }
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

          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
