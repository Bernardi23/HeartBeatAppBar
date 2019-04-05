import 'package:flutter/material.dart';
import 'controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class AnimatedAppBar extends StatefulWidget {
  final Size device;

  AnimatedAppBar(this.device);

  @override
  _AnimatedAppBarState createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _navOpacity;
  Animation<double> _addOpacity;
  Animation<double> _xPosition;
  Animation<double> _borderRadius;
  Animation<double> _width;
  Animation<Color> _color;
  // ColorTween _color;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );

    _navOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.0,
            0.1,
            curve: Curves.easeOut,
          ),
          reverseCurve: Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    _addOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.5,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _xPosition =
        Tween<double>(begin: widget.device.width * 0.1, end: 20).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInBack),
    );

    _borderRadius = Tween<double>(begin: 10.0, end: 30.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _width = Tween<double>(begin: widget.device.width * 0.8, end: 60.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCirc,
      ),
    );

    _color = ColorTween(begin: Colors.white, end: Colors.pink[300]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(.0, .7, curve: Curves.easeOut),
        reverseCurve: Interval(.7, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AnimatedAppBarController bloc =
        BlocProvider.of<AnimatedAppBarController>(context);

    return StreamBuilder<Object>(
        stream: bloc.outScroll,
        initialData: true,
        builder: (context, isScrollingUp) {
          if (isScrollingUp.data) {
            _animationController.reverse();
          } else if (!isScrollingUp.data) {
            _animationController.forward();
          }
          return AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget child) {
              return Transform.translate(
                offset: Offset(_xPosition.value, widget.device.height - 75),
                child: Container(
                  decoration: BoxDecoration(
                    color: _color.value,
                    borderRadius: BorderRadius.circular(_borderRadius.value),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.blue[900].withOpacity(0.07),
                        blurRadius: 100.0,
                      )
                    ],
                  ),
                  width: _width.value,
                  height: 60,
                  child: Stack(
                    children: <Widget>[
                      navItems(),
                      plusItem(),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Opacity plusItem() {
    return Opacity(
      opacity: _addOpacity.value,
      child: Center(
        child: IconButton(
          icon: Icon(Icons.add),
          color: Colors.white,
          onPressed: () => null,
        ),
      ),
    );
  }

  Opacity navItems() {
    return Opacity(
      opacity: _navOpacity.value,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            color: Colors.pink[300],
            onPressed:
                _navOpacity.value == 1.0 ? () => print("hi") : () => null,
          ),
          IconButton(
            icon: Icon(Icons.hotel),
            color: Colors.pink[300],
            onPressed: () => null,
          ),
          IconButton(
            icon: Icon(Icons.hourglass_empty),
            color: Colors.pink[300],
            onPressed: () => null,
          ),
          IconButton(
            icon: Icon(Icons.import_contacts),
            color: Colors.pink[300],
            onPressed: () => null,
          ),
        ],
      ),
    );
  }
}
