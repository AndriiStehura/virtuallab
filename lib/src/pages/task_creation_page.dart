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
  const TaskCreationPage({Key? key, required this.bloc, this.task}) : super(key: key);

  final TaskCreationBloc bloc;
  final LabTask? task;

  @override
  _TaskCreationPageState createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  model.Theme? _selectedTheme;
  Complexity _selectedComplexity = Complexity.easy;

  final _formKey = GlobalKey<FormState>();
  late final _descriptionController;
  late final _answerController;

  bool _isFirstState = true;

  @override
  void initState() {
    super.initState();

    _descriptionController = TextEditingController(text: widget.task?.description);
    _answerController = TextEditingController(text: widget.task?.answer);

    _selectedTheme = widget.task?.theme;
    _selectedComplexity = widget.task?.complexity ?? Complexity.easy;

    widget.bloc.getThemes();
    widget.bloc.state.listen((event) {
      if (event.themes.isNotEmpty && _isFirstState && _selectedTheme == null) {
        setState(() {
          _selectedTheme = event.themes.first;
          _isFirstState = false;
        });
      }
      if (event.isSaved) {
        Navigator.of(context).pushReplacement(createRoute(MainPage()));
        if (widget.task == null) {
          Fluttertoast.showToast(msg: 'Successfully created task', timeInSecForIosWeb: 5);
        } else {
          Fluttertoast.showToast(msg: 'Successfully updated task', timeInSecForIosWeb: 5);
        }
      }

      if (event.addThemeSuccess != null && event.addThemeSuccess!) {
        Fluttertoast.showToast(msg: 'Successfully added theme', timeInSecForIosWeb: 5);
      } else if (event.addThemeSuccess != null && event.addThemeSuccess == false) {
        Fluttertoast.showToast(msg: 'Failed adding theme', timeInSecForIosWeb: 5, webBgColor: 'red');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: Center(
        heightFactor: 1.3,
        child: StreamBuilder<TaskCreationState>(
            stream: widget.bloc.state,
            initialData: widget.bloc.initial,
            builder: (context, snapshot) {
              final state = snapshot.data!;

              if (state.isFetching) return const Center(child: CircularProgressIndicator());

              return Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Card(
                    elevation: 6.0,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.task == null ? 'New exercise' : 'Update exercise',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select theme',
                                style: TextStyle(fontSize: 16.0, color: backgroundTextColor),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      child: DropdownButtonFormField(
                                        value: state.themes.first,
                                        onChanged: (value) {
                                          _selectedTheme = value as model.Theme;
                                        },
                                        items: state.themes
                                            .map((e) => DropdownMenuItem(
                                                  child: Container(
                                                      width: 100,
                                                      child: Text(
                                                        e.name,
                                                        overflow: TextOverflow.ellipsis,
                                                      )),
                                                  value: e,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30.0,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        alignment: Alignment.center,
                                        backgroundColor: MaterialStateProperty.all(headerColor),
                                      ),
                                      child: const Icon(Icons.add),
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
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Container(
                                width: 120,
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
                        const SizedBox(height: 30),
                        const Text(
                          'Enter description:',
                          style: TextStyle(fontSize: 16.0, color: backgroundTextColor),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 100,
                          child: TextFormField(
                            controller: _descriptionController,
                            validator: (value) {
                              return value.isNotBlank ? null : 'Please provide a description';
                            },
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            decoration: InputDecoration(
                              hintText: 'Enter description',
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
                        const SizedBox(height: 30),
                        const Text(
                          'Enter solution:',
                          style: TextStyle(fontSize: 16.0, color: backgroundTextColor),
                        ),
                        const SizedBox(height: 15),
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
                              hintText: 'Enter solution',
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
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            alignment: Alignment.bottomRight,
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
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: headerColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(createRoute(const MainPage()));
                                  },
                                ),
                                const SizedBox(
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
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      final task = LabTask(
                                          id: widget.task?.id ?? 0,
                                          description: _descriptionController.text,
                                          answer: _answerController.text,
                                          complexity: _selectedComplexity,
                                          themeId: _selectedTheme!.id,
                                          theme: _selectedTheme!);

                                      if (widget.task == null)
                                        widget.bloc.submitTask(task);
                                      else
                                        widget.bloc.updateTask(task);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
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

          return SimpleDialog(contentPadding: EdgeInsets.all(12.0), elevation: 6.0, children: [
            Container(
              height: 150,
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter theme name:',
                      style: TextStyle(fontSize: 16.0, color: backgroundTextColor),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: _themeFormKey,
                      child: TextFormField(
                        controller: _themeNameController,
                        decoration: const InputDecoration(hintText: 'Theme'),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
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
                          onPressed: () async {
                            if (_themeFormKey.currentState?.validate() ?? false) {
                              await widget.bloc.submitTheme(_themeNameController.text);

                              Navigator.of(context).pop();
                              widget.bloc.getThemes();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]);
        });
  }
}
