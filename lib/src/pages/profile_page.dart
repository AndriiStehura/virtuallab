import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuallab/src/bloc/admin_task_list_bloc.dart';
import 'package:virtuallab/src/bloc/profile_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/user/identity.dart';
import 'package:virtuallab/src/core/models/user/update_password.dart';
import 'package:virtuallab/src/core/models/user/update_user.dart';
import 'package:virtuallab/src/core/utils/string.dart';
import 'package:virtuallab/src/pages/admin_task_list_page.dart';
import 'package:virtuallab/src/pages/login_page.dart';
import 'package:virtuallab/src/pages/statistics_page.dart';
import 'package:virtuallab/src/pages/task_creation_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/service_locator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.bloc}) : super(key: key);

  final ProfileBloc bloc;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = widget.bloc.initial.user!;

    _firstnameController.text = user.firstName;
    _lastnameController.text = user.lastName;
    _loginController.text = user.email;

    widget.bloc.state.listen((event) async {
      if (event.isSaved) {
        Fluttertoast.showToast(msg: 'Saved changes');
      } else if (event.hasError) {
        Fluttertoast.showToast(msg: 'We\'ve encountered an error saving your data', webBgColor: 'red');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _firstnameField = Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        height: 45.0,
        child: TextFormField(
          controller: _firstnameController,
          validator: (value) {
            return value.isBlank ? 'Provide a valid first name' : null;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: headerColor.withOpacity(0.8), width: 1.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: headerColor, width: 1.0),
              ),
              label: Text('First name*')),
        ));
    final _lastnameField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _lastnameController,
          validator: (value) {
            return value.isBlank ? 'Provide a valid last name' : null;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: headerColor.withOpacity(0.8), width: 1.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: headerColor, width: 1.0),
              ),
              label: Text('Last name*')),
        ));
    final _loginField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _loginController,
          validator: (value) {
            return value.isBlank ? 'Provide a valid login' : null;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: headerColor.withOpacity(0.8), width: 1.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: headerColor, width: 1.0),
              ),
              label: Text('Email*')),
        ));
    final _passwordField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: headerColor.withOpacity(0.8), width: 1.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: headerColor, width: 1.0),
              ),
              label: Text('Password*')),
        ));
    final _confirmPasswordField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _confirmPasswordController,
          validator: (value) {
            return value == _passwordController.text ? null : 'Passwords do not match';
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: headerColor.withOpacity(0.8), width: 1.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: headerColor, width: 1.0),
              ),
              label: Text('Confirm Password*')),
        ));

    return Scaffold(
      appBar: getHeader(context),
      body: StreamBuilder<ProfileState>(
          stream: widget.bloc.state,
          initialData: widget.bloc.initial,
          builder: (context, snapshot) {
            final state = snapshot.data!;

            if (state.isFetching) return const Center(child: CircularProgressIndicator());

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
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
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 40,
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Profile',
                                        style: TextStyle(
                                            fontSize: 22.0, fontWeight: FontWeight.bold, color: backgroundTextColor),
                                      ),
                                    ),
                                    const VerticalDivider(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacement(createRoute(StatisticsPage(bloc: serviceLocator())));
                                      },
                                      child: const Text(
                                        'Statistics',
                                        style: TextStyle(
                                            fontSize: 22.0, fontWeight: FontWeight.normal, color: backgroundTextColor),
                                      ),
                                    ),
                                    Spacer(),
                                    if (state.user?.isAdmin ?? false)
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: ElevatedButton(
                                          child: const Text('Admin page'),
                                          style: ButtonStyle(
                                            fixedSize: MaterialStateProperty.all<Size>(const Size(150.0, 35.0)),
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushReplacement(createRoute(AdminTaskListPage(
                                              bloc: serviceLocator(),
                                            )));
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 32.0,
                              ),
                              Form(
                                key: _formKey,
                                child: Container(
                                  height: 200,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            _firstnameField,
                                            _lastnameField,
                                            _loginField,
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            _passwordField,
                                            _confirmPasswordField,
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 35.0,
                                  width: 150.0,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all<Size>(const Size(150.0, 35.0)),
                                      backgroundColor: MaterialStateProperty.all<Color>(headerColor),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                    child: const Text('Save'),
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        final oldData = widget.bloc.initial.user!;

                                        final user = UpdateUser(
                                          id: oldData.id,
                                          email: _loginController.text,
                                          firstName: _firstnameController.text,
                                          lastName: _lastnameController.text,
                                          group: '',
                                        );

                                        final password = _confirmPasswordController.text.isNotBlank
                                            ? UpdatePassword(
                                                userId: oldData.id, password: _confirmPasswordController.text)
                                            : null;

                                        widget.bloc.saveProfile(user, password);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Spacer(),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                      onPressed: () async {
                                        await widget.bloc.logOut();
                                        Navigator.of(context)
                                            .pushReplacement(createRoute(LoginPage(bloc: serviceLocator())));
                                      },
                                      icon: Icon(
                                        Icons.logout,
                                        color: headerColor,
                                      )))
                            ],
                          ),
                        )),
                  ),
                )
              ],
            );
          }),
    );
  }
}
