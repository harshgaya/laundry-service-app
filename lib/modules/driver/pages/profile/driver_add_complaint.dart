import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class DriverAddComplaint extends StatefulWidget {
  const DriverAddComplaint({super.key});

  @override
  State<DriverAddComplaint> createState() => _DriverAddComplaintState();
}

class _DriverAddComplaintState extends State<DriverAddComplaint> {
  String? selectedCollege;
  final complainTextController = TextEditingController();
  List<String> collegeNames = [
    'ABC college of Engineering',
    'DPS',
    'DAV',
    'Sri Chaitnya'
  ];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const CircleAvatar(
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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Complaint',
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Select College',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.blue,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please select college';
                    }
                    return null;
                  },
                  value: selectedCollege,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCollege = newValue;
                    });
                  },
                  dropdownColor: Colors.blue,
                  items: collegeNames
                      .map<DropdownMenuItem<String>>((String teacher) {
                    return DropdownMenuItem<String>(
                      value: teacher,
                      child: Text(
                        teacher,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 3,
                  controller: complainTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Complain', // Optional label text
                  ),
                  validator: (value) {
                    // The condition should check if the value is empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter a complaint';
                    }
                    return null; // Return null if the value passes validation
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Vehicle Complain',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 3,
                  controller: complainTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Complain', // Optional label text
                  ),
                  validator: (value) {
                    // The condition should check if the value is empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter a complaint';
                    }
                    return null; // Return null if the value passes validation
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
