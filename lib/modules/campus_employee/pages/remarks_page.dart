import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/pages/faculty_cloths.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class RemarksPage extends StatefulWidget {
  const RemarksPage({super.key});

  @override
  State<RemarksPage> createState() => _RemarksPageState();
}

class _RemarksPageState extends State<RemarksPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              WhiteContainer(widget: Text('Remarks')),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WhiteContainer(widget: Text('Tag No')),
                  WhiteContainer(widget: Text('Remarks Type')),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
              WhiteContainer(widget: Text('Next Only If Data is Entered')),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                  onTap: () {
                    Get.to(() => FacultyCloth());
                  },
                  child: WhiteContainer(widget: Text('Skip'))),
            ],
          ),
        ),
      ),
    );
  }
}
