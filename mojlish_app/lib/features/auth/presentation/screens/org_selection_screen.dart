import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/presentation/screens/main_dashboard_screen.dart';

class OrgSelectionScreen extends StatefulWidget {
  const OrgSelectionScreen({super.key});

  @override
  State<OrgSelectionScreen> createState() => _OrgSelectionScreenState();
}

class _OrgSelectionScreenState extends State<OrgSelectionScreen> {
  String? _selectedOrg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'মজলিস অ্যাপ',
          style: TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/images/logo.png', height: 120),
              const SizedBox(height: 16),
              
              // Title
              Text(
                'খেলাফত মজলিস',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'খেলাফত প্রতিষ্ঠার লক্ষ্যে আন্দোলন গড়ে তুলুন।',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Selection text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'আপনার সংগঠন নির্বাচন করুন:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
              ),
              const SizedBox(height: 16),
              
              // Grid Selection
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildOrgBtn('যুব সংগঠন', Icons.people, Colors.orange),
                  _buildOrgBtn('ছাত্র সংগঠন', Icons.school, Colors.blue),
                  _buildOrgBtn('মহিলা সংগঠন', Icons.woman, Colors.pink),
                  _buildOrgBtn('শ্রমিক সংগঠন', Icons.engineering, Colors.amber.shade700),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _selectedOrg != null
                      ? () {
                          // Navigate to Dashboard
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
                          );
                        }
                      : null, // Disabled if nothing selected
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'সংগঠন নিশ্চিত করুন',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrgBtn(String title, IconData icon, Color color) {
    bool isSelected = _selectedOrg == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOrg = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey.shade600, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? color : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
