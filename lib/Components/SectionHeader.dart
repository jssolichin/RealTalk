import 'package:flutter/material.dart';

import '../styles.dart';

class SectionHeader extends StatelessWidget {
  SectionHeader(this.title);

  final String title;

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