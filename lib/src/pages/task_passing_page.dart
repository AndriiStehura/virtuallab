import 'package:flutter/material.dart';
import 'package:virtuallab/src/bloc/task_passing_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/pages/main_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/core/utils/string.dart';

class TaskPassingPage extends StatefulWidget {
  const TaskPassingPage({Key? key, required this.task, required this.bloc}) : super(key: key);

  final TaskPassingBloc bloc;
  final LabTask task;

  @override
  _TaskPassingPageState createState() => _TaskPassingPageState();
}

class _TaskPassingPageState extends State<TaskPassingPage> {
  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: StreamBuilder<TaskPassingState>(
            stream: widget.bloc.state,
            initialData: widget.bloc.initial,
            builder: (context, snapshot) {
              final state = snapshot.data!;

              if (state.isWaiting) return const CircularProgressIndicator();

              return Column(
                children: [
                  Text(
                    'Task #${widget.task.id}',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Theme',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: backgroundTextColor),
                            children: [
                              TextSpan(
                                text: widget.task.theme.name,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'Complexity',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: backgroundTextColor),
                            children: [
                              TextSpan(
                                  text: widget.task.complexity.string,
                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ],
                  ),
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 14.0, color: backgroundTextColor),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Text(widget.task.description),
                  ),
                  Text(
                    'Your solution:',
                    style: TextStyle(fontSize: 14.0, color: backgroundTextColor),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      height: 400,
                      child: TextFormField(
                        controller: _answerController,
                        validator: (value) {
                          return value.isNotBlank ? null : 'Please provide an answer';
                        },
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(hintText: 'Enter your solution here'),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    width: 200,
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: headerColor)),
                            fixedSize: MaterialStateProperty.all<Size>(const Size(100.0, 35.0)),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(createRoute(const MainPage()));
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(const Size(100.0, 35.0)),
                            backgroundColor: MaterialStateProperty.all<Color>(headerColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          child: const Text('Submit'),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              widget.bloc.submitTask(widget.task, _answerController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
