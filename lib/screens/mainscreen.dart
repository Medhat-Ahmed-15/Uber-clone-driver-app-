import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uber_driver_app/tabsPages/earningsTabPage.dart';
import 'package:uber_driver_app/tabsPages/homeTabPage.dart';
import 'package:uber_driver_app/tabsPages/profileTabPage.dart';
import 'package:uber_driver_app/tabsPages/ratingTabPage.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(
        length: 4,
        vsync:
            this); //dee lw 3amaltalha comment..lama 2adoos 3ala item mo3ayana el screen msh hatat8ayr lal item dee bs el item zat nfsha hayat3amlha highlight
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Rating',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.yellow[700],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        currentIndex:
            selectedIndex, //dee lw ana 3amaltalha comment..lama 2adoos 3ala item el screen mshi hatat8ayr lal item dee bs el item zat nfsha msh hayban 3aleiha 2n ana dost 3aleiha ya3ni msh hayat3amlha highlight
        showUnselectedLabels: true,
        onTap:
            onItemClicked, //dee by default batab3t el current index mn 8eir mna 2ab3t fal paramaters el index
      ),
    );
  }
}
