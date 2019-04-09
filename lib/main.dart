import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Heart Beat Page
import 'pages/heartBeatPage.dart';

void main() => runApp(AnimatedAppBarApp());

class AnimatedAppBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set Status bar transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeartBeatPage(from: 1, to: 1, body: HeartBeatPage.defaultPages[1]),
    );
  }
}
