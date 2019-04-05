import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Heart Beat Page
import 'pages/heartBeatPage.dart';

void main() => runApp(AnimatedAppBarApp());

class AnimatedAppBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeartBeatPage(),
    );
  }
}
