// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QStyle extends TextStyle {
  const QStyle.montserrat(double size, Color color)
      : super(
            inherit: false,
            color: color,
            fontSize: size,
            fontFamily: 'Montserrat');
  const QStyle.lato(double size, Color color)
      : super(inherit: false, color: color, fontSize: size, fontFamily: 'Lato');
}

class QTheme extends InheritedWidget {
  QTheme({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  static double defaultMainQuestionSize = 39.0;
  final Color homeColor = new Color(0xFFE545FF);

  final TextStyle pageHeader =
      new QStyle.montserrat(50.0, new Color(0xFFFFFFFF));
  final TextStyle sectionHeader =
      new QStyle.montserrat(20.0, new Color(0xFFFFFFFF));
  final TextStyle playlistTitle =
      new QStyle.montserrat(18.0, new Color(0xFFFFFFFF));

  final TextStyle mainQuestion = questionFont(defaultMainQuestionSize);

  static TextStyle questionFont (size) => new QStyle.lato(size, new Color(0xFF333333));

  static QTheme of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(QTheme);

  @override
  bool updateShouldNotify(QTheme old) => false;
}
