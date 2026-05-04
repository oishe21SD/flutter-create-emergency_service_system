import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // নাম এবং ফোন নম্বর ইনপুট নেয়ার জন্য কন্ট্রোলার
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // রেজিস্ট্রেশন এবং লগইন হ্যান্ডেল করার ফাংশন
  void _submit() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both Name and Phone number')),
      );
      return;
    }

    // প্রথমে চেক করছি ইউজার অলরেডি আছে কিনা
    var user = await _dbHelper.loginUser(phone);

    if (user == null) {
      // যদি ইউজার না থাকে তবে নতুন রেজিস্ট্রেশন হবে
      await _dbHelper.registerUser(name, phone);
      print("New User Registered: $name");
    }

    // লগইন বা রেজিস্ট্রেশন সফল হলে হোম স্ক্রিনে নিয়ে যাবে
    // সাথে ইউজারের নাম এবং ফোন নম্বর পাঠিয়ে দিচ্ছি যাতে আমরা ট্র্যাক করতে পারি
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(userName: name, userPhone: phone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // অ্যাপের লোগো আইকন
              Icon(Icons.emergency_share, size: 100, color: Colors.redAccent),
              SizedBox(height: 20),
              Text(
                'Service Registration',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text('Enter details to get emergency help'),
              SizedBox(height: 40),
              // নাম ইনপুট
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // ফোন নম্বর ইনপুট
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // সাবমিট বাটন
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Login / Register',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
