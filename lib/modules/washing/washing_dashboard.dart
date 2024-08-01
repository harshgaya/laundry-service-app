import 'package:flutter/material.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_profile.dart';
import 'package:laundry_service/modules/washing/todo_list_washing.dart';

class WashingDashboard extends StatefulWidget {
  const WashingDashboard({super.key});

  @override
  State<WashingDashboard> createState() => _WashingDashboardState();
}

class _WashingDashboardState extends State<WashingDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ToDoListWashing(),
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
    return Scaffold(
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}
