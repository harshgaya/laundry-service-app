import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:laundry_service/helpers/utils.dart';

import 'CampusEmployeeUploadDaySheetImage.dart';

class CampusEmployeeUploadCollectionImage extends StatefulWidget {
  const CampusEmployeeUploadCollectionImage({super.key});

  @override
  State<CampusEmployeeUploadCollectionImage> createState() =>
      _CampusEmployeeUploadCollectionImageState();
}

class _CampusEmployeeUploadCollectionImageState
    extends State<CampusEmployeeUploadCollectionImage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

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
                'Upload Photo Of the\nCollection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _image == null
                ? InkWell(
                    onTap: _captureImage,
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.camera_alt,
                        size: 120,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: _captureImage,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.file(
                        _image!,
                        height: 120,
                      ),
                    )),
            const Spacer(),
            InkWell(
              onTap: () {
                if (_image == null) {
                  Utils.showScaffoldMessageI(
                      context: context,
                      title: 'Please upload collection image.');
                } else {
                  Get.to(() => CampusEmployeeUploadDaySheetImage());
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
