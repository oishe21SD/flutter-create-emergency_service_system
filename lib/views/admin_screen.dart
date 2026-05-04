import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // কল করার জন্য জরুরি
import '../services/database_helper.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key}); // Key যুক্ত করা হয়েছে

  @override
  State<AdminScreen> createState() => _AdminScreenState(); // প্রাইভেট টাইপ ফিক্স
}

class _AdminScreenState extends State<AdminScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() async {
    var data = await _dbHelper.getAllRequests();
    setState(() {
      _requests = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Control Panel'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: _requests.isEmpty
          ? const Center(child: Text('No requests found.'))
          : ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final item = _requests[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      'Service: ${item['serviceType']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Text(
                      'User: ${item['userName']}\nPhone: ${item['userPhone']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () async {
                        final Uri dialUri = Uri.parse(
                          'tel:${item['userPhone']}',
                        );
                        if (await canLaunchUrl(dialUri)) {
                          await launchUrl(dialUri);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
