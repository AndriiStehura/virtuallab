import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuallab/src/bloc/task_passing_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/pages/main_page.dart';
import 'package:virtuallab/src/pages/task_passing_result_page.dart';
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
  void initState() {
    super.initState();

    widget.bloc.state.listen((event) {
      if (event.hasError) {
        Fluttertoast.showToast(msg: 'Submitting solution failed', timeInSecForIosWeb: 5, webBgColor: 'red');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: Center(
        heightFactor: 1.3,
        child: StreamBuilder<TaskPassingState>(
            stream: widget.bloc.state,
            initialData: widget.bloc.initial,
            builder: (context, snapshot) {
              final state = snapshot.data!;

              if (state.isWaiting) return const Center(child: CircularProgressIndicator());

              return Form(
                key: _formKey,
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
                          Text(
                            'Task #${widget.task.id}',
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 1.0,
                          ),
                          const SizedBox(
                            height: 18.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'Theme ',
                                    style: const TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.normal, color: backgroundTextColor),
                                    children: [
                                      TextSpan(
                                        text: widget.task.theme!.name,
                                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: 'Complexity ',
                                    style: const TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.normal, color: backgroundTextColor),
                                    children: [
                                      TextSpan(
                                          text: widget.task.complexity.string,
                                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
                                    ]),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18.0,
                          ),
                          const Text(
                            'Description:',
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
                              color: Colors.white,
                              border: Border.all(
                                color: headerColor.withOpacity(0.8),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.task.description,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18.0,
                          ),
                          const Text(
                            'Your solution:',
                            style: TextStyle(fontSize: 16.0, color: backgroundTextColor),
                          ),
                          const SizedBox(
                            height: 18.0,
                          ),
                          SizedBox(
                            height: 100,
                            child: TextFormField(
                              controller: _answerController,
                              validator: (value) {
                                return value.isNotBlank ? null : 'Please provide an answer';
                              },
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              decoration: InputDecoration(
                                hintText: 'Enter your solution here',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: headerColor.withOpacity(0.8), width: 1.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: headerColor, width: 1.0),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: headerColor, width: 1.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18.0,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 230,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                    child: const Text('Cancel', style: TextStyle(color: headerColor)),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(createRoute(const MainPage()));
                                    },
                                  ),
                                  SizedBox(
                                    width: 30,
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
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        final grade = await widget.bloc.submitTask(widget.task, _answerController.text);
                                        if (grade != null) {
                                          Navigator.of(context).pushReplacement(createRoute(TaskPassingResultPage(
                                            grade: grade,
                                            userAnswer: _answerController.text,
                                            task: widget.task,
                                          )));
                                        }
                                      }
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
              );
            }),
      ),
    );
  }
}
