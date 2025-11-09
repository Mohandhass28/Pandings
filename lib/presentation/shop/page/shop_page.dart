import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
