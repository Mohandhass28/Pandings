import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pendings/controller/auth_controller.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/firebase/firebase_db.dart';
import 'package:pendings/firebase/shop/index.dart';
import 'package:pendings/presentation/auth/model/user_model.dart';
import 'package:pendings/presentation/home/model/shop_model.dart';
import 'package:pendings/presentation/loan/model/loan_model.dart';
import 'package:pendings/presentation/staffs/model/staff_model.dart';
import 'package:uuid/uuid.dart';

class ShopController extends GetxController {
  final RxList<ShopModel> shopList = RxList<ShopModel>();
  final Rx<ShopModel?> shop = Rx<ShopModel?>(null);
  final RxBool isLoading = RxBool(false);
  final RxList<LoanModel> loanList = RxList<LoanModel>();

  @override
  void onInit() {
    super.onInit();
    final auth = Get.find<AuthController>();
    if (auth.user != null) {
      final shop = ShopDB.streamShops(auth.user!.uid);

      shop.listen(
        (event) async {
          for (var shop in event) {
            if (shop.ownerId == auth.user!.uid &&
                !shopList
                    .map(
                      (element) => element.id,
                    )
                    .toList()
                    .contains(shop.id)) {
              shopList.add(shop);
            }
            final shopStaff = await ShopDB.streamStaffs(shop.id);
            shopStaff.listen(
              (staffList) {
                bool isStaff = staffList.any(
                  (staff) => staff.id == auth.user!.uid,
                );
                if (isStaff) {
                  if (!shopList
                      .map(
                        (element) => element.id,
                      )
                      .toList()
                      .contains(shop.id)) {
                    shopList.add(shop);
                  }
                } else {
                  if (shop.ownerId != auth.user!.uid) {
                    shopList.removeWhere((s) => s.id == shop.id);
                  }
                }
              },
            );
          }
        },
      );
    }
  }

  Future<void> loadLoand(String shopId) async {
    try {
      final loans = ShopDB.getLoans(shopId);
      loans.listen(
        (event) {
          loanList(event);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> createShop(
    ShopModel shop,
  ) async {
    try {
      return await ShopDB.addShop(shop);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addStaffsToShop(
    List<UserModel> staffList,
    String shopId,
  ) async {
    try {
      for (var user in staffList) {
        final newStaff = StaffModel(
          id: user.id,
          name: user.name,
          role: "staff",
        );
        await ShopDB.addStaffs(shopId, newStaff);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadShop(String shopId) async {
    try {
      isLoading(true);
      final shopvalue = await db
          .collection("shop")
          .where("id", isEqualTo: shopId)
          .limit(1)
          .get();
      if (shopvalue.docs.isNotEmpty) {
        shop(ShopModel.fromMap(shopvalue.docs.first.data()));
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
