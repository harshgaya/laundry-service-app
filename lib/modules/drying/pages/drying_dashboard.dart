import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/drying/pages/drying_history.dart';
import 'package:laundry_service/modules/drying/pages/drying_todo_list.dart';
import 'package:laundry_service/modules/drying/pages/profile/drying_profile.dart';
import '../../authentication/controllers/login_controller.dart';
import 'drying_history_page.dart';

class DryingDashboard extends StatefulWidget {
  const DryingDashboard({super.key});

  @override
  State<DryingDashboard> createState() => _DryingDashboardState();
}

class _DryingDashboardState extends State<DryingDashboard> {
  final loginController = Get.put(LoginController());
  final _pageController = PageController(initialPage: 0);

  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 3;

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      DryingToDoPage(),
      //DryingHistory(),
      DryingHistoryPage(),
      DryingProfile(),
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
