import 'package:flutter/material.dart';

class NumbersList extends StatelessWidget {
  final List<String> emotions = [
    "Happy",
    "Sad",
    "Confident",
    "Focused",
    "Funny",
    "Sick",
    "Relaxed",
    "Sleepy",
    "Mad",
    "Lazy",
    "Tired",
    "Emotional",
    "Relaxed",
    "Sleepy",
    "Mad",
    "Lazy",
    "Sad",
    "Emotional",
    "Relaxed",
    "Mad",
    "Lazy",
    "Tired",
    "Emotional",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
      padding:
          const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
      child: Center(
        child: GridView.builder(
          itemCount: emotions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 20.0, mainAxisSpacing: 20.0),
          itemBuilder: (context, index) {
            return GridTile(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: <Color>[
                      Colors.cyan[100],
                      Colors.cyan[200],
                    ],
                  ),
                ),
                child: Text(
                  emotions[index],
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
