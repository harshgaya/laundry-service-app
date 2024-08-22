import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/models/college_campus_model.dart';
import 'package:laundry_service/modules/campus_employee/pages/create_collection_data.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

class CreateCollectionView extends StatefulWidget {
  const CreateCollectionView({super.key});

  @override
  State<CreateCollectionView> createState() => _CreateCollectionDateState();
}

class _CreateCollectionDateState extends State<CreateCollectionView> {
  final campuseEmployeeController = Get.put(CampusEmployeeController());
  String? selectedCampus;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New\nCollection',
                style: GoogleFonts.roboto(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campus Name',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(() => Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Select',
                            hintStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            fillColor: Colors.blue,
                          ),
                          value: selectedCampus,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCampus = newValue;
                            });
                            final campus = campuseEmployeeController
                                .collegeCampus.value?.data[0].campuses
                                .firstWhere(
                              (campus) => campus.name == selectedCampus,
                            );
                            campuseEmployeeController.selectedCampus.value =
                                newValue!;
                            campuseEmployeeController.selectedTag.value =
                                campus!.tagName;
                            campuseEmployeeController.selectedCampusId.value =
                                campus.uid;
                          },
                          dropdownColor: Colors.blue,
                          items: campuseEmployeeController
                              .collegeCampus.value?.data[0].campuses
                              .map<DropdownMenuItem<String>>((Campus campus) {
                            return DropdownMenuItem<String>(
                              value: campus.name,
                              child: Text(
                                campus.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Collection No',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Obx(
                    () => Text(
                      campuseEmployeeController.latestCollectionId.toString(),
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.center,
                child: RoundButtonAnimate(
                  buttonName: 'Start Collection',
                  onClick: () {
                    Get.to(() => const CreateCollectionData());
                  },
                  image: Image.asset(
                    'assets/gifs/collection.gif',
                    height: 60,
                    color: Colors.white,
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
