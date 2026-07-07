import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'personal_report_screen.dart';

class ReportSelectionScreen extends StatelessWidget {
  const ReportSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('রিপোর্টসমূহ', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReportCard(
              context, 
              title: 'ব্যক্তিগত তৎপরতার রিপোর্ট', 
              subtitle: 'জুলাই ২০২৬', 
              status: 'সাবমিট করা হয়েছে',
              color: Colors.green,
              icon: Icons.person,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalReportScreen())),
            ),
            _buildReportCard(
              context, 
              title: 'শাখা বায়তুলমাল রিপোর্ট', 
              subtitle: 'নতুন রিপোর্ট তৈরি করুন', 
              status: 'পেন্ডিং',
              color: Colors.blue,
              icon: Icons.account_balance_wallet,
              onTap: () {},
            ),
            _buildReportCard(
              context, 
              title: 'শাখা সাংগঠনিক রিপোর্ট', 
              subtitle: 'নতুন রিপোর্ট তৈরি করুন', 
              status: 'পেন্ডিং',
              color: Colors.orange,
              icon: Icons.group_work,
              onTap: () {},
            ),
            _buildReportCard(
              context, 
              title: 'জোনাল রিপোর্ট', 
              subtitle: 'নতুন রিপোর্ট তৈরি করুন', 
              status: 'পেন্ডিং',
              color: Colors.purple,
              icon: Icons.map,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, {
    required String title,
    required String subtitle,
    required String status,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    bool isSubmitted = status == 'সাবমিট করা হয়েছে';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSubmitted ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSubmitted ? Colors.green : Colors.orange),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isSubmitted ? Colors.green : Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
