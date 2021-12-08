import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuallab/src/bloc/auth_bloc.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/pages/register_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/service_locator.dart';
import 'package:virtuallab/src/core/utils/string.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.bloc}) : super(key: key);

  final SignUpBloc bloc;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    widget.bloc.state.listen((event) async {
      if (event.isSingedUp) {
        Navigator.of(context).pushReplacement(createRoute(const MainPage()));
      } else if (event.hasError) {
        Fluttertoast.showToast(msg: 'Invalid login');
      }
    });

    widget.bloc.tryAutologin();
  }

  @override
  Widget build(BuildContext context) {
    const header = Text(
      'Sign in',
      style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
    );

    final _emailField = SizedBox(
        height: 45.0,
        child: TextFormField(
          controller: _emailController,
          validator: (value) {
            return value.isBlank ? 'Provide a valid email name' : null;
          },
          decoration: InputDecoration(
            label: const Text('Email'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ));
    final _passwordField = Container(
        height: 45.0,
        margin: const EdgeInsets.symmetric(vertical: 24.0),
        child: TextFormField(
          controller: _passwordController,
          validator: (value) {
            return value.isBlank ? 'Provide a valid password' : null;
          },
          decoration: InputDecoration(
            label: const Text('Password'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ));

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
        StreamBuilder<SignUpState>(
            stream: widget.bloc.state,
            initialData: widget.bloc.initial,
            builder: (context, snapshot) {
              final state = snapshot.data!;

              return Flexible(
                child: Center(
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
                              _emailField,
                              _passwordField,
                              SizedBox(
                                height: 45.0,
                                width: double.infinity,
                                child: Hero(
                                  tag: 'oleg',
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        widget.bloc.tryLogin(_emailController.text, _passwordController.text);
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
                                      'Login',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              RichText(
                                  text: TextSpan(text: 'Don’t have an account yet?', children: [
                                TextSpan(
                                    text: ' Register here',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).pushReplacement(createRoute(RegisterPage(
                                          bloc: serviceLocator(),
                                        )));
                                      }),
                              ]))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ],
    ));
  }
}
