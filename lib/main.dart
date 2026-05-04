import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/login_screen.dart';

void main() {
  // অ্যাপ শুরু করার আগে নিশ্চিত করা যে সবকিছু ঠিক আছে
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const EmergencyServiceApp());
}

class EmergencyServiceApp extends StatelessWidget {
  const EmergencyServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Service System',

      // অ্যাপের থিম কালার রেড (ইমারজেন্সি এর জন্য)
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.latoTextTheme(), // সুন্দর ফন্ট ব্যবহার করা হয়েছে
        useMaterial3: true,
      ),

      // অ্যাপটি শুরু হবে লগইন স্ক্রিন দিয়ে
      home: LoginScreen(),
    );
  }
}
