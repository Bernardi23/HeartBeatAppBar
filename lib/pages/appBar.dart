import 'package:flutter/material.dart';

import '../components/AnimatedAppBar/controller.dart';
import '../components/AnimatedAppBar/widget.dart';
import '../components/NumbersList.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

class AppBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AnimatedAppBarController bloc =
        BlocProvider.of<AnimatedAppBarController>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NotificationListener(
            child: NumbersList(),
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                if (notification.scrollDelta <= -15) {
                  bloc.inScroll.add(true);
                } else if (notification.scrollDelta >= 15) {
                  bloc.inScroll.add(false);
                }
              }
            },
          ),
          AnimatedAppBar(MediaQuery.of(context).size)
        ],
      ),
    );
  }
}
