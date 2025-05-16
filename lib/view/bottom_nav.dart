import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hotnchill/view/profile.dart';
import 'package:hotnchill/view/wallet.dart';

import 'home.dart';
import 'order.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentpage;
  late Home homepage;
  late Profile profile;
  late Order order;
  late Wallet wallet;

  @override
  void initState() {
    homepage = const Home();
    profile = const Profile();
    order = const Order();
    wallet = const Wallet();
    pages = [homepage, order, wallet, profile];
    currentpage = homepage; // Set the initial page
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.black,
          height: 65,
          animationDuration: const Duration(microseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
              currentpage = pages[currentTabIndex]; // Update the current page
            });
          },
          items: const [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.wallet_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.person_outlined,
              color: Colors.white,
            ),
          ]),
      body: currentpage, // Display the current page
    );
  }
}

