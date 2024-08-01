import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/authentication/controllers/login_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/collection_page.dart';
import 'package:laundry_service/modules/campus_employee/pages/create_collection_page.dart';
import 'package:laundry_service/modules/campus_employee/pages/remarks_warehouse.dart';

import 'campus_employee_profile.dart';

class CampusEmployeeDashboard extends StatefulWidget {
  const CampusEmployeeDashboard({super.key});

  @override
  State<CampusEmployeeDashboard> createState() =>
      _CampusEmployeeDashboardState();
}

class _CampusEmployeeDashboardState extends State<CampusEmployeeDashboard> {
  final loginController = Get.put(LoginController());
  final _pageController = PageController(initialPage: 0);

  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 5;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    CreateCollectionPage(),
    Container(),
    Container(),
    CampusEmployeeProfile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      CreateCollectionPage(),
      CollectionPage(),
      RemarksWarehouse(),
      CampusEmployeeProfile(),
    ];
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? AnimatedNotchBottomBar(
                /// Provide NotchBottomBarController
                notchBottomBarController: _controller,
                color: Colors.white,
                showLabel: true,
                textOverflow: TextOverflow.visible,
                maxLine: 1,
                shadowElevation: 5,
                kBottomRadius: 28.0,

                notchColor: Colors.blue,

                /// restart app if you change removeMargins
                removeMargins: false,
                bottomBarWidth: Get.width,
                showShadow: true,
                durationInMilliSeconds: 300,

                itemLabelStyle: const TextStyle(fontSize: 10),

                elevation: 1,
                bottomBarItems: [
                  BottomBarItem(
                    inActiveItem: Image.asset('assets/icons/home.png'),
                    activeItem: Image.asset(
                      'assets/icons/home.png',
                      color: Colors.white,
                    ),
                    itemLabel: 'Home',
                  ),
                  BottomBarItem(
                    inActiveItem: Image.asset('assets/icons/collection.png'),
                    activeItem: Image.asset(
                      'assets/icons/collection.png',
                      color: Colors.white,
                    ),
                    itemLabel: 'Collection',
                  ),
                  BottomBarItem(
                    inActiveItem: Image.asset('assets/icons/collection.png'),
                    activeItem: Image.asset(
                      'assets/icons/collection.png',
                      color: Colors.white,
                    ),
                    itemLabel: 'Remarks',
                  ),
                  BottomBarItem(
                    inActiveItem: Image.asset('assets/icons/user.png'),
                    activeItem: Image.asset(
                      'assets/icons/user.png',
                      color: Colors.white,
                    ),
                    itemLabel: 'Profile',
                  ),
                ],
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                kIconSize: 24.0,
              )
            : null,
      ),
    );
  }
}
