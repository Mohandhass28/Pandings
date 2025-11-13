import 'package:get/get.dart';
import 'package:pendings/firebase/firebase_db.dart';
import 'package:pendings/firebase/shop/index.dart';
import 'package:pendings/presentation/auth/model/user_model.dart';
import 'package:pendings/presentation/staffs/model/staff_model.dart';

class StaffsController extends GetxController {
  final RxList<UserModel> allUserList = RxList<UserModel>();
  final RxList<UserModel> addUserList = RxList<UserModel>();
  final RxList<StaffModel> shopStaffs = RxList<StaffModel>();

  @override
  void onInit() {
    super.onInit();
    final user = ShopDB.streamUsers();

    user.listen(
      (event) {
        allUserList.assignAll(event);
      },
    );
  }

  void addStaffToLocalList(UserModel staff) {
    addUserList.add(staff);
  }

  void removeStaffToLocalList(UserModel staff) {
    addUserList.assignAll(
      addUserList
          .where(
            (value) => value.id != staff.id,
          )
          .toList(),
    );
  }

  Future<void> getShopStaffs(String shopId) async {
    final staffStream = await ShopDB.streamStaffs(shopId);
    staffStream.listen(
      (event) => shopStaffs(event),
    );
  }
}
