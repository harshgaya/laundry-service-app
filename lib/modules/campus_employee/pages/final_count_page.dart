import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_dashboard.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class FinalCountPage extends StatefulWidget {
  const FinalCountPage({super.key});

  @override
  State<FinalCountPage> createState() => _FinalCountPageState();
}

class _FinalCountPageState extends State<FinalCountPage> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WhiteContainer(
                      widget: Text(
                          'Tag Count ${campusEmployeeController.orders.length}')),
                  WhiteContainer(
                      widget: Text(
                          'Total Pieces ${campusEmployeeController.orders.fold(0, (sum, order) => sum + order.count)}')),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              WhiteContainer(
                  widget: Text(
                      'Faculty Count ${campusEmployeeController.teacherOrders.fold(0, (sum, order) => sum + order.quantity)}')),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('Uploaded to sri chaityana school'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    campusEmployeeController
                                        .teacherOrders.value = [];
                                    campusEmployeeController.orders.value = [];
                                    Get.to(() => UserState());
                                  },
                                  child: Text('Ok')),
                            ],
                          );
                        });
                  },
                  child: WhiteContainer(widget: Text('Finish'))),
            ],
          ),
        ),
      ),
    );
  }
}
