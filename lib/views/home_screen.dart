import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database_helper.dart';
import 'admin_screen.dart'; // এডমিন পেজের সাথে লিঙ্ক

class HomeScreen extends StatelessWidget {
  final String userName;
  final String userPhone;

  HomeScreen({required this.userName, required this.userPhone});

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // কল করা এবং ডেটাবেজে রিকোয়েস্ট সেভ করার মেইন ফাংশন
  void _handleServiceRequest(BuildContext context, String serviceName, String hotLine) async {
    // ইউজারের রিকোয়েস্টটি ডেটাবেজে সেভ করছি যাতে এডমিন দেখতে পায়
    await _dbHelper.requestService(userName, userPhone, serviceName);

    // সরাসরি কল অপশন ওপেন করা
    final Uri url = Uri.parse('tel:$hotLine');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch call for $serviceName')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Help Desk'),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        actions: [
          // এই বাটনে ক্লিক করলে এডমিন প্যানেলে যাওয়া যাবে
          IconButton(
            icon: Icon(Icons.admin_panel_settings, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ইউজার প্রোফাইল ব্যানার
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.person, color: Colors.white, size: 35),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, $userName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('Emergency support is one tap away', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
          ),
          
          // সব সার্ভিসের লিস্ট (Grid View)
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(15),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildServiceCard(context, 'Ambulance', Icons.medical_services, Colors.blue, '999'),
                _buildServiceCard(context, 'Fire Service', Icons.fire_truck, Colors.orange, '999'),
                _buildServiceCard(context, 'Police', Icons.local_police, Colors.indigo, '999'),
                _buildServiceCard(context, 'Road Accident', Icons.warning, Colors.red, '999'),
                _buildServiceCard(context, 'Home Tutor', Icons.book, Colors.green, '01700000000'),
                _buildServiceCard(context, 'Home Care', Icons.home_repair_service, Colors.brown, '01700000000'),
                _buildServiceCard(context, 'Doctor', Icons.person_search, Colors.teal, '01700000000'),
                _buildServiceCard(context, 'Blood Donor', Icons.bloodtype, Colors.redAccent, '01700000000'),
              ],
            ),
          ),
        ],
      ),
      
      // ২৪/৭ সাপোর্ট বাটন (ফ্লোটিং)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleServiceRequest(context, "24/7 Support", "017XXXXXXXX"),
        label: Text('Call Admin Support', style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.support_agent, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }

  // প্রতিটি কার্ডের ডিজাইন করার জন্য ছোট ফাংশন
  Widget _buildServiceCard(BuildContext context, String title, IconData icon, Color color, String phone) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _handleServiceRequest(context, title, phone),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Tap for Help', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}