import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Service System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        textTheme: GoogleFonts.latoTextTheme(),
        useMaterial3: true,
      ),
      // এখানে 'const' তুলে দেওয়া হয়েছে এবং গেস্ট ইউজার হিসেবে অ্যাপ শুরু হবে
      home: HomeScreen(userName: "Guest User", userPhone: "Not Logged In"),
    );
  }
}
