import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'admin_screen.dart';
import 'user_services_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLogin = true;

  void _handleSubmit() async {
    final db = DatabaseHelper();
    if (isLogin) {
      var user = await db.loginUser(_phoneController.text, widget.role);
      if (user != null) {
        if (widget.role == "Admin Portal") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserServicesScreen(userName: user['name'], userPhone: user['phone'])));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not found! Register first.")));
      }
    } else {
      await db.registerUser(_nameController.text, _phoneController.text, widget.role);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successful! Please Login."), backgroundColor: Colors.green));
      setState(() => isLogin = true); // রেজিস্ট্রেশন শেষে লগইন পেজে নিয়ে আসা
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.role} Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!isLogin) TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _handleSubmit, child: Text(isLogin ? "Login" : "Register")),
            TextButton(onPressed: () => setState(() => isLogin = !isLogin), child: Text(isLogin ? "New here? Register" : "Already have account? Login"))
          ],
        ),
      ),
    );
  }
}