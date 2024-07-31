import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/final_count_page.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class FacultyCloth extends StatefulWidget {
  const FacultyCloth({super.key});

  @override
  State<FacultyCloth> createState() => _FacultyClothState();
}

class _FacultyClothState extends State<FacultyCloth> {
  final orderController = Get.put(CampusEmployeeController());
  String? selectedTeacher;
  List<String> teacherNames = [
    'Mr. Smith',
    'Ms. Johnson',
    'Mrs. Brown',
    'Mr. White'
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('Faculty Clothes')),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Teacher',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Color(0xFFA3A3A5),
              ),
              value: selectedTeacher,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTeacher = newValue;
                });
              },
              items:
                  teacherNames.map<DropdownMenuItem<String>>((String teacher) {
                return DropdownMenuItem<String>(
                  value: teacher,
                  child: Text(teacher),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => Table(
                border: TableBorder.all(color: Colors.black, width: 1),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('S.No',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Description',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Quantity',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < orderController.teacherOrders.length; i++)
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((i + 1).toString()),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                orderController.teacherOrders[i].description),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () =>
                                      orderController.decrementQuantity(i),
                                ),
                                Text(orderController.teacherOrders[i].quantity
                                    .toString()),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () =>
                                      orderController.incrementQuantity(i),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  Get.to(() => FinalCountPage());
                },
                child: WhiteContainer(widget: Text('Done'))),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('Skip')),
          ],
        ),
      ),
    );
  }
}
