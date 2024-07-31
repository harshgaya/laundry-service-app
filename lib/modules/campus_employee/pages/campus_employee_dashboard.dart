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
  int _currentIndex = 0;

  final List<Widget> _pages = [
    CreateCollectionPage(),
    CollectionPage(),
    Container(),
    RemarksWarehouse(),
    CampusEmployeeProfile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedLabelStyle: const TextStyle(color: Colors.black),
          selectedIconTheme: IconThemeData(color: Colors.black),
          unselectedIconTheme: IconThemeData(color: Colors.black),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections),
              label: 'Collection',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Call',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Remarks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: _pages[_currentIndex],
      ),
    );
  }
}
