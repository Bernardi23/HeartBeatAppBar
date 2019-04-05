# Heartbeat AppBar

![Animation](https://media.giphy.com/media/mBpFNS1Acie7q4f0AF/giphy.gif)

This is a flutter app that utilizies its animation and painting API to make a very modern, smooth, animation. This was a real challenge to build, specially because it was my first time learning how to use flutter's CustomPainter.

Big thanks to [Tubik @dribble](https://dribbble.com/shots/6196299-Heartbeat-Tab-Bar-Animation) for making this awesome design and inspiring me to do this app!

## An overview of how the code works

> This is a pretty advanced app, so I'll assume you know the basics of flutter.

The first thing I want to talk about is the `HeartBeatAppBarContent` widget. As you can see, it's a `StatefulWidget` inside of the `HeartBeatAppBar` widget, and its state uses the `SingleTickerProviderStateMixin`. For those of you who don't know, this is what allows us to animate widgets in flutter. We have one `AnimationController` and 3 `Animations<double>`:

- The controller itself is what's going to control the animation values

- The `_activatingOpacity` will animate the opacity of one of the icons so it becomes brighter (indicating it being activated)

- The `_deactivatingOpacity` will animate the opacity of one of the icons so it becomes dimmer (indicating it being deactivated)

- The `_heartBeatAnimation` is what's going to allow us to control the percentage of the animationg, defining the beginning and ending points of the path  of the Painter, so we actually see the line of the heartbeat moving.

We have 3 properties in the `HeartBeatAppBarContent's` state.

- `_activated` allows us to keep track of what is the activated icon so that, when we click one of them, we can animate from the _activated to the `_nextActivated`

- `_nextActivated` allows us to keep track of what's the next icon that is going to be activated so that we can make the heartbeat path from the `_activated` X position, to the `_nextActivated` X position. Its default value is 0, and its immediately changed when the animation is called

- `_positions` is a List of doubles which allows us to know what is the position in the X axis of each icon. This was hardcoded but it can and should be responsive to the width of the device.

> When an animation is called, `_nextActivated` gets the value of the clicked button (if the first icon was clicked, then `_nextActivated` is set to 1, since the default value is 0). Now, we give the HeartBeatPainter its `beginning` property of `_positions[_activated]` and its `ending` property of `_positions[_nextActivated]`. Once the animation ends, `_activated` is set to `_nextActivated` and _nextActivated is set back to 0.

### The CustomPaint

This is where things get a little hairy, but I'll try to keep it very simple. `HeartBeatPainter extends CustomPainter`. That means that it needs to methods: `paint` and `shouldRepaint`. Since we're using an animation coming from its parent widget, we are not going to need `shouldRepaint`, so it just returns false.

We have 3 properties:

- `beginning` is the starting X position of the `HeartBeatPath`, and its coming from `_positions[_activated]`.
- `ending` is the ending X position of the `HeartBeatPath`, and its coming from `_positions[_nextActivated]`. This makes sense because we're going to be making a path from the current activated icon, to the where we just clicked
- `animation` is an `Animation<double>` which is what allows us to know how much of the animation has passed. So if its value is 0.5, that means 50% of the animation has gone through, and that's useful to determine what is the current state of the path itself. This will be passed to the `super` constructor as the `repaint` attribute.

Then we are defining 3 functions. `lerp`, `sigmoid` and `parabola`, which are used to determine some of the values. I'm not going to go through the math of this, but this allows us to have smoother animations.

We also have a `bool inversed` a `List<Offset> _points`. The first one is important to determine if the path will have to go from left to right, or from right to left. The second will contain the all of the points that are going to be used to make our heartbeat path. That means `_points[0]` is `beginning`, and the last value of `_points` is `ending`.

In `_points`, we hard coded a bunch of values:

- The ones that start with `beginning + a * PERCENTAGE` allows us to make a lot of points in between the beginning of the path, and the heartbeat itself (which is always in the middle). If we didn't have this, the path would be "skipping", and the animation would not look smooth at all.
- The same goes for the ones that start with `startingPoint + 30 + b * PERCENTAGE`. This makes a bunch of points in between the ending of the heartbeat itself, and the ending point of whole path.
- All of the other points are the heartbeat itself being hard coded
- `startingPoint` is the X position of the beginning of the heartbeat.

> As you can see from the code, `_positions` change depending on the `_inversed` value, and so, if the animation is going from left to right or right to left.

Now here comes the main part. We have a variable `start` that indicates what is the **first point** of our path, and this changes depending on the `_animation.value`. Hence, if `_animation.value` is closer to 1, the `start` value will be greater, which makes the back of the path start to move when the animation starts progressing. We also have a `percentage` variable, which is what controls the front of the path, since this will define the **last point** of our path.

From there, what we are calling a for loop, that goes from the `start` point (first), to `percentage` point (last), and adds all of the points in between to the path.

> The color of the path (which is a gradient) and the circle (which is the indicator of the current icon) also animate and get its value depending on the `inverse` value.
