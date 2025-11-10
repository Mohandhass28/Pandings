import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pendings/core/asset/app_images.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/core/theme/app_theme.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("shop name"),
        actions: [
          _MenuButton(),
        ],
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
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
              "₹10000.00",
              style: TextStyle(fontSize: 36.sp),
            ),

            SizedBox(
              height: 40.h,
            ),
            Text(
              "Loans",
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            LoanWidgetItem(),
          ],
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
  }
}

class LoanWidgetItem extends StatelessWidget {
  const LoanWidgetItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouterName.LOAN_DETAILS);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.w,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(150, 150, 150, 1),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "description",
                  style: AppTheme.albertFont(
                    TextStyle(
                      fontSize: 14.sp,
                      color: const Color.fromRGBO(0, 0, 0, .5),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "12-11-2026/11:20",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  "By: username",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "has to pay ₹10000",
                  style: TextStyle(fontSize: 15.sp),
                ),
              ],
            ),
          ],
        ),
      ),
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
                  // alignment: Alignment.topRight,
                  // scale: _topScaleAnimation,
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
                        _MenuItem(
                          icon: Icons.person_add_alt_1,
                          text: 'Add staffs',
                          onTap: () {
                            _closeMenu();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Add staffs clicked'),
                              ),
                            );
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
