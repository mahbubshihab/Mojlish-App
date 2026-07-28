import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/executive_rule_bloc.dart';
import '../bloc/executive_rule_event.dart';
import '../bloc/executive_rule_state.dart';

class ExecutiveRulesPage extends StatefulWidget {
  const ExecutiveRulesPage({Key? key}) : super(key: key);

  @override
  State<ExecutiveRulesPage> createState() => _ExecutiveRulesPageState();
}

class _ExecutiveRulesPageState extends State<ExecutiveRulesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExecutiveRuleBloc>().add(FetchExecutiveRulesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কর্মপ্রণালী (Executive Rules)'),
      ),
      body: BlocBuilder<ExecutiveRuleBloc, ExecutiveRuleState>(
        builder: (context, state) {
          if (state is ExecutiveRuleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExecutiveRuleLoaded) {
            if (state.rules.isEmpty) {
              return const Center(child: Text('কোন তথ্য পাওয়া যায়নি'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.rules.length,
              itemBuilder: (context, index) {
                final rule = state.rules[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (rule.imageUrl.isNotEmpty)
                        Image.asset(
                          rule.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rule.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              rule.content,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is ExecutiveRuleError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
