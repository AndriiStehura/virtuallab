import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuallab/src/bloc/task_select_bloc.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/theme.dart' as model;
import 'package:virtuallab/src/pages/task_passing_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/service_locator.dart';

class TaskSelectPage extends StatefulWidget {
  const TaskSelectPage({Key? key, required this.bloc}) : super(key: key);

  final TaskSelectBloc bloc;

  @override
  _TaskSelectPageState createState() => _TaskSelectPageState();
}

class _TaskSelectPageState extends State<TaskSelectPage> {
  bool _isFirstState = true;

  @override
  void initState() {
    super.initState();
    widget.bloc.fetchThemes();
    widget.bloc.state.listen((event) {
      if (event.themes.isNotEmpty && _isFirstState) {
        setState(() {
          _selectedTheme = event.themes.first;
          _isFirstState = false;
        });
      }
    });
  }

  model.Theme? _selectedTheme;
  Complexity _selectedComplexity = Complexity.easy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Coding Module',
                style: TextStyle(fontSize: 22.0),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 50,
            ),
            StreamBuilder<TaskSelectState>(
                stream: widget.bloc.state,
                initialData: widget.bloc.initial,
                builder: (context, snapshot) {
                  final state = snapshot.data!;

                  return Center(
                    child: state.isFetching
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: 500,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Choose theme',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                DropdownButtonFormField(
                                  value: state.themes.first,
                                  onChanged: (value) {
                                    _selectedTheme = value as model.Theme;
                                  },
                                  items: state.themes
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.name),
                                            value: e,
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 32.0),
                                const Text(
                                  'Choose complexity',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                DropdownButtonFormField(
                                  value: Complexity.easy,
                                  onChanged: (value) {
                                    _selectedComplexity = value as Complexity;
                                  },
                                  items: Complexity.values
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.string),
                                            value: e,
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 32.0),
                                SizedBox(
                                  height: 45.0,
                                  width: double.infinity,
                                  child: Hero(
                                    tag: 'oleg',
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_selectedTheme != null) {
                                          final task =
                                              await widget.bloc.fetchTask(_selectedTheme!, _selectedComplexity);

                                          if (task != null) {
                                            Navigator.of(context).pushReplacement(
                                              createRoute(TaskPassingPage(
                                                task: task,
                                                bloc: serviceLocator(),
                                              )),
                                            );
                                          } else {
                                            Fluttertoast.showToast(msg: 'No task found');
                                          }
                                        } else {
                                          Fluttertoast.showToast(msg: 'Please select theme and complexity');
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Create account',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
