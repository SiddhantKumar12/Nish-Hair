import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:resolute/home2.dart';
import 'package:resolute/home_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  PersistentTabController? _controller;
  bool? _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const Preview(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItem() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
        title: 'Home',
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.local_library),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
        title: 'My Courses',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        screens: _buildScreens(),
        items: _navBarsItem(),
        controller: _controller,
        confineInSafeArea: true,
        backgroundColor: Colors.red,
        hideNavigationBarWhenKeyboardShows: false,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}