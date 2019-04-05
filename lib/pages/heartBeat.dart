import 'dart:math';

import 'package:flutter/material.dart';

/* TODO:
 * - Dot positioning not fully responsive to device's width
 * - Container still needs a gradient color
 * - Clicking container is currently small
 */

class HeartBeatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.pink[300],
            gradient: LinearGradient(colors: <Color>[
              Colors.pink[300].withOpacity(0.7),
              Colors.pink[300],
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.pink[300].withOpacity(0.4),
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: Offset(0, 5),
              )
            ],
          ),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 70.0,
          child: new HeartBeatAppBar(MediaQuery.of(context).size),
        ),
      ),
    );
  }
}

class HeartBeatAppBar extends StatefulWidget {
  final Size device;

  HeartBeatAppBar(this.device);

  @override
  _HeartBeatAppBarState createState() => _HeartBeatAppBarState();
}

class _HeartBeatAppBarState extends State<HeartBeatAppBar>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _activatingOpacity;
  Animation<double> _deactivatingOpacity;
  AnimationController _heartBeatController;
  Animation<double> _heartBeatAnimation;

  int _activated;
  int _nextActivated;

  List<double> _positions = [0, 35, 98, 166, 234];

  Opacity fadableIcon(IconData icon, int index) {
    if (index == _activated) {
      return Opacity(
        opacity: _deactivatingOpacity.value,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      );
    } else if (index == _nextActivated) {
      return Opacity(
        opacity: _activatingOpacity.value,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      );
    } else {
      return Opacity(
        opacity: 0.5,
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      );
    }
  }

  void _startAnimation(int newActivated) async {
    if (!_animationController.isAnimating && newActivated != _activated) {
      int animationDuration = 700 + ((newActivated - _activated).abs()) * 100;
      _animationController.duration = Duration(milliseconds: animationDuration);
      _heartBeatController.duration = Duration(milliseconds: animationDuration);

      setState(() {
        _nextActivated = newActivated;
      });

      _animationController.forward();
      _heartBeatController.forward();

      _heartBeatController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _activated = newActivated;
            _nextActivated = 0;
          });
          _heartBeatController.reset();
          _animationController.reset();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.device.width);
    _positions = [
      0,
      widget.device.width * 0.094,
      widget.device.width * 0.284,
      widget.device.width * 0.466,
      widget.device.width * 0.662,
    ];

    _activated = 1;
    _nextActivated = 0;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (1000 ~/ 2)),
    );

    _deactivatingOpacity = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          0.5,
          curve: Curves.easeIn,
        ),
      ),
    );

    _activatingOpacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.5,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    _heartBeatController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _heartBeatAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _heartBeatController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heartBeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size device = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTapUp: (details) {
                    _startAnimation(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: fadableIcon(
                      IconData(0xe879, fontFamily: 'Feather'),
                      1,
                    ),
                  ),
                ),
                GestureDetector(
                  onTapUp: (details) {
                    _startAnimation(2);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child:
                        fadableIcon(IconData(0xe8bd, fontFamily: 'Feather'), 2),
                  ),
                ),
                GestureDetector(
                  onTapUp: (details) {
                    _startAnimation(3);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child:
                        fadableIcon(IconData(0xe891, fontFamily: 'Feather'), 3),
                  ),
                ),
                GestureDetector(
                  onTapUp: (details) {
                    _startAnimation(4);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child:
                        fadableIcon(IconData(0xe905, fontFamily: 'Feather'), 4),
                  ),
                ),
              ],
            );
          },
        ),
        CustomPaint(
          size: Size(device.width, 6),
          painter: HeartBeatPainter(
            animation: _heartBeatAnimation,
            beginning: _positions[_activated],
            ending: _positions[_nextActivated],
          ),
        ),
      ],
    );
  }
}

class HeartBeatPainter extends CustomPainter {
  double beginning;
  double ending;
  Animation<double> animation;

  double lerp(double v0, double v1, double t) {
    return (1 - t) * v0 + t * v1;
  }

  double sigmoid(double x) {
    return 0.5 * (sin(x * pi - pi / 2) + 1);
  }

  double parabola(double x) {
    return pow(((cos(x) + 1) / 2), 10);
  }

  bool inversed;
  List<Offset> _points;
  Paint heartBeatPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 4.0;

  HeartBeatPainter({
    @required this.animation,
    @required this.beginning,
    @required this.ending,
  }) : super(repaint: animation) {
    inversed = ending < beginning;
    if (!inversed) {
      double startingPoint = ((ending + beginning).abs() / 2) - 15;
      var a = (startingPoint - beginning) * 0.1;
      var b = (ending - startingPoint - 30) * 0.1;
      _points = [
        Offset(beginning, 0),
        Offset(beginning + a * 0.1, 0),
        Offset(beginning + a * 0.2, 0),
        Offset(beginning + a * 0.3, 0),
        Offset(beginning + a * 0.4, 0),
        Offset(beginning + a * 0.5, 0),
        Offset(beginning + a * 0.6, 0),
        Offset(beginning + a * 0.7, 0),
        Offset(beginning + a * 0.8, 0),
        Offset(beginning + a * 0.9, 0),
        Offset(beginning + a * 1, 0),
        Offset(beginning + a * 1.5, 0),
        Offset(beginning + a * 2, 0),
        Offset(beginning + a * 2.5, 0),
        Offset(beginning + a * 3, 0),
        Offset(beginning + a * 3.5, 0),
        Offset(beginning + a * 4, 0),
        Offset(beginning + a * 4.5, 0),
        Offset(beginning + a * 5, 0),
        Offset(beginning + a * 5.5, 0),
        Offset(beginning + a * 6, 0),
        Offset(beginning + a * 6.5, 0),
        Offset(beginning + a * 7, 0),
        Offset(beginning + a * 7.5, 0),
        Offset(beginning + a * 8, 0),
        Offset(beginning + a * 8.5, 0),
        Offset(beginning + a * 9, 0),
        Offset(beginning + a * 9.5, 0),
        Offset(startingPoint, 0),
        Offset(startingPoint + 1.5, -1.5),
        Offset(startingPoint + 3, -3),
        Offset(startingPoint + 4.5, 1),
        Offset(startingPoint + 6, 5),
        Offset(startingPoint + 7.5, -7.5),
        Offset(startingPoint + 9, -10),
        Offset(startingPoint + 11, -1),
        Offset(startingPoint + 13, 8),
        Offset(startingPoint + 15, 2),
        Offset(startingPoint + 17, -4),
        Offset(startingPoint + 19, 0),
        Offset(startingPoint + 21, 4),
        Offset(startingPoint + 23, 0.5),
        Offset(startingPoint + 25, -3),
        Offset(startingPoint + 27.5, -1.5),
        Offset(startingPoint + 30, 0),
        Offset(startingPoint + 30 + b * 0.5, 0),
        Offset(startingPoint + 30 + b * 1, 0),
        Offset(startingPoint + 30 + b * 1.5, 0),
        Offset(startingPoint + 30 + b * 2, 0),
        Offset(startingPoint + 30 + b * 2.5, 0),
        Offset(startingPoint + 30 + b * 3, 0),
        Offset(startingPoint + 30 + b * 3.5, 0),
        Offset(startingPoint + 30 + b * 4, 0),
        Offset(startingPoint + 30 + b * 4.5, 0),
        Offset(startingPoint + 30 + b * 5, 0),
        Offset(startingPoint + 30 + b * 5.5, 0),
        Offset(startingPoint + 30 + b * 6, 0),
        Offset(startingPoint + 30 + b * 6.5, 0),
        Offset(startingPoint + 30 + b * 7, 0),
        Offset(startingPoint + 30 + b * 7.5, 0),
        Offset(startingPoint + 30 + b * 8, 0),
        Offset(startingPoint + 30 + b * 8.5, 0),
        Offset(startingPoint + 30 + b * 9, 0),
        Offset(startingPoint + 30 + b * 9.1, 0),
        Offset(startingPoint + 30 + b * 9.2, 0),
        Offset(startingPoint + 30 + b * 9.3, 0),
        Offset(startingPoint + 30 + b * 9.4, 0),
        Offset(startingPoint + 30 + b * 9.5, 0),
        Offset(startingPoint + 30 + b * 9.6, 0),
        Offset(startingPoint + 30 + b * 9.7, 0),
        Offset(startingPoint + 30 + b * 9.8, 0),
        Offset(startingPoint + 30 + b * 9.9, 0),
        Offset(ending, 0),
      ];
      heartBeatPaint.shader = LinearGradient(
        colors: <Color>[Colors.pink[300], Colors.white],
        stops: [0.0, 0.3],
      ).createShader(
        Rect.fromPoints(_points[0], _points[_points.length - 1]),
      );
    } else if (inversed) {
      double startingPoint = ((ending + beginning).abs() / 2) + 15;
      var a = (startingPoint - beginning) * 0.1;
      var b = (ending - startingPoint + 30) * 0.1;
      _points = [
        Offset(beginning, 0),
        Offset(beginning + a * 0.1, 0),
        Offset(beginning + a * 0.2, 0),
        Offset(beginning + a * 0.3, 0),
        Offset(beginning + a * 0.4, 0),
        Offset(beginning + a * 0.5, 0),
        Offset(beginning + a * 0.6, 0),
        Offset(beginning + a * 0.7, 0),
        Offset(beginning + a * 0.8, 0),
        Offset(beginning + a * 0.9, 0),
        Offset(beginning + a * 1, 0),
        Offset(beginning + a * 1.5, 0),
        Offset(beginning + a * 2, 0),
        Offset(beginning + a * 2.5, 0),
        Offset(beginning + a * 3, 0),
        Offset(beginning + a * 3.5, 0),
        Offset(beginning + a * 4, 0),
        Offset(beginning + a * 4.5, 0),
        Offset(beginning + a * 5, 0),
        Offset(beginning + a * 5.5, 0),
        Offset(beginning + a * 6, 0),
        Offset(beginning + a * 6.5, 0),
        Offset(beginning + a * 7, 0),
        Offset(beginning + a * 7.5, 0),
        Offset(beginning + a * 8, 0),
        Offset(beginning + a * 8.5, 0),
        Offset(beginning + a * 9, 0),
        Offset(beginning + a * 9.5, 0),
        Offset(startingPoint, 0),
        Offset(startingPoint - 1.5, -1.5),
        Offset(startingPoint - 3, -3),
        Offset(startingPoint - 4.5, 1),
        Offset(startingPoint - 6, 5),
        Offset(startingPoint - 7.5, -7.5),
        Offset(startingPoint - 9, -10),
        Offset(startingPoint - 11, -1),
        Offset(startingPoint - 13, 8),
        Offset(startingPoint - 15, 2),
        Offset(startingPoint - 17, -4),
        Offset(startingPoint - 19, 0),
        Offset(startingPoint - 21, 4),
        Offset(startingPoint - 23, 0.5),
        Offset(startingPoint - 25, -3),
        Offset(startingPoint - 27.5, -1.5),
        Offset(startingPoint - 30, 0),
        Offset(startingPoint - 30 + b * 0.5, 0),
        Offset(startingPoint - 30 + b * 1, 0),
        Offset(startingPoint - 30 + b * 1.5, 0),
        Offset(startingPoint - 30 + b * 2, 0),
        Offset(startingPoint - 30 + b * 2.5, 0),
        Offset(startingPoint - 30 + b * 3, 0),
        Offset(startingPoint - 30 + b * 3.5, 0),
        Offset(startingPoint - 30 + b * 4, 0),
        Offset(startingPoint - 30 + b * 4.5, 0),
        Offset(startingPoint - 30 + b * 5, 0),
        Offset(startingPoint - 30 + b * 5.5, 0),
        Offset(startingPoint - 30 + b * 6, 0),
        Offset(startingPoint - 30 + b * 6.5, 0),
        Offset(startingPoint - 30 + b * 7, 0),
        Offset(startingPoint - 30 + b * 7.5, 0),
        Offset(startingPoint - 30 + b * 8, 0),
        Offset(startingPoint - 30 + b * 8.5, 0),
        Offset(startingPoint - 30 + b * 9, 0),
        Offset(startingPoint - 30 + b * 9.1, 0),
        Offset(startingPoint - 30 + b * 9.2, 0),
        Offset(startingPoint - 30 + b * 9.3, 0),
        Offset(startingPoint - 30 + b * 9.4, 0),
        Offset(startingPoint - 30 + b * 9.5, 0),
        Offset(startingPoint - 30 + b * 9.6, 0),
        Offset(startingPoint - 30 + b * 9.7, 0),
        Offset(startingPoint - 30 + b * 9.8, 0),
        Offset(startingPoint - 30 + b * 9.9, 0),
      ];
      heartBeatPaint.shader = LinearGradient(
        colors: <Color>[Colors.white, Colors.pink[300]],
        stops: [0.7, 1.0],
      ).createShader(
        Rect.fromPoints(_points[0], _points[_points.length - 1]),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double percentage = _points.length * animation.value;

    int start =
        lerp(0, percentage, pow(sigmoid(pow(animation.value, 5)), 1)).floor();

    Path heartBeatPath = Path()..moveTo(_points[start].dx, 0);
    for (int i = start + 1; i < (percentage).round(); i++) {
      heartBeatPath.lineTo(_points[i].dx, _points[i].dy);
    }

    canvas.drawPath(heartBeatPath, heartBeatPaint);

    canvas.drawCircle(
      !inversed
          ? Offset(
              heartBeatPath.getBounds().centerRight.dx,
              heartBeatPath.getBounds().centerRight.dy,
            )
          : Offset(
              heartBeatPath.getBounds().centerLeft.dx,
              heartBeatPath.getBounds().centerRight.dy,
            ),
      4 * parabola(animation.value * 2 * pi),
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(HeartBeatPainter oldDelegate) {
    return false;
  }
}
