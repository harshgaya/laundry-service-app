import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../helpers/utils.dart';
import 'final_count_page.dart';

class CampusEmployeeUploadDaySheetImage extends StatefulWidget {
  const CampusEmployeeUploadDaySheetImage({super.key});

  @override
  State<CampusEmployeeUploadDaySheetImage> createState() =>
      _CampusEmployeeUploadDaySheetImageState();
}

class _CampusEmployeeUploadDaySheetImageState
    extends State<CampusEmployeeUploadDaySheetImage> {
  @override
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        listOfImages.add(File(pickedFile.path));
      });
    } else {
      print('No image selected.');
    }
  }

  List<File> listOfImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Photo',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Upload Photo Of the\n Day Sheet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: _captureImage,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.camera_alt,
                  size: 120,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 130,
              width: Get.width - 20,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listOfImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Stack(
                        children: [
                          Image.file(
                            listOfImages[index],
                            height: 120,
                          ),
                          Positioned(
                              right: 10,
                              top: 10,
                              child: InkWell(
                                onTap: () {
                                  listOfImages.removeAt(index);
                                  setState(() {});
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 15,
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                if (listOfImages.isEmpty) {
                  Utils.showScaffoldMessageI(
                      context: context,
                      title: 'Please upload day sheet image.');
                } else {
                  Get.to(() => FinalCountPage());
                }
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Finish',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
