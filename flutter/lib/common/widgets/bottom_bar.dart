import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/features/account/screens/account_screen.dart';
import 'package:ecommerce/features/account/screens/notification_screen.dart';
import 'package:ecommerce/features/cart/screens/cart_screen.dart';
import 'package:ecommerce/features/home/screens/home_screen.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  final double bottomBarWidth = 42;
  final double bottomBarBorderWidth = 3;

  final List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
    const NotificationScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          // HOME
          _buildNavItem(Icons.home_outlined, 0),

          // ACCOUNT
          _buildNavItem(Icons.person_outline_outlined, 1),

          // CART
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              padding: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : Colors.transparent,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: badges.Badge(
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.white,
                  elevation: 0,
                ),
                badgeContent: Text(
                  userCartLen.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
            label: '',
          ),

          // NOTIFICATIONS
          _buildNavItem(Icons.notifications_outlined, 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        width: bottomBarWidth,
        padding: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _page == index
                  ? GlobalVariables.selectedNavBarColor
                  : Colors.transparent,
              width: bottomBarBorderWidth,
            ),
          ),
        ),
        child: Icon(icon),
      ),
      label: '',
    );
  }
}
