import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/create_collection_data.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class CreateCollectionView extends StatefulWidget {
  const CreateCollectionView({super.key});

  @override
  State<CreateCollectionView> createState() => _CreateCollectionDateState();
}

class _CreateCollectionDateState extends State<CreateCollectionView> {
  final campuseEmployeeController = Get.put(CampusEmployeeController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              WhiteContainer(widget: Text('New Collection')),
              const SizedBox(
                height: 20,
              ),
              WhiteContainer(widget: Text('Shri Chatyana')),
              const SizedBox(
                height: 20,
              ),
              WhiteContainer(widget: Text(DateTime.now().toString())),
              const SizedBox(
                height: 20,
              ),
              WhiteContainer(
                  widget: Text(
                      'Collection No: ${campuseEmployeeController.collectionNo.value}')),
              const SizedBox(
                height: 200,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => CreateCollectionData());
                },
                child: const WhiteContainer(widget: Text('Create Collection')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
