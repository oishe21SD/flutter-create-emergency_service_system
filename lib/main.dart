import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/home_screen.dart'; // সরাসরি হোম স্ক্রিন ইমপোর্ট

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp()); // নাম পরিবর্তন করে MyApp করা হলো টেস্ট এরর দূর করতে
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
      // অ্যাপটি এখন সরাসরি হোম স্ক্রিন দিয়ে শুরু হবে (লগইন ছাড়া)
      home: const HomeScreen(
        userName: "Guest User",
        userPhone: "Not Logged In",
      ),
    );
  }
}
