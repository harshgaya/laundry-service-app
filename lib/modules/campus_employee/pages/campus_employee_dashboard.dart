import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/authentication/controllers/login_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_orders_from_warehouse_page.dart';
import 'package:laundry_service/modules/campus_employee/pages/create_collection_page.dart';
import 'package:laundry_service/modules/campus_employee/pages/remarks_warehouse.dart';

import 'profile/campus_employee_profile.dart';
import 'employee_search_untaken_cloths_from_warehouse.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      CreateCollectionPage(),
      CampusEmployeeOrderFromWarehouse(),
      RemarksWarehouse(),
      CampusEmployeeSearchUntakenClothsFromWarehouse(),
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
                    itemLabel: 'History',
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
                    inActiveItem: Image.asset('assets/icons/search.png'),
                    activeItem: Image.asset(
                      'assets/icons/search.png',
                      color: Colors.white,
                    ),
                    itemLabel: 'Search',
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
