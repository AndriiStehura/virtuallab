import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuallab/src/bloc/task_creation_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/utils/string.dart';
import 'package:virtuallab/src/core/models/task/theme.dart' as model;
import 'package:virtuallab/src/pages/transition.dart';

import 'main_page.dart';

class TaskCreationPage extends StatefulWidget {
  const TaskCreationPage({Key? key, required this.bloc}) : super(key: key);

  final TaskCreationBloc bloc;

  @override
  _TaskCreationPageState createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  model.Theme? _selectedTheme;
  Complexity _selectedComplexity = Complexity.easy;

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _answerController = TextEditingController();

  bool _isFirstState = true;

  @override
  void initState() {
    super.initState();
    widget.bloc.getThemes();
    widget.bloc.state.listen((event) {
      if (event.themes.isNotEmpty && _isFirstState) {
        setState(() {
          _selectedTheme = event.themes.first;
          _isFirstState = false;
        });
      }
      if (event.isSaved) {
        Navigator.of(context).pushReplacement(createRoute(MainPage()));
        Fluttertoast.showToast(msg: 'Successfully created task', timeInSecForIosWeb: 5);
      }

      if (event.addThemeSuccess != null && event.addThemeSuccess!) {
        Fluttertoast.showToast(msg: 'Successfully added theme', timeInSecForIosWeb: 5);
      } else if (event.addThemeSuccess != null && event.addThemeSuccess == false) {
        Fluttertoast.showToast(msg: 'Failed adding theme', timeInSecForIosWeb: 5);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 120.0),
        child: StreamBuilder<TaskCreationState>(
            stream: widget.bloc.state,
            initialData: widget.bloc.initial,
            builder: (context, snapshot) {
              final state = snapshot.data!;

              if (state.isFetching) return CircularProgressIndicator();

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'New exercise',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select theme',
                            style: TextStyle(fontSize: 14.0, color: backgroundTextColor),
                          ),
                          Container(
                            width: 500,
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  child: DropdownButtonFormField(
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
                                ),
                                ElevatedButton(
                                  child: Text('+'),
                                  onPressed: () {
                                    _showThemeDialog();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select complexity',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Container(
                            width: 100,
                            child: DropdownButtonFormField(
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
                          ),
                        ],
                      )
                    ]),
                    const Text(
                      'Enter description:',
                      style: TextStyle(fontSize: 14.0, color: backgroundTextColor),
                    ),
                    Container(
                      height: 400,
                      child: TextFormField(
                        controller: _descriptionController,
                        validator: (value) {
                          return value.isNotBlank ? null : 'Please provide a description';
                        },
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(hintText: 'Enter description'),
                      ),
                    ),
                    const Text(
                      'Enter solution:',
                      style: TextStyle(fontSize: 14.0, color: backgroundTextColor),
                    ),
                    Container(
                      height: 400,
                      child: TextFormField(
                        controller: _answerController,
                        validator: (value) {
                          return value.isNotBlank ? null : 'Please provide an answer';
                        },
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(hintText: 'Enter description'),
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
                                final task = LabTask(
                                    id: 0,
                                    description: _descriptionController.text,
                                    answer: _answerController.text,
                                    complexity: _selectedComplexity,
                                    themeId: _selectedTheme!.id,
                                    theme: _selectedTheme!);

                                widget.bloc.submitTask(task);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              );
            }),
      ),
    );
  }

  _showThemeDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          final _themeNameController = TextEditingController();
          final _themeFormKey = GlobalKey<FormState>();

          return SimpleDialog(children: [
            const Text(
              'Enter theme name:',
              style: TextStyle(fontSize: 14.0, color: backgroundTextColor),
            ),
            Form(
              key: _themeFormKey,
              child: TextFormField(
                controller: _themeNameController,
                decoration: InputDecoration(hintText: 'Enter theme name'),
              ),
            ),
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
                Navigator.of(context).pop();
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
                if (_themeFormKey.currentState?.validate() ?? false) {
                  widget.bloc.submitTheme(_themeNameController.text);

                  Navigator.of(context).pop();
                  widget.bloc.getThemes();
                }
              },
            ),
          ]);
        });
  }
}
