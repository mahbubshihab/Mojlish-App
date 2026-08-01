import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/overview_bloc.dart';
import '../bloc/overview_event.dart';
import '../bloc/overview_state.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OverviewBloc>().add(LoadOverviewEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পরিচিতি'), // Overview
      ),
      body: BlocBuilder<OverviewBloc, OverviewState>(
        builder: (context, state) {
          if (state is OverviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OverviewLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.overview.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.overview.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  _buildSection('ভূমিকা', 'আল্লাহ রাব্বুল আলামীনের শুকরিয়া...'),
                  const SizedBox(height: 16),
                  _buildSection('প্রেক্ষাপট', 'মনে রাখতে হবে যুবসমাজই একটি জাতির...'),
                  const SizedBox(height: 16),
                  _buildSection('লক্ষ্য ও উদ্দেশ্য', 'আল্লাহ তাআলার সন্তুষ্টি অর্জনের লক্ষ্যে...'),
                  const SizedBox(height: 16),
                  _buildSection('নীতিমালা', '১. যুবকদের শান্তি, ন্যায়বিচার, স্বাধীনতা...'),
                  const SizedBox(height: 16),
                  _buildSection('কর্মসূচি', 'এক. যুব সমাজের ঐক্য...'),
                  const SizedBox(height: 16),
                  _buildSection('সাংগঠনিক স্তর', 'প্রাথমিক সদস্য ও সদস্য...'),
                  const SizedBox(height: 16),
                  _buildSection('সাংগঠনিক কাঠামো', 'কেন্দ্রীয় সংগঠন, জেলা/মহানগরী শাখা...'),
                ],
              ),
            );
          } else if (state is OverviewError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
