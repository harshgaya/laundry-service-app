import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/remarks_page.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class CreateCollectionData extends StatefulWidget {
  const CreateCollectionData({super.key});

  @override
  State<CreateCollectionData> createState() => _CreateCollectionDataState();
}

class _CreateCollectionDataState extends State<CreateCollectionData> {
  final TextEditingController tagController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final campusEmployeeController = Get.put(CampusEmployeeController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              WhiteContainer(
                widget: Column(
                  children: [
                    Icon(Icons.collections),
                    SizedBox(
                      height: 10,
                    ),
                    Text('New Collection'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WhiteContainer(
                        widget: TextFormField(
                          controller: tagController,
                          decoration: const InputDecoration(hintText: 'Tag No'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: WhiteContainer(
                        widget: TextFormField(
                          controller: countController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Count',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          campusEmployeeController.addOrder(tagController.text,
                              int.parse(countController.text));
                          // tagController.text = '';
                          // countController.text = '';
                          // setState(() {});
                        },
                        child: WhiteContainer(widget: Text('add'))),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => Expanded(
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(color: Colors.black, width: 1),
                        children: [
                          // Table header
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Tag No.'),
                                  color: Color(0xFFA0D4BE),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Count'),
                                  color: Color(0xFFA0D4BE),
                                ),
                              ),
                            ],
                          ),
                          // Table rows from the orders list
                          ...campusEmployeeController.orders.map((order) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(order.tagNo),
                                    color: Color(0xFFA0D4BE),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(order.count.toString()),
                                    color: Color(0xFFA0D4BE),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                      'Tag Count: ${campusEmployeeController.orders.length}'),
                                  color: Color(0xFFA0D4BE),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                      'Pieces Count: ${campusEmployeeController.orders.fold(0, (sum, order) => sum + order.count)}'),
                                  color: Color(0xFFA0D4BE),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('Finished Scanning'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.to(() => RemarksPage());
                                  },
                                  child: Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel')),
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
