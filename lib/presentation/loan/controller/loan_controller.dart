import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pendings/firebase/firebase_db.dart';
import 'package:pendings/firebase/shop/index.dart';
import 'package:pendings/presentation/loan/model/loan_model.dart';
import 'package:pendings/presentation/loan/model/paid_model.dart';
import 'package:pendings/presentation/shop/controller/shop_controller.dart';

class LoanController extends GetxController {
  final LocalAuthentication localAuth = LocalAuthentication();
  final Rx<LoanModel?> localLoan = Rx<LoanModel?>(null);
  final RxBool isLoading = RxBool(false);
  final Rx<LoanModel?> loan = Rx<LoanModel?>(null);
  final RxList<PaidModel> paidList = RxList<PaidModel>();

  final RxString balanceAmount = "".obs;
  final RxString goodOrAmount = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadPaid({
    required String shopId,
    required String loadId,
  }) async {
    try {
      ShopDB.getPaid(shopId, loadId).listen(
        (event) {
          paidList.assignAll(event);
        },
      );
    } catch (e) {
      log("$e");
    }
  }

  Future<void> _openSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.security);
  }

  Future<bool> authenticateUser() async {
    try {
      // final didAuthenticate = await localAuth.authenticate(
      //   localizedReason: 'Please authenticate to access the app',
      //   biometricOnly: false,
      // );
      return true;
    } on PlatformException catch (e) {
      if (e.code == 'noCredentialsSet') {
        Get.snackbar(
          'Biometric Setup Required',
          'Please set up fingerprint or face unlock in your device settings.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          onTap: (snack) async {
            await _openSettings();
          },
        );
      } else {
        debugPrint("Authentication error: $e");
      }
      return false;
    } catch (e) {
      if (e.toString().contains('noCredentialsSet')) {
        Get.snackbar(
          'Biometric Setup Required',
          'Please set up fingerprint or face unlock in your device settings.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          onTap: (snack) async {
            await _openSettings();
          },
        );
      } else {
        debugPrint("Unexpected error: $e");
      }
      return false;
    }
  }

  Future<void> addLocalLoan(LoanModel loan) async {
    localLoan(loan);
  }

  Future<void> createLoan(String shopId) async {
    try {
      isLoading(true);
      if (localLoan.value != null) {
        await ShopDB.addLoan(localLoan.value as LoanModel, shopId);
      }
      Get.back();
      Get.back();
      return;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getLoanDetails(String loanId, String shopId) async {
    try {
      isLoading(true);
      final loanDoc = await db
          .collection("shop")
          .doc(shopId)
          .collection("loans")
          .where("id", isEqualTo: loanId)
          .limit(1)
          .get();

      if (loanDoc.docs.isNotEmpty) {
        loan(LoanModel.fromMap(loanDoc.docs.first.data()));
      }
    } catch (e) {
      print("Error loading loan details: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> payLoad(String shopId, String loanId, PaidModel paid) async {
    try {
      db
          .collection("shop")
          .doc(shopId)
          .collection("loans")
          .doc(loanId)
          .collection("paid")
          .add(paid.toMap());
    } catch (e) {
      debugPrint("$e dfwwdwdwdw");
    }
  }

  Future<void> updatePendingAmount(
    String shopId,
    String loanId,
    double pendingAmount,
  ) async {
    try {
      debugPrint(
        "Updating loan pending amount: shopId=$shopId, loanId=$loanId, pendingAmount=$pendingAmount",
      );
      final loanQuery = await db
          .collection(
            "shop",
          )
          .doc(shopId)
          .collection("loans")
          .where("id", isEqualTo: loanId)
          .limit(1)
          .get();
      if (loanQuery.docs.isNotEmpty) {
        await loanQuery.docs.first.reference.update(
          {"loanPendingAmount": pendingAmount},
        );
      }
      debugPrint("Loan pending amount updated successfully");
    } catch (e) {
      debugPrint("Error updating loan pending amount: $e");
    }
  }

  Future<void> create() async {
    final shopcontroller = Get.find<ShopController>();

    if (localLoan.value != null) {
      createLoan(
        shopcontroller.shop.value!.id,
      );
    }
  }
}
