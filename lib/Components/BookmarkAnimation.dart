import 'package:flutter/material.dart';
import 'dart:async';

class BookmarkAnimation extends StatefulWidget {

  Offset startPosition = new Offset(0.6, -0.35);
  final GlobalKey<bookmarkAnimationState> key;
  final screenSize;

  BookmarkAnimation({this.key, this.screenSize}) : super(key: key);

  @override
  bookmarkAnimationState createState() => new bookmarkAnimationState();
}

class bookmarkAnimationState extends State<BookmarkAnimation> with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this
    );
  }
  bookmarkAnimationState();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<Null> playAnimation(startPosition) async {

    setState((){
      widget.startPosition = startPosition;
    });

    try {
      await _controller.forward().orCancel;
      _controller.reset();
    } on TickerCanceled{

    }
  }

  @override
  Widget build(BuildContext context) {
    return new IgnorePointer(
      ignoring: true,
      child: new Stack(
          children: <Widget>[
            new StaggerAnimation(
              controller: _controller.view,
              startPosition: widget.startPosition,
              screenSize: widget.screenSize,
            )
          ]
      ),
    );
  }
}

class StaggerAnimation extends StatelessWidget {

  var startPosition;
  var screenSize;

  static const bottomBarHeight = 50.0;

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> opacityPulse;
  final Animation<double> opacityPulse2;
  final Animation<double> dx;
  final Animation<double> dxPulse;
  final Animation<double> dy;
  final Animation<double> dyPulse;
  final Animation<double> positionedX;
  final Animation<double> positionedY;

  StaggerAnimation({this.controller, this.startPosition, this.screenSize}):
    opacity = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 1.0, curve: Curves.ease))),

    dx = new Tween<double>(
        begin: 20.0,
        end: 0.0
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.4, 0.6, curve: Curves.ease))),

    dy = new Tween<double>(
        begin: 20.0,
        end: 0.0
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.4, 0.6, curve: Curves.ease))),

    positionedX =  new Tween<double>(
        begin: startPosition.dx,
        end: 0.0
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.500, curve: Curves.ease))),

    positionedY =  new Tween<double>(
        begin: startPosition.dy,
        end: screenSize.height
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.500, curve: Curves.ease))),

    opacityPulse = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.05, curve: Curves.easeOut))),

    opacityPulse2 = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.05, 0.350, curve: Curves.easeOut))),

    dxPulse = new Tween<double>(
      begin: 10.0,
      end: 100.0
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.400, curve: Curves.easeOut))),

    dyPulse = new Tween<double>(
        begin: 10.0,
        end: 100.0
    ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.400, curve: Curves.easeOut)))
  ;

  Widget _buildAnimation(BuildContext context, Widget child){

    return new Stack(
      children: <Widget>[
          new Positioned(
            right: startPosition.dx - dxPulse.value/2 + 13.0,
            top: startPosition.dy - dyPulse.value/2 + 15.0,
            child: new Opacity(
              opacity: opacityPulse.value - opacityPulse2.value,
              child: new Center(
                child:new Container(
                  alignment: FractionalOffset.center,
                  width: dxPulse.value,
                  height: dyPulse.value,
                  decoration: new BoxDecoration(
                    color: new Color(0xFFFF0000),
                    shape: BoxShape.circle,
                  ),

              )
            ),
          ),
        ),
        new Positioned(
            right: positionedX.value - dx.value/2,
            top: positionedY.value - dx.value/2,
            child: new Opacity(
              opacity: opacity.value,
              child: new Container(
                width: dx.value,
                height: dy.value,
                decoration: new BoxDecoration(
                  color: new Color(0xFFFF0000),
                  shape: BoxShape.circle,
                ),
              ),
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}