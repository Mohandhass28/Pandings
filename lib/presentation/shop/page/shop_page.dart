import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/circular_reveal_clipper.dart';
import 'package:pendings/core/theme/app_color.dart';
import 'package:pendings/presentation/auth/controller/auth_controller.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/theme/app_theme.dart';
import 'package:pendings/presentation/loan/model/loan_model.dart';
import 'package:pendings/presentation/shop/controller/shop_controller.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shopController = Get.put(
      ShopController(),
    );
    final shopId = Get.arguments["shopId"];
    if (shopId == null) {
      return Scaffold(
        body: Center(
          child: Text("Shop Id Not Found"),
        ),
      );
    }
    shopController.loadShop(shopId);
    shopController.loadLoand(shopId);

    return Obx(() {
      if (shopController.shop.value == null) {
        return Scaffold(
          body: Center(
            child: Text("Shop Not Found"),
          ),
        );
      }

      if (shopController.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(shopController.shop.value!.shopName),
          actions: [
            _MenuButton(),
          ],
          surfaceTintColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25.h,
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
                      "Total Pending",
                      style: TextStyle(
                        fontSize: 24.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "₹ ${_getTotalPending().toString()}",
                  style: TextStyle(fontSize: 36.sp),
                ),

                SizedBox(
                  height: 40.h,
                ),
                Text(
                  "Transitions",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ..._getListLoan(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(RouterName.CREATELOAN);
          },
          backgroundColor: Color.fromRGBO(228, 215, 255, 1),
          child: Icon(Icons.add),
        ),
      );
    });
  }

  List<Widget> _getListLoan() {
    final ShopController shopController = Get.find<ShopController>();
    return List.generate(
      shopController.loanList.length,
      (index) {
        return TransitionsItem(
          loan: shopController.loanList[index],
        );
      },
    );
  }

  double _getTotalPending() {
    final ShopController shopController = Get.find<ShopController>();
    return shopController.loanList
        .map(
          (element) => element.loanPendingAmount,
        )
        .fold(0.0, (sum, amount) => sum + amount);
  }
}

class TransitionsItem extends StatelessWidget {
  const TransitionsItem({super.key, required this.loan});

  final LoanModel loan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,

      children: [
        InkWell(
          onTap: () {
            Get.toNamed(RouterName.LOAN_DETAILS, arguments: {"loan": loan});
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),

            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.w,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColor.secoundaryColor.withOpacity(.3),
                  blurRadius: 6,
                  offset: Offset(5, 5),
                ),
              ],
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.type.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColor.secoundaryColor,
                        ),
                      ),
                      Text(
                        loan.partyName,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        loan.narration,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.albertFont(
                          TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromARGB(200, 0, 0, 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${loan.createAt.toDate().year}-${loan.createAt.toDate().month}-${loan.createAt.toDate().day} ${loan.createAt.toDate().hour}:${loan.createAt.toDate().minute}",
                      style: TextStyle(
                        color: AppColor.secoundaryColor,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      "By: ${loan.byUserName}",
                      style: TextStyle(
                        color: AppColor.secoundaryColor,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "Balance: ₹${loan.loanPendingAmount}",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    Text(
                      "Goods Amount: ₹${loan.loanTotalAmount}",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }
}

class _MenuButton extends StatefulWidget {
  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton>
    with TickerProviderStateMixin {
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _topScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeMenu() {
    _animationController.reverse(from: .3).then((_) {
      _overlayEntry?.remove();
      setState(() {
        _isMenuOpen = false;
      });
    });
  }

  void _toggleMenu() {
    if (!_isMenuOpen) {
      final renderBox =
          _menuKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      _topScaleAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(_animationController);

      _overlayEntry = _buildOverlay(position, size);
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward(from: 0.0);
      _isMenuOpen = true;
      setState(() {});
    }
  }

  OverlayEntry _buildOverlay(Offset position, Size size) {
    final ShopController shopController = Get.find<ShopController>();
    final AuthController auth = Get.find<AuthController>();

    return OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeMenu,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: (position.dy + size.height),
              right: 1.w,
              child: Material(
                color: Colors.transparent,
                child: SizeTransition(
                  sizeFactor: _topScaleAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(29, 29, 29, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                      ),
                    ),

                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (shopController.shop.value?.ownerId ==
                            auth.firebaseUser.value?.uid)
                          _MenuItem(
                            icon: Icons.person_add_alt_1,
                            text: 'staffs',
                            onTap: () {
                              _closeMenu();
                              Get.toNamed(RouterName.SHOPSTAFF);
                            },
                          ),
                        _MenuItem(
                          icon: Icons.message,
                          text: 'Message',
                          onTap: () {
                            _closeMenu();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Message clicked'),
                              ),
                            );
                          },
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: IconButton(
        key: _menuKey,
        onPressed: _toggleMenu,
        icon: Icon(
          Icons.menu,
          size: 24.w,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(49, 49, 49, 1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class InnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double blur;
  final Offset offset;
  final double borderRadius;

  InnerShadowPainter({
    required this.shadowColor,
    required this.blur,
    required this.offset,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()..color = Colors.transparent;

    final Path outerPath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)))
      ..close();

    canvas.saveLayer(rect, paint);

    canvas.drawPath(outerPath, paint);

    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..color = shadowColor;

    final Path shadowPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.shift(offset * -1),
          Radius.circular(borderRadius),
        ),
      );

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
