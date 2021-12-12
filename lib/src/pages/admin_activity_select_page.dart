import 'package:flutter/material.dart';
import 'package:virtuallab/src/colors.dart';

class AdminActivitySelectPage extends StatelessWidget {
  const AdminActivitySelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
          ' Choose the activity to do today:',
          style: TextStyle(fontSize: 18.0, color: backgroundTextColor),
        ),
        const SizedBox(
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCard(
              const Icon(
                Icons.work,
                size: 50,
              ),
              'Working modules',
              'Test your practical skills in software development life cycle stages: requirement analysis, design, modelling, coding, testing.',
              () => null,
            ),
            _buildCard(
              const Icon(Icons.design_services, size: 50),
              'Admin Panel',
              'Manage the tasks for each of main modules. You can add new tasks, edit and delete tasks.',
              () => null,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildCard(Widget icon, String headerText, String descriptionText, Function() onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      height: 300,
      width: 240,
      child: Card(
        elevation: 8.0,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100, child: icon),
                Text(
                  headerText,
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16),
                Text(descriptionText, style: const TextStyle(fontSize: 16.0, color: backgroundTextColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
