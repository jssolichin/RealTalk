import 'package:flutter/material.dart';

import '../Animations/PageEnterAnimation.dart';
import '../styles.dart';

class PlaylistGrid extends StatelessWidget {

  final PageEnterAnimation _animation;

  PlaylistGrid({
    PageEnterAnimation animation,
  }) : _animation = animation;

  Widget _buildPlaylist(BuildContext context, String title) {
    return new Expanded(
        child: new Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: <Color>[
                    new Color(0xFF24BD64),
                    new Color(0x0000A3FF)
                  ],
                  stops: [0.0, 1.0],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                ),
                borderRadius: new BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                      color: Colors.black38,
                      blurRadius: 50.0,
                      offset: new Offset(0.0, -10.0))
                ]),
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(20.0),
            child: new AspectRatio(
                aspectRatio: 1.0,
                child: new Container(
                  child:
                  new Text(title, style: QTheme.of(context).playlistTitle),
                  alignment: AlignmentDirectional.bottomEnd,
                ))));
  }

  Widget _buildRow(playlists) {
    return new Row(
      children: <Widget>[playlists[0], playlists[1]],
    );
  }

  @override
  Widget build(BuildContext context) {
    var rows = List<Widget>();
//
    for (var i = 0; i < 2; i = i + 2) {
      final p1 = _buildPlaylist(context, "This is a Playlist");
      final p2 = _buildPlaylist(context, "This is a Playlist");
      rows.add(_buildRow([p1, p2]));
    }

    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        child: new Column(children: rows));
  }
}