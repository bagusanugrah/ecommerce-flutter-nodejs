import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/features/admin/screens/analtyics_screen.dart';
import 'package:ecommerce/features/admin/screens/orders_screen.dart';
import 'package:ecommerce/features/admin/screens/posts_screen.dart';
import 'package:ecommerce/features/account/services/account_services.dart';
import 'package:ecommerce/features/admin/screens/send_message_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  final double bottomBarWidth = 42;
  final double bottomBarBorderWidth = 3;

  final List<Widget> pages = [
    const PostsScreen(),
    const AnalyticsScreen(),
    const OrdersScreen(),
    const SendMessageScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Carrefour',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () => AccountServices().logOut(context),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
          _buildNavItem(Icons.home_outlined, 0),
          _buildNavItem(Icons.analytics_outlined, 1),
          _buildNavItem(Icons.all_inbox_outlined, 2),
          _buildNavItem(Icons.message_outlined, 3),
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
