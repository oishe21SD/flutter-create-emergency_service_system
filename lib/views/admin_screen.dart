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
    _loadRequests(); // পেজ লোড হওয়ার সময় ডেটা নিয়ে আসবে
  }

  // ডেটাবেজ থেকে রিকোয়েস্টের লিস্ট নিয়ে আসার ফাংশন
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
        title: Text('Admin Control Panel'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadRequests, // রিফ্রেশ বাটন
          ),
        ],
      ),
      body: _requests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No service requests found!',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final item = _requests[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.emergency, color: Colors.white),
                    ),
                    title: Text(
                      'Service: ${item['serviceType']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'User: ${item['userName']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Phone: ${item['userPhone']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Requested on: ${item['requestTime']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.call, color: Colors.green, size: 30),
                      onPressed: () async {
                        // সরাসরি সেই ইউজারকে কল করার অপশন
                        final Uri url = Uri.parse('tel:${item['userPhone']}');
                        // এখানে url_launcher ব্যবহার করা হয়েছে
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
