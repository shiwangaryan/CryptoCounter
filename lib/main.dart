import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/pages/homePage.dart';
import 'package:getx/utils.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await registerService();
  await registerController();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed( 
          seedColor: Colors.green,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routes: {
        "/home": (context) => HomePage(),
      },
      initialRoute: "/home",
    );
  }
}
