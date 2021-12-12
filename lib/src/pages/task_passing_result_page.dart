import 'package:flutter/material.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/task/grade.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/pages/main_page.dart';
import 'package:virtuallab/src/pages/transition.dart';

import '../colors.dart';

class TaskPassingResultPage extends StatelessWidget {
  const TaskPassingResultPage({Key? key, required this.grade, required this.userAnswer, required this.task})
      : super(key: key);

  final Grade grade;
  final String userAnswer;
  final LabTask task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: Center(
        heightFactor: 1.3,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Card(
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task results',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Your score: ${grade.grade}%',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: headerColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  const Text(
                    'Your solution:',
                    style: TextStyle(fontSize: 18.0, color: backgroundTextColor),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: grade.grade == 100
                          ? Colors.lightGreen.shade100.withOpacity(0.7)
                          : grade.grade > 50
                              ? Colors.yellow.shade200
                              : Colors.red.shade200,
                      border: Border.all(
                        color: headerColor.withOpacity(0.8),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        userAnswer,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  const Text(
                    'Right solution:',
                    style: TextStyle(fontSize: 16.0, color: backgroundTextColor),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.lightGreen.shade100.withOpacity(0.7),
                      border: Border.all(
                        color: headerColor.withOpacity(0.8),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        grade.rightAnswer,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(const Size(130.0, 35.0)),
                              backgroundColor: MaterialStateProperty.all<Color>(headerColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(color: Colors.white, fontSize: 18.0),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pushReplacement(createRoute(const MainPage()));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
