import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../styles.dart';
import '../Page.dart';

class PlaylistGrid extends StatelessWidget {

  final AsyncSnapshot snapshot;

  PlaylistGrid({
    this.snapshot,
  });


  Widget _getGradient(Color color) {
    return new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: <Color>[new Color(0x0000A3FF), color],
              stops: [0.0, 1.0],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
            )));
  }

  Widget _buidPage(String title) {
    var color = new Color(0xFF24BD64);
    var pageAnimator = new PageAnimator(
      title: title,
      color: color,
    );

    return new Stack(
        children: <Widget>[
          _getGradient(color),
          new SingleChildScrollView(
  child: new Text("hewllo"),
//   child: pageAnimator,
          )
        ]);

  }

  Widget _buildPlaylist(BuildContext context, DocumentSnapshot snapshot) {
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
                child: new GestureDetector(
                  onTap: () {
                    print("TAPPED!");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _buidPage(snapshot['title']),
                      ),
                    );

                  },
                  child: new Container(
                    child: new Text(snapshot['title'], style: QTheme.of(context).playlistTitle),
                    alignment: AlignmentDirectional.bottomEnd,
                  )
                )
            )
        )
    );
  }

  Widget _buildRow(List<Widget> playlists) {
    return new Row(
      children: playlists,
    );
  }

  @override
  Widget build(BuildContext context) {
    var length = snapshot.data.documents.length;
    var rows = List<Widget>();
    var lastRow = List<Widget>();

    for (var i = 0; i < length; i++) {
      DocumentSnapshot document1 = snapshot.data.documents[i];

      final p1 = _buildPlaylist(context, document1);

      if (lastRow.length < 2) {
        lastRow.add(p1);
      } else {
        rows.add(_buildRow(lastRow));
        lastRow = [p1];
      }
    }

    if (length % 2 != 0) {
      rows.add(_buildRow(lastRow));
    }

    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        child: new Column(children: rows));
  }
}