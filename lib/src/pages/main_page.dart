import 'package:flutter/material.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/pages/task_select_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/service_locator.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Test your knowledge in all stages of software life cycle on practice',
            style: TextStyle(fontSize: 22.0, color: backgroundTextColor),
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
                  Icons.paste,
                  size: 50,
                ),
                'Requirements Analysis',
                'The process of determining user expectations for a new or modified product',
                () => null,
              ),
              _buildCard(
                const Icon(Icons.design_services, size: 50),
                'Design',
                'The process of envisioning and defining software solutions to one or more sets of problems',
                () => null,
              ),
              _buildCard(
                const Icon(Icons.view_in_ar, size: 50),
                'Modelling',
                'The process of expressing a software design with the help of abstract language or pictures',
                () => null,
              ),
              _buildCard(
                const Icon(Icons.code_outlined, size: 50),
                'Coding',
                'The process of transforming the design of a system into a computer language format',
                () => Navigator.of(context).pushReplacement(
                  createRoute(TaskSelectPage(bloc: serviceLocator())),
                ),
              ),
              _buildCard(
                const Icon(Icons.bug_report, size: 50),
                'Testing',
                'The process of  verifying that a software product or application does what it is supposed to do',
                () => null,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(Widget icon, String headerText, String descriptionText, Function() onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
                Text(descriptionText, style: const TextStyle(fontSize: 14.0, color: backgroundTextColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
