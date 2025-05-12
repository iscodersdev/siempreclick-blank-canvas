import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child);

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateXAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      // Optional: you can adjust the duration as needed
    );

    final curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
    _translateXAnimation =
        Tween<double>(begin: 30.0, end: 0.0).animate(curvedAnimation);

    // Delay animation
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(_translateXAnimation.value, 0),
            child: widget.child,
          ),
        );
      },
    );
  }
}
