import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pendings/controller/auth_controller.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/theme/app_theme.dart';
import 'package:pendings/presentation/home/controller/home_controller.dart';
import 'package:pendings/presentation/home/model/shop_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final HomeController shopController = Get.put(HomeController());

    return Obx(() {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(),
        appBar: _getAppBar(),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Builder(
            builder: (context) {
              if (shopController.shopList.isEmpty) {
                return _emptyShopWidget();
              }
              return _shopList();
            },
          ),
        ),
        floatingActionButton: shopController.shopList.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  Get.toNamed(RouterName.CREATE_SHOP);
                },
                backgroundColor: Color.fromRGBO(228, 215, 255, 1),
                child: Icon(Icons.add),
              )
            : null,
      );
    });
  }

  PreferredSizeWidget _getAppBar() {
    final AuthController auth = Get.find();

    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: 30.w,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsetsGeometry.only(left: 10),
          ),
        ),
        icon: SvgPicture.asset(
          AppAssets.menuSvg,
          width: 20.w,
          height: 20.h,
        ),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Text(
        "Pendings",
        style: TextStyle(fontSize: 22.sp),
      ),
      actionsPadding: EdgeInsets.only(bottom: 4.h),
      actions: [
        IconButton(
          padding: EdgeInsets.all(0),
          icon: SvgPicture.asset(
            AppAssets.search,
            width: 40.w,
            height: 40.h,
          ),
          onPressed: () {},
        ),

        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          icon: auth.user?.photoURL != null
              ? ClipOval(
                  child: Image.network(
                    auth.user?.photoURL as String,
                    width: 40.w,
                    height: 40.h,
                  ),
                )
              : SvgPicture.asset(
                  AppAssets.userIconSvg,
                  width: 40.w,
                  height: 40.h,
                ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _emptyShopWidget() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.empty),
          SizedBox(
            height: 20.h,
          ),
          Text(
            "No Shops",
            style: TextStyle(
              fontSize: 22.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15.h,
          ),
          Text(
            "You have no shop available yet. Be the first\nto create a shop",
            style: TextStyle(
              fontSize: 12.sp,
              color: Color.fromRGBO(153, 145, 145, 0.78),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(RouterName.CREATE_SHOP);
            },
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(context).size.width, 55.h),
              ),
              backgroundColor: WidgetStatePropertyAll(
                Colors.white,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  side: BorderSide(),
                  borderRadius: BorderRadiusGeometry.circular(12.r),
                ),
              ),
            ),
            child: Text(
              "Create shop",
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shopList() {
    final HomeController shopController = Get.find();
    return ListView.builder(
      itemCount: shopController.shopList.length,
      itemBuilder: (context, index) {
        return ShopItem(
          key: ObjectKey(shopController.shopList[index]),
          shop: shopController.shopList[index],
        );
      },
    );
  }
}

class ShopItem extends StatelessWidget {
  const ShopItem({super.key, required this.shop});

  final ShopModel shop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouterName.SHOP);
      },
      child: Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Color.fromRGBO(228, 215, 255, 1),
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  shop.shopName,
                  style: TextStyle(fontSize: 20.sp),
                ),
                Text(
                  shop.shopDesDescription,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color.fromRGBO(0, 0, 0, .5),
                  ),
                ),
              ],
            ),
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Color.fromRGBO(228, 215, 255, 1),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Center(
                child: Text(
                  shop.shopName.split("").first,
                  style: AppTheme.albertFont(
                    TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(78, 39, 153, 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
