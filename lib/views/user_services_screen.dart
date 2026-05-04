import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database_helper.dart';

class UserServicesScreen extends StatelessWidget {
  final String userName;
  final String userPhone;
  const UserServicesScreen({
    super.key,
    required this.userName,
    required this.userPhone,
  });

  void _callNow(BuildContext context, String service, String number) async {
    await DatabaseHelper().saveRequest(userName, userPhone, service);
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Full Services")),
      body: ListView(
        children: [
          ListTile(
            tileColor: Colors.yellow[100],
            leading: const Icon(Icons.support_agent, color: Colors.black),
            title: const Text(
              "Call Admin Directly",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("For emergency support"),
            onTap: () => _callNow(
              context,
              "Admin Call",
              "017XXXXXXXX",
            ), // আপনার নম্বর দিন
          ),
          _serviceCard(context, "Police", "999", Icons.policy, Colors.blue),
          _serviceCard(
            context,
            "Home Doctor",
            "018XXXXXXXX",
            Icons.local_hospital,
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(
    BuildContext context,
    String title,
    String num,
    IconData icon,
    Color col,
  ) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(icon, color: col),
        title: Text(title),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: () => _callNow(context, title, num),
        ),
      ),
    );
  }
}
