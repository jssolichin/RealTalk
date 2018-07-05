import 'package:flutter/material.dart';

class PageEnterAnimation {
  PageEnterAnimation(this.controller)
      :

        pageHeaderYTranslation = new Tween(begin: 60.0, end: 0.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.0,
              0.2,
              curve: Curves.ease,
            ),
          ),
        ),
        pageHeaderOpacity = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.0,
              0.2,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        carouselYTranslation = new Tween(begin: 60.0, end: 0.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.1,
              0.3,
              curve: Curves.ease,
            ),
          ),
        ),
        carouselOpacity = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.1,
              0.3,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        );

  final AnimationController controller;
  final Animation<double> pageHeaderYTranslation;
  final Animation<double> pageHeaderOpacity;
  final Animation<double> carouselYTranslation;
  final Animation<double> carouselOpacity;

}