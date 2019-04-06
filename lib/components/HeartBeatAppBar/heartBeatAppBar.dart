import 'package:flutter/material.dart';

// HeartBeat Painter
import 'heartBeatPainter.dart';

class HeartBeatAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
      child: new HeartBeatAppBarContent(MediaQuery.of(context).size),
    );
  }
}

class HeartBeatAppBarContent extends StatefulWidget {
  final Size device;

  HeartBeatAppBarContent(this.device);

  @override
  _HeartBeatAppBarContentState createState() => _HeartBeatAppBarContentState();
}

class _HeartBeatAppBarContentState extends State<HeartBeatAppBarContent>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _activatingOpacity;
  Animation<double> _deactivatingOpacity;
  Animation<double> _heartBeatAnimation;

  int _activated;
  int _nextActivated;

  List<double> _positions = [0, 0, 0, 0, 0];

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

  void _startAnimation(int newActivated) {
    if (!_animationController.isAnimating && newActivated != _activated) {
      int animationDuration = 700 + ((newActivated - _activated).abs()) * 100;
      _animationController.duration = Duration(milliseconds: animationDuration);

      setState(() {
        _nextActivated = newActivated;
      });

      _animationController.forward();

      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _activated = newActivated;
            _nextActivated = 0;
          });
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

    _heartBeatAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
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
