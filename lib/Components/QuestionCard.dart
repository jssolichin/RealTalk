import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../styles.dart';
import 'BookmarkIcon.dart';

class QuestionCard extends StatelessWidget {

  int content;
  double resizeFactor;
  DocumentSnapshot data;

  final Function onBookmarkPressed;

  QuestionCard({
    this.content,
    this.resizeFactor,
    this.onBookmarkPressed,
    this.data,
  });

  Widget _questionCardContent(BuildContext context) {
    final QTheme theme = QTheme.of(context);

    return new Container(
        margin: new EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 40.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new BookmarkIcon(
                onBookmarkPressed: onBookmarkPressed,
              ),
              new Container(
                  margin: new EdgeInsets.only(right: 20.0),
                  child: new Text(
                    "${data['value']}",
//                    "${content} If you find out you were immortal, what would be the first thing you do?",
                    style: QTheme.questionFont(QTheme.defaultMainQuestionSize * resizeFactor),
                  ))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: _questionCardContent(context),
        decoration: new BoxDecoration(
            color: new Color(0xFFFFFFFF),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 50.0,
                  offset: new Offset(0.0, 10.0))
            ]));
  }
}