import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:virtuallab/src/bloc/auth_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/pages/login_page.dart';
import 'package:virtuallab/src/pages/transition.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: getHeader(),
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

                const header = Text(
                  'Sign up',
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                );

                final _firstnameField = Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    height: 45.0,
                    child: TextField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        label: const Text('First name*'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: state.isFirstnameValid ? const BorderSide() : const BorderSide(color: Colors.red),
                        ),
                      ),
                    ));
                final _lastnameField = Container(
                    height: 45.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _lastnameController,
                      decoration: InputDecoration(
                        label: const Text('Last name*'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: state.isLastnameValid ? const BorderSide() : const BorderSide(color: Colors.red),
                        ),
                      ),
                    ));
                final _emailField = Container(
                    height: 45.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: const Text('Email*'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: state.isEmailValid ? const BorderSide() : const BorderSide(color: Colors.red),
                        ),
                      ),
                    ));
                final _passwordField = Container(
                    height: 45.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        label: const Text('Password*'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: state.isPasswordValid ? const BorderSide() : const BorderSide(color: Colors.red),
                        ),
                      ),
                    ));
                final _confirmPasswordField = Container(
                    height: 45.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        label: const Text('Confirm Password*'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              state.isConfirmPasswordValid ? const BorderSide() : const BorderSide(color: Colors.red),
                        ),
                      ),
                    ));

                return Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(32.0),
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
                          height: 45.0,
                          width: double.infinity,
                          child: Hero(
                            tag: 'oleg',
                            child: ElevatedButton(
                              onPressed: () {
                                widget.bloc.trySignUp(
                                  _firstnameController.text,
                                  _lastnameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _confirmPasswordController.text,
                                );
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
                                  Navigator.of(context).pushReplacement(createRoute(const LoginPage()));
                                }),
                        ]))
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    ));
  }
}
