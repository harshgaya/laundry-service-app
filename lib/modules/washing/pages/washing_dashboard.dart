import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/washing/pages/profile/washing_profile.dart';
import 'package:laundry_service/modules/washing/pages/todo_list_washing.dart';
import 'package:laundry_service/modules/washing/pages/washing_add_remarks.dart';
import 'package:laundry_service/modules/washing/pages/washing_history_page.dart';
import 'package:laundry_service/modules/washing/pages/washing_remarks_page.dart';

import '../../campus_employee/pages/remarks_warehouse.dart';

class WashingDashboard extends StatefulWidget {
  const WashingDashboard({super.key});

  @override
  State<WashingDashboard> createState() => _WashingDashboardState();
}

class _WashingDashboardState extends State<WashingDashboard> {
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);
  final _pageController = PageController(initialPage: 0);

  int maxCount = 5;
  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const ToDoListWashing(),
      const WashingHistoryPage(),
      const WashingAddRemarks(),
      const WashingProfile(),
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
                    inActiveItem: Image.asset('assets/icons/remarks.png'),
                    activeItem: Image.asset(
                      'assets/icons/remarks.png',
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
