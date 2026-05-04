//E:\flutter_projects\emergency_service_system\lib\views\home_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database_helper.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final String userPhone;

  HomeScreen({required this.userName, required this.userPhone});

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // কল করার এবং ডেটাবেজে রিকোয়েস্ট সেভ করার ফাংশন
  void _handleServiceRequest(
    BuildContext context,
    String serviceName,
    String hotLine,
  ) async {
    // ১. ডেটাবেজে সেভ করা (যাতে এডমিন দেখতে পায় কে ক্লিক করেছে)
    await _dbHelper.requestService(userName, userPhone, serviceName);

    // ২. সরাসরি কল অপশনে নিয়ে যাওয়া
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
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              // আমরা পরে এডমিন প্যানেল তৈরি করব
              print("Go to Admin Panel");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // উপরের ওয়েলকাম ব্যানার
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.redAccent.withOpacity(0.1),
            child: Row(
              children: [
                CircleAvatar(child: Icon(Icons.person)),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $userName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'How can we help you today?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // সার্ভিস গ্রিড
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(15),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildServiceCard(
                  context,
                  'Ambulance',
                  Icons.medical_services,
                  Colors.blue,
                  '999',
                ),
                _buildServiceCard(
                  context,
                  'Fire Service',
                  Icons.fire_truck,
                  Colors.orange,
                  '999',
                ),
                _buildServiceCard(
                  context,
                  'Police',
                  Icons.local_police,
                  Colors.indigo,
                  '999',
                ),
                _buildServiceCard(
                  context,
                  'Road Accident',
                  Icons.warning,
                  Colors.red,
                  '999',
                ),
                _buildServiceCard(
                  context,
                  'Home Tutor',
                  Icons.book,
                  Colors.green,
                  '01700000000',
                ),
                _buildServiceCard(
                  context,
                  'Home Care',
                  Icons.home_repair_service,
                  Colors.brown,
                  '01700000000',
                ),
                _buildServiceCard(
                  context,
                  'Doctor',
                  Icons.person_search,
                  Colors.teal,
                  '01700000000',
                ),
                _buildServiceCard(
                  context,
                  'Blood Donor',
                  Icons.bloodtype,
                  Colors.redAccent,
                  '01700000000',
                ),
              ],
            ),
          ),
        ],
      ),

      // ২৪/৭ সাপোর্ট কল বাটন
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _handleServiceRequest(context, "24/7 Support", "017XXXXXXXX"),
        label: Text('24/7 Support'),
        icon: Icon(Icons.call),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String phone,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _handleServiceRequest(context, title, phone),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tap to Call',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
