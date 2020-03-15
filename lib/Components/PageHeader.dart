import 'package:flutter/material.dart';

import '../Animations/PageEnterAnimation.dart';
import '../styles.dart';
import 'Carousel.dart';

class PageHeader extends StatelessWidget {

  final PageEnterAnimation _animation;
  final Color _color;
  final String _title;
  final snapshot;
  final Function onBookmarkPressed;

  PageHeader({
    PageEnterAnimation animation,
    Color color,
    String title,
    this.onBookmarkPressed,
    this.snapshot,
  }) : _animation = animation, _color = color, _title = title;

  Widget _getText(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 70.0, 40.0, 20.0),
      child:
      new Transform(
          transform: new Matrix4.translationValues(
            0.0,
            _animation.pageHeaderYTranslation.value,
            0.0,
          ),
          child: new Opacity (
              opacity: _animation.pageHeaderOpacity.value,
              child: new Text(
//                  "Question of the Day",
                  _title,
                  style: QTheme
                      .of(context)
                      .pageHeader
              )
          )
      ),
    );
  }

  Widget _getCarousel() {
    return new Transform(
        transform: new Matrix4.translationValues(
          0.0,
          _animation.carouselYTranslation.value,
          0.0,
        ),
        child: new Opacity (
            opacity: _animation.carouselOpacity.value,
            child: new QuestionCarousel(
              onBookmarkPressed: onBookmarkPressed,
              snapshot: snapshot,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Stack(children: <Widget>[
//      _getBackground(),
//      _getGradient(context),
      new Column(
        children: <Widget>[
          _getText(context),
          _getCarousel(),
        ],
      ),
    ]);
  }
}