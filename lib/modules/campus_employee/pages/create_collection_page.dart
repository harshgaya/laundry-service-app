import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

import 'create_collection_view.dart';

class CreateCollectionPage extends StatefulWidget {
  const CreateCollectionPage({super.key});

  @override
  State<CreateCollectionPage> createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    campusEmployeeController.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => WhiteContainer(
                    widget: Text(
                        'User Id:${campusEmployeeController.userId.isEmpty ? '' : campusEmployeeController.userId.toString().substring(0, 6)}'))),
                WhiteContainer(widget: Text('${DateTime.now()}'))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => WhiteContainer(
                widget: Text(campusEmployeeController.collegeName.value))),
            const SizedBox(
              height: 200,
            ),
            Obx(
              () => campusEmployeeController.creatingCollection.value
                  ? const CircularProgressIndicator()
                  : WhiteContainer(
                      widget: InkWell(
                        onTap: () async {
                          Get.to(() => const CreateCollectionView());
                        },
                        child: const Column(
                          children: [
                            Icon(Icons.collections),
                            SizedBox(
                              height: 10,
                            ),
                            Text('New Collection'),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
