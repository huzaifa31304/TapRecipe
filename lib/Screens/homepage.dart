import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'home.dart';
import 'saved.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(context,
          screens: screens(),
          items: navBarItems(),
        backgroundColor: Colors.black12,
        padding: NavBarPadding.symmetric(horizontal:2, vertical: 1),
        navBarStyle: NavBarStyle.style9,
        navBarHeight: 65
      ),
    );
  }
  List<Widget> screens(){
    return[
      home_page(),
      profile_page(),
      saved_page(),

    ];
  }
  List<PersistentBottomNavBarItem>navBarItems(){
    return[
      PersistentBottomNavBarItem(
        icon: Icon(Icons.restaurant_menu),
        inactiveColorPrimary: CupertinoColors.white,
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.redAccent,
        title: "Home",
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          inactiveColorPrimary: CupertinoColors.white,
          activeColorPrimary: Colors.white,
          activeColorSecondary: Colors.redAccent,
          title: "Profile"
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.favorite_rounded),
          inactiveColorPrimary: CupertinoColors.white,
          activeColorPrimary: Colors.white,
          activeColorSecondary: Colors.redAccent,
          title: "Saved"
      ),
    ];
  }
}
