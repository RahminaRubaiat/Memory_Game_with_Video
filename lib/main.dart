import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:research_app/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2220),
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: const HomePage(), 
          debugShowCheckedModeBanner: false,   
        );
      },
    );
  }
}