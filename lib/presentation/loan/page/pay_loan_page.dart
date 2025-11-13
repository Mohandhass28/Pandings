import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pendings/presentation/loan/controller/loan_controller.dart';
import 'package:pendings/presentation/loan/model/loan_model.dart';
import 'package:pendings/presentation/loan/model/paid_model.dart';

class PayLoanPage extends StatelessWidget {
  PayLoanPage({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loan = Get.arguments?["loan"] as LoanModel?;
    final loanController = Get.put(LoanController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pay",
          style: TextStyle(fontSize: 22.sp),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${loan?.name} Paid",
                  style: TextStyle(fontSize: 22.sp),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹',
                      style: TextStyle(
                        fontSize: 44.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.0,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 250,
                            minWidth: 20,
                          ),
                          child: TextField(
                            controller: _controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),

                            autofocus: true,
                            textAlign: TextAlign.center,
                            showCursor: true,
                            cursorColor: Colors.deepPurple,
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              height: 1.0,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: '0',
                              hintStyle: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            strutStyle: StrutStyle.disabled,
                            onTap: () {
                              if (_controller.text == '0') _controller.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: ElevatedButton(
              onPressed: () async {
                final isAuthenticated = await loanController.authenticateUser();
                if (isAuthenticated && loan != null) {
                  if (_calculatePendingAmount(loan.loanTotalAmount) -
                          double.parse(_controller.text) <
                      0) {
                    Get.snackbar(
                      "Invalid Amount",
                      "Enter Valid Amount",
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                    return;
                  }
                  final paidModel = PaidModel(
                    amount: double.parse(_controller.text),
                    paidAt: Timestamp.now(),
                  );
                  await loanController.payLoad(loan.shopId, loan.id, paidModel);
                  await loanController.updatePendingAmount(
                    loan.shopId,
                    loan.id,
                    _calculatePendingAmount(loan.loanTotalAmount) -
                        double.parse(_controller.text),
                  );

                  Get.back();
                }
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
                "Pay",
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

  double _calculatePendingAmount(double loanTotalAmount) {
    final loanController = Get.find<LoanController>();
    return loanTotalAmount -
        loanController.paidList
            .map(
              (element) => element.amount,
            )
            .fold(
              0,
              (previousValue, element) => previousValue + element,
            );
  }
}
