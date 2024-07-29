import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/authentication/controllers/login_controller.dart';

class CampusEmployeeDashboard extends StatefulWidget {
  const CampusEmployeeDashboard({super.key});

  @override
  State<CampusEmployeeDashboard> createState() =>
      _CampusEmployeeDashboardState();
}

class _CampusEmployeeDashboardState extends State<CampusEmployeeDashboard> {
  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      loginController.logout();
                    },
                    child: Image.asset(
                      'assets/icons/logout.png',
                      height: 30,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'ONGOING BATCHES',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Table(
              border: TableBorder.all(
                  color: Colors.black, width: 1), // Set border color and width
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text('Batch No.'),
                        color: Color(0xFFA0D4BE), // Optional background color
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text('Date of Pick Up'),
                        color: Color(0xFFA0D4BE), // Optional background color
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text('1001'),
                        color: Color(0xFFA0D4BE), // Optional background color
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text('22/02/2024 7.30 pm'),
                        color: Color(0xFFA0D4BE), // Optional background color
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFFA0D4BE)),
              onPressed: () {},
              child: SizedBox(
                width: Get.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/icons/create.png',
                      height: 20,
                    ),
                    const Text(
                      'Create New Batch',
                      style: TextStyle(color: Colors.black),
                    ),
                    Image.asset(
                      'assets/icons/right-arrow.png',
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
        bottomSheet: Container(
          height: 50,
          color: const Color(0xFFA0D4BE),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF8EB6A5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Completed',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 1,
                color: Colors.black,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF8EB6A5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Issue?',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
