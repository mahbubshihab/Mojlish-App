import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class JoinOrganizationScreen extends StatefulWidget {
  const JoinOrganizationScreen({super.key});

  @override
  State<JoinOrganizationScreen> createState() => _JoinOrganizationScreenState();
}

class _JoinOrganizationScreenState extends State<JoinOrganizationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('সংগঠনে যুক্ত হোন', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'খেলাফত মজলিসে আপনাকে স্বাগতম!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 8),
              Text(
                'দয়া করে নিচের তথ্যগুলো পূরণ করে আপনার আবেদন জমা দিন।',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 30),
              
              _buildTextField('আপনার পূর্ণ নাম', Icons.person),
              const SizedBox(height: 20),
              _buildTextField('মোবাইল নাম্বার', Icons.phone, keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              _buildTextField('বয়স', Icons.calendar_today, keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildTextField('পেশা (ছাত্র/চাকরিজীবী/ব্যবসায়ী)', Icons.work),
              const SizedBox(height: 20),
              _buildTextField('বর্তমান জেলা', Icons.location_on),
              const SizedBox(height: 20),
              _buildTextField('ফেসবুক লিংক (অপশনাল)', Icons.link),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('আপনার আবেদন সফলভাবে জমা হয়েছে!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('আবেদন জমা দিন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty && label != 'ফেসবুক লিংক (অপশনাল)') {
          return 'এই ফিল্ডটি পূরণ করা আবশ্যক';
        }
        return null;
      },
    );
  }
}
