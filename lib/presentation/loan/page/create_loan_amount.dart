import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pendings/presentation/loan/controller/loan_controller.dart';

class CreateLoanAmount extends StatelessWidget {
  CreateLoanAmount({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loanController = Get.put(LoanController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Loan",
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
                  "Loan Amount",
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
                if (isAuthenticated) {}
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
}
