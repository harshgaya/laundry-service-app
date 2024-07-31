import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF7FD0FE)),
      title: 'Laundry Service',
      home: UserState(),
    );
  }
}
