import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuallab/src/bloc/profile_bloc.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/core/models/user/identity.dart';
import 'package:virtuallab/src/core/models/user/user.dart';
import 'package:virtuallab/src/core/utils/string.dart';

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
    // TODO: implement initState
    super.initState();
    final user = widget.bloc.initial.user!;

    _firstnameController.text = user.firstName;
    _lastnameController.text = user.lastName;
    _loginController.text = user.email;

    widget.bloc.state.listen((event) async {
      if (event.isSaved) {
        Fluttertoast.showToast(msg: 'Saved changes');
      } else if (event.hasError) {
        Fluttertoast.showToast(msg: 'We\'ve encountered an error saving your data');
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
          decoration: const InputDecoration(label: Text('First name*')),
        ));
    final _lastnameField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _lastnameController,
          validator: (value) {
            return value.isBlank ? 'Provide a valid last name' : null;
          },
          decoration: const InputDecoration(label: Text('Last name*')),
        ));
    final _loginField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _loginController,
          validator: (value) {
            return value.isBlank ? 'Provide a valid login' : null;
          },
          decoration: const InputDecoration(label: Text('Email*')),
        ));
    final _passwordField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(label: Text('Password*')),
        ));
    final _confirmPasswordField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: _confirmPasswordController,
          validator: (value) {
            return value == _passwordController.text ? null : 'Passwords do not match';
          },
          decoration: const InputDecoration(label: Text('Confirm Password*')),
        ));

    return Scaffold(
      appBar: getHeader(context),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Profile',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              //  VerticalDivider(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Statistics',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Card(
                child: StreamBuilder<ProfileState>(
                    stream: widget.bloc.state,
                    initialData: widget.bloc.initial,
                    builder: (context, snapshot) {
                      final state = snapshot.data!;

                      if (state.isFetching) return const CircularProgressIndicator();

                      return Column(
                        children: [
                          if (state.user?.isAdmin ?? false)
                            Container(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                child: Text('Admin page'),
                                onPressed: () {},
                              ),
                            ),
                          Form(
                            key: _formKey,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      _firstnameField,
                                      _lastnameField,
                                      _loginField,
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50.0,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _passwordField,
                                      _confirmPasswordField,
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: ElevatedButton(
                              child: Text('Save'),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final oldData = widget.bloc.initial.user!;

                                  final user = oldData.copyWith(
                                    email: _loginController.text,
                                    firstName: _firstnameController.text,
                                    lastName: _lastnameController.text,
                                    group: '',
                                    identity: _passwordController.text.isBlank
                                        ? Identity(id: 0, passwordHash: _passwordController.text)
                                        : null,
                                    isAdmin: false,
                                  );

                                  widget.bloc.saveProfile(user);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
