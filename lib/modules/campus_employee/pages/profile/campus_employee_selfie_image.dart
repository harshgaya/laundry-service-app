import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../campus_employee_dashboard.dart';

class CampusEmployeeSelfieImage extends StatefulWidget {
  const CampusEmployeeSelfieImage({super.key});

  @override
  State<CampusEmployeeSelfieImage> createState() =>
      _CampusEmployeeSelfieImageState();
}

class _CampusEmployeeSelfieImageState extends State<CampusEmployeeSelfieImage> {
  late FaceCameraController controller;
  File? imageFile;

  @override
  void initState() {
    controller = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        print('image caprured');
        imageFile = image;
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  File? _selfieImage;

  Future<void> _captureSelfie() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selfieImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Selfie'),
      ),
      body: imageFile != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Image.file(imageFile!),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundButtonAnimate(
                    buttonName: 'Dashboard',
                    onClick: () {
                      Get.offAll(() => const CampusEmployeeDashboard());
                    },
                    image: const Icon(
                      Icons.dashboard,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SmartFaceCamera(
                controller: controller,
                message: 'Center your face in the square',
              )
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     _selfieImage == null
              //         ? InkWell(
              //             onTap: _captureSelfie,
              //             child: const Icon(
              //               Icons.camera_alt,
              //               size: 100,
              //             ),
              //           )
              //         : Image.file(
              //             _selfieImage!,
              //             height: 300,
              //           ),
              //     const SizedBox(height: 20),
              //     if (_selfieImage != null)
              //       RoundButtonAnimate(
              //           buttonName: 'Dashboard',
              //           onClick: () {
              //             Get.offAll(() => const CampusEmployeeDashboard());
              //           },
              //           image: const Icon(Icons.dashboard))
              //   ],
              // ),
              ),
    );
  }
}
