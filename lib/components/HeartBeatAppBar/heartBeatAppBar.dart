import 'package:flutter/material.dart';

// HeartBeat Painter
import 'heartBeatPainter.dart';
import '../../pages/heartBeatPage.dart';

class HeartBeatAppBar extends StatelessWidget {
  final int from, to;

  HeartBeatAppBar({this.from, @required this.to});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Colors.pink[200],
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
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, 0, MediaQuery.of(context).size.width * 0.1, 15),
      height: 70.0,
      child: new HeartBeatAppBarContent(
        MediaQuery.of(context).size,
        from: this.from == null ? this.to : this.from,
        to: to,
      ),
    );
  }
}

class HeartBeatAppBarContent extends StatefulWidget {
  final Size device;
  // Starting Activated Icon
  final int from;
  // Icon that the Strating Activated Icon will be animated to
  final int to;

  HeartBeatAppBarContent(this.device, {@required this.from, this.to});

  @override
  _HeartBeatAppBarContentState createState() => _HeartBeatAppBarContentState();
}

class _HeartBeatAppBarContentState extends State<HeartBeatAppBarContent> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _activatingOpacity;
  Animation<double> _deactivatingOpacity;
  Animation<double> _heartBeatAnimation;

  int _activated;
  int _nextActivated;

  List<double> _positions = [0, 0, 0, 0, 0];

  Opacity fadableIcon(final IconData icon, final int index) {
    // Will animate the opacity from 1.0 to 0.5
    if (index == _activated)
      return Opacity(
        opacity: _deactivatingOpacity.value,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      );

    // Will animate the opacity from 0.5 to 1.0
    if (index == _nextActivated)
      return Opacity(
        opacity: _activatingOpacity.value,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      );

    // Default returns the icon with opacity 0.5
    return Opacity(
      opacity: 0.5,
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  void _startAnimation(int newActivated) {
    if (!_animationController.isAnimating && newActivated != _activated) {
      // Calculates new animation duration depending on how distant the 2 icons are
      // from each other
      int animationDuration = 700 + ((newActivated - _activated).abs()) * 100;

      _animationController.duration = Duration(milliseconds: animationDuration);

      setState(() => _nextActivated = newActivated);

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

  navigateToScreen(
    BuildContext context, {
    int from,
    @required int to,
    Widget nextPageBody,
  }) async {
    await Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (context, _, __) => HeartBeatPage(body: nextPageBody, from: from, to: to)),
    );

    // In case the page gets popped, this will allow the animation to happen backwards.
    setState(() {
      _activated = to;
    });
    _startAnimation(widget.to);
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

    _activated = widget.from;
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

    _heartBeatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (!(widget.from == null)) {
      _startAnimation(widget.to);
    }
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
          builder: (BuildContext context, Widget child) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTapUp: (details) {
                    navigateToScreen(context, from: _activated, to: 1, nextPageBody: HeartBeatPage.defaultPages[1]);
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
                    navigateToScreen(context, from: _activated, to: 2, nextPageBody: HeartBeatPage.defaultPages[2]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: fadableIcon(
                      IconData(0xe8bd, fontFamily: 'Feather'),
                      2,
                    ),
                  ),
                ),
                GestureDetector(
                  onTapUp: (details) {
                    navigateToScreen(context, from: _activated, to: 3, nextPageBody: HeartBeatPage.defaultPages[3]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: fadableIcon(
                      IconData(0xe891, fontFamily: 'Feather'),
                      3,
                    ),
                  ),
                ),
                GestureDetector(
                  onTapUp: (details) {
                    navigateToScreen(context, from: _activated, to: 4, nextPageBody: HeartBeatPage.defaultPages[4]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: fadableIcon(
                      IconData(0xe905, fontFamily: 'Feather'),
                      4,
                    ),
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
