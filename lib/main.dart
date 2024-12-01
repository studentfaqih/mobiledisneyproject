// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disney+ Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.sourceSansProTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white),
        scaffoldBackgroundColor: const Color(0xFF1A1D29),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1D29),
          elevation: 0,
        ),
      ),
      home: const BottomNav(),
    );
  }
}
