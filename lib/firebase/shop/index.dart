import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pendings/firebase/firebase_db.dart';
import 'package:pendings/presentation/auth/model/user_model.dart';
import 'package:pendings/presentation/home/model/shop_model.dart';
import 'package:pendings/presentation/loan/model/loan_model.dart';
import 'package:pendings/presentation/loan/model/paid_model.dart';
import 'package:pendings/presentation/staffs/model/staff_model.dart';

class ShopDB {
  static Stream<List<ShopModel>> streamShops(String userId) {
    return db.collection('shop').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ShopModel.fromMap(doc.data())).toList();
    });
  }

  static Stream<List<UserModel>> streamUsers() {
    return db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => UserModel.fromMap(doc.data()),
          )
          .toList();
    });
  }

  static Future<DocumentReference<Map<String, dynamic>>> addShop(
    ShopModel shop,
  ) async {
    return await db.collection('shop').add(shop.toMap());
  }

  static Future<Stream<List<StaffModel>>> streamStaffs(String shopId) async {
    final dbshop = await db
        .collection("shop")
        .where("id", isEqualTo: shopId)
        .limit(1)
        .get();

    return db
        .collection('shop')
        .doc(dbshop.docs.first.id)
        .collection('staffs')
        .snapshots()
        .map((
          snapshot,
        ) {
          return snapshot.docs
              .map((doc) => StaffModel.fromMap(doc.data()))
              .toList();
        });
  }

  static Future addStaffs(String shopId, StaffModel staff) async {
    return await db
        .collection('shop')
        .doc(shopId)
        .collection("staffs")
        .add(staff.toMap());
  }

  static Future<void> addLoan(LoanModel loan, String shopId) async {
    await db
        .collection("shop")
        .doc(shopId)
        .collection("loans")
        .add(loan.toMap());
  }

  static Stream<List<LoanModel>> getLoans(String shopId) {
    return db
        .collection('shop')
        .doc(shopId)
        .collection("loans")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (e) => LoanModel.fromMap(e.data()),
              )
              .toList();
        });
  }

  static Stream<List<PaidModel>> getPaid(String shopId, String loadId) {
    return db
        .collection('shop')
        .doc(shopId)
        .collection("loans")
        .doc(loadId)
        .collection("paid")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (e) => PaidModel.fromMap(e.data()),
              )
              .toList();
        });
  }

  static Future<void> updateLoanPendingAmount(
    String shopId,
    String loanId,
    double newPendingAmount,
  ) async {
    await db
        .collection('shop')
        .doc(shopId)
        .collection('loans')
        .doc(loanId)
        .update({'loanPendingAmount': newPendingAmount});
  }

  static Future<void> updateShopPendingAmount(
    String shopId,
    double newPendingAmount,
  ) async {
    await db.collection('shop').doc(shopId).update({
      'pendingAmount': newPendingAmount,
    });
  }

  static Future<String> getShopDocId(
    String shopId,
  ) async {
    final shop = await db
        .collection("shop")
        .where("id", isEqualTo: shopId)
        .limit(1)
        .get();

    return shop.docs.first.id;
  }
}
