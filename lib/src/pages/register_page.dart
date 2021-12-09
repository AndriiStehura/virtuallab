import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuallab/src/bloc/auth_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/pages/login_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/core/utils/string.dart';
import 'package:virtuallab/src/service_locator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.bloc}) : super(key: key);

  final SignUpBloc bloc;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    widget.bloc.state.listen((event) async {
      if (event.isSingedUp) {
        Navigator.of(context).pushReplacement(createRoute(LoginPage(bloc: serviceLocator())));
        Fluttertoast.showToast(msg: 'Login using your credentials');
      } else if (event.hasError) {
        Fluttertoast.showToast(msg: 'Invalid login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(
          child: Container(
            color: headerColor,
            child: const Center(
                child: Icon(
              Icons.lock_clock,
              size: 50,
            )),
          ),
        ),
        Flexible(
          child: StreamBuilder<SignUpState>(
              stream: widget.bloc.state,
              initialData: widget.bloc.initial,
              builder: (context, snapshot) {
                final state = snapshot.data!;

                const header = Text('Sign up', style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold));

                final _firstnameField = Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _firstnameController,
                      validator: (value) {
                        return value.isBlank ? 'Provide a valid first name' : null;
                      },
                      decoration: const InputDecoration(label: Text('First name*')),
                    ));
                final _lastnameField = Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _lastnameController,
                      validator: (value) {
                        return value.isBlank ? 'Provide a valid last name' : null;
                      },
                      decoration: const InputDecoration(label: Text('Last name*')),
                    ));
                final _emailField = Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        return value.isBlank ? 'Provide a valid email name' : null;
                      },
                      decoration: const InputDecoration(label: Text('Email*')),
                    ));
                final _passwordField = Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(label: Text('Password*')),
                      validator: (value) {
                        return value.isBlank ? 'Provide a valid password' : null;
                      },
                    ));
                final _confirmPasswordField = Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      validator: (value) {
                        return value.isBlank
                            ? 'Please confirm a password'
                            : value == _passwordController.text
                                ? null
                                : 'Passwords do not match';
                      },
                      decoration: const InputDecoration(label: Text('Confirm Password*')),
                    ));

                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state.isWaiting)
                        IgnorePointer(
                          child: ColoredBox(
                            color: Colors.grey.withOpacity(0.3),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        padding: const EdgeInsets.all(32.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              header,
                              const SizedBox(
                                height: 30,
                              ),
                              _firstnameField,
                              _lastnameField,
                              _emailField,
                              _passwordField,
                              _confirmPasswordField,
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Hero(
                                  tag: 'oleg',
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        widget.bloc.trySignUp(
                                          _firstnameController.text,
                                          _lastnameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                          _confirmPasswordController.text,
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(headerColor),
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
                              const SizedBox(
                                height: 25,
                              ),
                              RichText(
                                  text: TextSpan(text: 'Already have an account?', children: [
                                TextSpan(
                                    text: ' Log in here',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushReplacement(createRoute(LoginPage(bloc: serviceLocator())));
                                      }),
                              ]))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    ));
  }
}
