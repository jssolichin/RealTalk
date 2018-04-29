import 'package:flutter/material.dart';

import 'Carousel.dart';
import '../styles.dart';

class PageHeader extends StatelessWidget {

  Widget _getGradient(BuildContext context) {
    return new Container(
        height: 500.0,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: <Color>[QTheme
                  .of(context)
                  .homeColor, new Color(0x0000A3FF)
              ],
              stops: [0.0, 1.0],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
            )));
  }

  Widget _getText(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 70.0, 40.0, 20.0),
      child:
      new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Text("Question of the Day", style: QTheme
                .of(context)
                .pageHeader)
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
//      _getBackground(),
      _getGradient(context),
      new Column(
        children: <Widget>[
          _getText(context),
          new QuestionCarousel(),
        ],
      ),
    ]);
  }
}