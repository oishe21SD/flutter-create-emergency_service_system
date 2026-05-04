import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final String userPhone;

  const HomeScreen({super.key, required this.userName, required this.userPhone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Services"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ইউজার ইনফো কার্ড
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Welcome: $userName", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(role: "User Portal"))),
                    child: const Text("Login"),
                  )
                ],
              ),
            ),
            
            // পোর্টালে ঢোকার বাটন
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(child: _portalButton(context, "User Portal", Icons.person, Colors.blue)),
                  const SizedBox(width: 10),
                  Expanded(child: _portalButton(context, "Admin Portal", Icons.admin_panel_settings, Colors.black87)),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Emergency Contacts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

            // আপনার আগের উইজেটগুলো এখানে সাজানো
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _serviceCard("Ambulance", "999", Icons.medical_services, Colors.red),
                _serviceCard("Fire Service", "16163", Icons.fire_truck, Colors.orange),
                _serviceCard("Police", "999", Icons.policy, Colors.indigo),
                _serviceCard("Doctor", "017XXXXXXXX", Icons.person, Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _portalButton(BuildContext context, String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(role: title))),
      icon: Icon(icon),
      label: Text(title),
    );
  }

  Widget _serviceCard(String title, String num, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 45, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(num, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}