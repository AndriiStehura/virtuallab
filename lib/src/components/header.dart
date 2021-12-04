import 'package:flutter/material.dart';
import 'package:virtuallab/src/colors.dart';

TextStyle get buttonStyle => TextStyle(fontSize: 14, color: Colors.white70);

AppBar getHeader() => AppBar(
      backgroundColor: headerColor,
      leading: const Icon(Icons.lock_clock),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text('Home', style: buttonStyle),
        ),
        TextButton(
          onPressed: () {},
          child: Text('About', style: buttonStyle),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.person)),
      ],
    );
