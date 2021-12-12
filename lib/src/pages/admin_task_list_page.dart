import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuallab/src/bloc/admin_task_list_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/pages/task_creation_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/service_locator.dart';
import 'package:virtuallab/src/core/models/task/theme.dart' as model;

class AdminTaskListPage extends StatefulWidget {
  const AdminTaskListPage({Key? key, required this.bloc}) : super(key: key);

  final AdminTaskListBloc bloc;

  @override
  _AdminTaskListPageState createState() => _AdminTaskListPageState();
}

class _AdminTaskListPageState extends State<AdminTaskListPage> {
  model.Theme? _selectedTheme;
  Complexity? _selectedComplexity;

  bool isFirstState = true;

  @override
  void initState() {
    super.initState();
    widget.bloc.getData();

    widget.bloc.state.listen((event) {
      if (event.hasError) {
        Fluttertoast.showToast(msg: 'Some error occured', webBgColor: 'red');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: StreamBuilder<AdminTaskListState>(
          stream: widget.bloc.state,
          initialData: widget.bloc.initial,
          builder: (context, snapshot) {
            final state = snapshot.data!;

            if (state.isFetching) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 100,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Card(
                      elevation: 6.0,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: const Text(
                                    'All exercises',
                                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(const Size(30, 30)),
                                    alignment: Alignment.center,
                                    backgroundColor: MaterialStateProperty.all(headerColor),
                                  ),
                                  child: const Icon(Icons.add),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacement(createRoute(TaskCreationPage(bloc: serviceLocator())));
                                  },
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Choose theme',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: DropdownButtonFormField<model.Theme?>(
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedTheme = value;
                                          });
                                        },
                                        items: [
                                          const DropdownMenuItem(
                                            child: SizedBox(
                                              width: 100,
                                              child: Text('All', overflow: TextOverflow.ellipsis),
                                            ),
                                            value: null,
                                          ),
                                          ...state.themes!
                                              .map((e) => DropdownMenuItem(
                                                    child: SizedBox(
                                                      width: 175,
                                                      child: Text(
                                                        e.name,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    value: e,
                                                  ))
                                              .toList()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Choose complexity',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    Container(
                                      width: 130,
                                      child: DropdownButtonFormField<Complexity?>(
                                          value: _selectedComplexity,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedComplexity = value;
                                            });
                                          },
                                          items: [
                                            const DropdownMenuItem(
                                              child: SizedBox(
                                                width: 100,
                                                child: Text('All', overflow: TextOverflow.ellipsis),
                                              ),
                                              value: null,
                                            ),
                                            ...Complexity.values
                                                .map((e) => DropdownMenuItem(
                                                      child: SizedBox(
                                                        width: 100,
                                                        child: Text(e.string, overflow: TextOverflow.ellipsis),
                                                      ),
                                                      value: e,
                                                    ))
                                                .toList(),
                                          ]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: SingleChildScrollView(
                                child: Table(
                                  children: [
                                    const TableRow(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: headerColor, width: 1.0),
                                          ),
                                        ),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Task',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: headerColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Theme',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: headerColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Complexity',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: headerColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                            child: Text(
                                              'Actions',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: headerColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: SizedBox(
                                                width: 50,
                                              )),
                                        ]),
                                    ...state.tasks!
                                        .where((element) => _selectedTheme == null || element.theme == _selectedTheme)
                                        .where((element) =>
                                            _selectedComplexity == null || element.complexity == _selectedComplexity)
                                        .map((task) => TableRow(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(color: headerColor, width: 0.5),
                                                  ),
                                                ),
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Text(
                                                      'Exercise #${task.id}',
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: headerColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Text(
                                                      task.theme!.name,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: headerColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Text(
                                                      task.complexity.string,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: headerColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                                    child: ElevatedButton(
                                                      child: const Text('Edit'),
                                                      style: ButtonStyle(
                                                        fixedSize:
                                                            MaterialStateProperty.all<Size>(const Size(50.0, 35.0)),
                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pushReplacement(createRoute(
                                                            TaskCreationPage(bloc: serviceLocator(), task: task)));
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                                    child: ElevatedButton(
                                                      child: const Text('Delete'),
                                                      style: ButtonStyle(
                                                        fixedSize:
                                                            MaterialStateProperty.all<Size>(const Size(50.0, 35.0)),
                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        widget.bloc.deleteTask(task);
                                                      },
                                                    ),
                                                  ),
                                                ]))
                                        .toList()
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
