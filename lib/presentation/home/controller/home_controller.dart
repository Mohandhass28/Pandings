import 'package:get/get.dart';
import 'package:pendings/controller/auth_controller.dart';
import 'package:pendings/presentation/home/model/shop_model.dart';

class HomeController extends GetxController {
  final RxList<ShopModel> shopList = RxList<ShopModel>();

  @override
  void onInit() {
    super.onInit();
    final AuthController auth = Get.find();
    List.generate(
      10,
      (index) {
        shopList.add(
          ShopModel(
            shopDesDescription: "testDes$index",
            shopName: "M shop$index",
            userIcon: auth.user?.photoURL,
          ),
        );
      },
    );
  }
}
