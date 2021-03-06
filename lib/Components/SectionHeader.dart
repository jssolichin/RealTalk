import 'package:flutter/material.dart';

import '../styles.dart';


import '../Animations/PageEnterAnimation.dart';

class SectionHeader extends StatelessWidget {

  final PageEnterAnimation _animation;
  final String title;

  SectionHeader({
    String text,
    PageEnterAnimation animation,
  }) : _animation = animation, title = text;

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(title, style: QTheme
                  .of(context)
                  .sectionHeader),
            ]));
  }
}