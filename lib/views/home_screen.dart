import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database_helper.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final String userPhone;

  // এখানে 'const' রাখা যাবে না কারণ DatabaseHelper() কনস্ট্যান্ট নয়
  HomeScreen({super.key, required this.userName, required this.userPhone});

  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _handleServiceRequest(
    BuildContext context,
    String serviceName,
    String hotLine,
  ) async {
    await _dbHelper.requestService(userName, userPhone, serviceName);

    final Uri url = Uri.parse('tel:$hotLine');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch call for $serviceName')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isGuest = userName == "Guest User";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Help Desk'),
        backgroundColor: Colors.redAccent,
        actions: [
          if (!isGuest)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.redAccent.withValues(alpha: 0.1),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $userName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (isGuest)
                        const Text(
                          'Login for full services',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          'Phone: $userPhone',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                    ],
                  ),
                ),
                if (isGuest)
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(15),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
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
                if (!isGuest) ...[
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
                    'Doctor',
                    Icons.person_search,
                    Colors.teal,
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
                    'Blood Donor',
                    Icons.bloodtype,
                    Colors.redAccent,
                    '01700000000',
                  ),
                ],
              ],
            ),
          ),
        ],
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _handleServiceRequest(context, title, phone),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
