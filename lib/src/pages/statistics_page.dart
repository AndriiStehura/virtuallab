// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

    widget.bloc.state.listen((event) async {
      if (event.hasError) {
        Fluttertoast.showToast(msg: 'We\'ve encountered an error saving your data');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(context),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: backgroundTextColor),
                    ),
                  ),
                  const VerticalDivider(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Statistics',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: backgroundTextColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                  child: StreamBuilder<StatisticsState>(
                      stream: widget.bloc.state,
                      initialData: widget.bloc.initial,
                      builder: (context, snapshot) {
                        final state = snapshot.data!;
                        if (state.isFetching) return const CircularProgressIndicator();
                        if (state.stats == null || (state.stats?.isEmpty ?? false)) {
                          return const Center(
                            child: Text('No data found'),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Table(
                            children: [
                              ...state.stats!
                                  .map((stat) => TableRow(children: [
                                        Text(stat.task.description),
                                        Text(stat.task.theme.name),
                                        Text(stat.task.complexity.string),
                                        Text('${stat.grade}'),
                                      ]))
                                  .toList()
                            ],
                          ),
                        );
                      }),
                )),
          ],
        ),
      ),
    );
  }
}
