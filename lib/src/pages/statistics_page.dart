// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:virtuallab/src/bloc/statistics_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/pages/profile_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/service_locator.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key, required this.bloc}) : super(key: key);

  final StatisticsBloc bloc;

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.fetchStatistics();
    widget.bloc.state.listen((event) async {
      if (event.hasError) {
        Fluttertoast.showToast(msg: 'We\'ve encountered an error saving your data', webBgColor: 'red');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: StreamBuilder<StatisticsState>(
          stream: widget.bloc.state,
          initialData: widget.bloc.initial,
          builder: (context, snapshot) {
            final state = snapshot.data!;
            if (state.isFetching) return const Center(child: CircularProgressIndicator());

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                        elevation: 6.0,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 32.0, left: 32.0, right: 32.0, top: 32.0),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 40,
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(createRoute(ProfilePage(
                                          bloc: serviceLocator(),
                                        )));
                                      },
                                      child: const Text(
                                        'Profile',
                                        style: TextStyle(
                                            fontSize: 22.0, fontWeight: FontWeight.normal, color: backgroundTextColor),
                                      ),
                                    ),
                                    const VerticalDivider(),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Statistics',
                                        style: TextStyle(
                                            fontSize: 22.0, fontWeight: FontWeight.bold, color: backgroundTextColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: state.stats == null || (state.stats?.isEmpty ?? false)
                                    ? Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.search_off,
                                                color: headerColor,
                                                size: 100,
                                              ),
                                              Text(
                                                'No data found',
                                                style: TextStyle(fontSize: 22.0, color: headerColor),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : SingleChildScrollView(
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
                                                        fontSize: 16.0,
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
                                                    padding: EdgeInsets.all(16.0),
                                                    child: Text(
                                                      'Grade',
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
                                                      'Date',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: headerColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                            ...state.stats!
                                                .map((stat) => TableRow(
                                                        decoration: const BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(color: headerColor, width: 0.5),
                                                          ),
                                                        ),
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: Text(
                                                              stat.task.description,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: headerColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: Text(
                                                              stat.task.theme!.name,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: headerColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: Text(
                                                              stat.task.complexity.string,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: headerColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: Text(
                                                              '${stat.grade.ceil()}%',
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: headerColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: Text(
                                                              '${DateFormat.yMd().add_jm().format(stat.date)}',
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: headerColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ]))
                                                .toList()
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            );
          }),
    );
  }
}
