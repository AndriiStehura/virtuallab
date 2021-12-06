import 'package:flutter/material.dart';
import 'package:virtuallab/src/bloc/task_select_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';

class TaskSelectPage extends StatefulWidget {
  const TaskSelectPage({Key? key, required this.bloc}) : super(key: key);

  final TaskSelectBloc bloc;

  @override
  _TaskSelectPageState createState() => _TaskSelectPageState();
}

class _TaskSelectPageState extends State<TaskSelectPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.fetchThemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(),
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
            Divider(),
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
                        ? CircularProgressIndicator()
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
                                  onChanged: (value) {},
                                  items: state.themes
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.name),
                                            value: e,
                                          ))
                                      .toList(),
                                ),
                                SizedBox(height: 32.0),
                                const Text(
                                  'Choose complexity',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                DropdownButtonFormField(
                                  value: Complexity.easy,
                                  onChanged: (value) {},
                                  items: Complexity.values
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.string),
                                            value: e,
                                          ))
                                      .toList(),
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
