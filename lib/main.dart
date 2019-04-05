import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/services.dart';

// Animated AppBar
import 'pages/appBar.dart';
import 'components/AnimatedAppBar/controller.dart';

// Heart Beat AppBar
import 'pages/heartBeat.dart';

void main() => runApp(AnimatedAppBarApp());

class AnimatedAppBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Google Sans'),
      home: BlocProvider<AnimatedAppBarController>(
        child: HeartBeatPage(),
        bloc: AnimatedAppBarController(),
      ),
    );
  }
}
