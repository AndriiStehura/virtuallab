import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/components/header.dart';
import 'package:virtuallab/src/pages/register_page.dart';
import 'package:virtuallab/src/pages/transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
          decoration: InputDecoration(
            label: const Text('Password'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ));

    return Scaffold(
        appBar: getHeader(),
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
              child: Center(
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
                      _emailField,
                      _passwordField,
                      Container(
                        height: 45.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
                                Navigator.of(context).pushReplacement(createRoute(const RegisterPage()));
                              }),
                      ]))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
