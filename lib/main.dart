import 'package:flutter/material.dart';
import 'package:huba_checker/screens/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:huba_checker/screens/home_screen.dart';

import 'service/alarm_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AlarmManagerController.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          //scaffoldBackgroundColor: Color.fromARGB(255, 50, 151, 0),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      );
    });
  }
}
