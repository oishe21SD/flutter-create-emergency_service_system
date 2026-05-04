import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests(); // স্ক্রিন ওপেন হওয়ার সময় ডেটা লোড হবে
  }

  // ডেটাবেজ থেকে সব রিকোয়েস্ট নিয়ে আসা
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
        title: Text('Admin Panel - Service Logs'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: _requests.isEmpty
          ? Center(child: Text('No service requests found yet.'))
          : ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final item = _requests[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      '${item['serviceType']} Request',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: ${item['userName']}'),
                        Text('Phone: ${item['userPhone']}'),
                        Text(
                          'Time: ${item['requestTime']}',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.call, color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}
