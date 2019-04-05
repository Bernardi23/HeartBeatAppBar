import 'package:flutter/material.dart';

// HeartBeatAppBar Component
import '../components/HeartBeatAppBar/heartBeatAppBar.dart';

class HeartBeatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: HeartBeatAppBar()),
    );
  }
}
