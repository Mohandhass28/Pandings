import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/theme/app_theme.dart';
import 'package:pendings/presentation/loan/controller/loan_controller.dart';
import 'package:pendings/presentation/loan/model/loan_model.dart';
import 'package:pendings/presentation/loan/model/paid_model.dart';

class LoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoanController());
  }
}

class LoanDetailsPage extends StatefulWidget {
  const LoanDetailsPage({super.key});

  @override
  State<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage>
    with SingleTickerProviderStateMixin {
  LoanModel? loan;
  late final LoanController loanController;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final loanArg = Get.arguments?["loan"] as LoanModel?;
    loanController = Get.find<LoanController>();
    if (loanArg != null && loanController != null) {
      loan = loanArg;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loanController.loan(loanArg);
        loanController.loadPaid(loadId: loanArg.id, shopId: loanArg.shopId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentLoan = loanController.loan.value;
      if (loanController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (currentLoan == null) {
        return Scaffold(
          body: Center(
            child: Text("Loan Not Found"),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                currentLoan.partyName,
                style: TextStyle(fontSize: 22.sp),
              ),
              Text(
                "Total amount: ₹${currentLoan.loanTotalAmount}",
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Created by: ${currentLoan.byUserName}",
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    currentLoan.narration,
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
                    "₹${_calculatePendingAmount(currentLoan.loanTotalAmount)}",
                    style: TextStyle(fontSize: 36.sp),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Text(
                    "Credit",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    "Debit",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: ListView(
                      children: [
                        ..._getPaidListCredit(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: ListView(
                      children: [
                        ..._getPaidListDebit(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(
                    RouterName.PAY_LOAN,
                    arguments: {
                      "loan": loan,
                    },
                  );
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
                  "Pay Pending",
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
    });
  }

  List<Widget> _getPaidListCredit() {
    final loanController = Get.find<LoanController>();

    return loanController.paidList
        .where(
          (item) => item.paidType == PaidType.credit,
        )
        .map(
          (e) => _paidWidget(e),
        )
        .toList();
  }

  List<Widget> _getPaidListDebit() {
    final loanController = Get.find<LoanController>();

    return loanController.paidList
        .where(
          (item) => item.paidType == PaidType.debit,
        )
        .map(
          (e) => _paidWidget(e),
        )
        .toList();
  }

  Widget _paidWidget(PaidModel paid) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
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
                "₹${paid.amount}",
                style: TextStyle(fontSize: 20.sp),
              ),
              Text(
                paid.paymentType.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color.fromRGBO(0, 0, 0, 0.52),
                ),
              ),
            ],
          ),
          Text(
            "${paid.paidAt.toDate().day}-${paid.paidAt.toDate().month}-${paid.paidAt.toDate().year}/${paid.paidAt.toDate().hour}:${paid.paidAt.toDate().minute}",
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  double _calculatePendingAmount(double loanTotalAmount) {
    final loanController = Get.find<LoanController>();
    return loanTotalAmount -
        loanController.paidList
            .where(
              (paid) => paid.paidType != PaidType.debit,
            )
            .map(
              (element) => element.amount,
            )
            .fold(
              0,
              (previousValue, element) => previousValue + element,
            );
  }
}
