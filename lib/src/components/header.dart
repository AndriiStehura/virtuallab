import 'package:flutter/material.dart';
import 'package:virtuallab/src/colors.dart';
import 'package:virtuallab/src/pages/main_page.dart';
import 'package:virtuallab/src/pages/profile_page.dart';
import 'package:virtuallab/src/pages/transition.dart';
import 'package:virtuallab/src/service_locator.dart';

TextStyle get buttonStyle => const TextStyle(fontSize: 16, color: Colors.white70);

AppBar getHeader(BuildContext context) => AppBar(
      backgroundColor: headerColor,
      leading: Center(
        child: SizedBox(
          child: Image.asset(
            'res/white_logo.png',
            height: 40,
            width: 40,
            scale: 0.5,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(createRoute(const MainPage()));
          },
          child: Text('Home', style: buttonStyle),
        ),
        TextButton(
          onPressed: () {},
          child: Text('About', style: buttonStyle),
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(createRoute(ProfilePage(bloc: serviceLocator())));
            },
            icon: const Icon(Icons.person)),
      ],
    );
