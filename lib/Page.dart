import 'package:flutter/material.dart';

import 'dart:math';

import 'Animations/PageEnterAnimation.dart';
import 'Components/PageHeader.dart';
import 'Components/PlaylistGrid.dart';
import 'Components/SectionHeader.dart';
import 'Components/BookmarkAnimation.dart';

class PageAnimator extends StatefulWidget {

  final Color color;
  final String title;

  PageAnimator({this.color, this.title});

  @override
  _PageAnimatorState createState() => new _PageAnimatorState();
}

class _PageAnimatorState extends State<PageAnimator>
    with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> animation;

  _PageAnimatorState();

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    animation = new Tween(begin: 0.0, end: 300.0).animate(_controller);
  }

  @override
  void didUpdateWidget(PageAnimator oldWidget) {
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Page(
      controller: _controller,
      color: widget.color,
      title: widget.title
    );
  }
}

class Page extends StatelessWidget {

  final PageEnterAnimation _animation;
  final Color _color;
  final String _title;

  Page({
    AnimationController controller,
    Color color,
    String title,
  }) : _animation = new PageEnterAnimation(controller), _color = color, _title = title;

  var bookmarkAnimationStateKey = GlobalKey<bookmarkAnimationState>();

  Widget _buildAnimation(BuildContext context, Widget child) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return new Stack(children: <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new PageHeader(
            animation: _animation,
            onBookmarkPressed: (startPos) {
              bookmarkAnimationStateKey.currentState.playAnimation(startPos);
            },
            color: _color,
            title: _title
          ),
          new SectionHeader(
              text: "Popular Playlist",
              animation: _animation
          ),
          new PlaylistGrid(
              animation: _animation
          ),
        ],
      ),
      new Container(
        width: width,
        height: height,
        child: new BookmarkAnimation(
            key: bookmarkAnimationStateKey,
          screenSize: MediaQuery.of(context).size
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new AnimatedBuilder(
        animation: _animation.controller,
        builder: _buildAnimation,
      ),
    );
  }
}