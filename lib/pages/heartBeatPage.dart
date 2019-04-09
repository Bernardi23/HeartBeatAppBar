import 'package:flutter/material.dart';

// HeartBeatAppBar Component
import '../components/HeartBeatAppBar/heartBeatAppBar.dart';

class HeartBeatPage extends StatelessWidget {
  static List<Widget> defaultPages = [
    Container(),
    Center(
        child: Text(
      "Heart page",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    )),
    Center(
        child: Text(
      "Search page",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    )),
    Center(
        child: Text(
      "Chat page",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    )),
    Center(
        child: Text(
      "Cart page",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    )),
  ];

  /// Defines the body of the HeartBeatPage. In cases where it's null, it'll return a
  /// centered text saying the current activated icon. This is necessary so we can have
  /// the HeartBeatAppBar in all HeartBeatPages, and the animation in page transitions
  /// can happen.
  final Widget body;

  /// Allow animations in between pages.
  /// The { from } property represents the icon that was activated before. The { to }
  /// property is the icon that'll be activated after the animation. Therefore if the
  /// user clicks is in a page where icon 2 is selected and icon 1 gets clicked, th
  /// { from } would be 2, and { to } would be 1, and the animation would happen.
  final int from, to;

  HeartBeatPage({this.from, @required this.to, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: HeartBeatAppBar(
        from: from == null ? this.to : from,
        to: to,
      ),
      extendBody: true,
      body: (body == null) ? HeartBeatPage.defaultPages[to] : body,
    );
  }
}
