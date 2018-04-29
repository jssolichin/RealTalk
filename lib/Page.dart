import 'package:flutter/material.dart';

import 'Components/PageHeader.dart';
import 'Components/PlaylistGrid.dart';
import 'Components/SectionHeader.dart';

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new PageHeader(),
          new SectionHeader("Popular Playlist"),
          new PlaylistGrid(),
        ],
      ),
    ]);
  }
}