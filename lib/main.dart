import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_project/module/home_page/binding.dart';

import 'module/home_page/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: HomePageBinding(),
      home: HomePage(),
    );
  }
}


