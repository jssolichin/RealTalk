import 'package:flutter/material.dart';

class BookmarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 2.0, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BookmarkIcon extends StatefulWidget {
  @override
  _BookmarkIconState createState() => new _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {

  bool _enabled = false;

  Container icon (shadowColor, color) {
    return new Container(
        decoration: new BoxDecoration(boxShadow: <BoxShadow>[
          new BoxShadow(
              color: shadowColor,
              blurRadius: 10.0,
              offset: new Offset(0.0, 4.0))
        ]),
        child: new ClipPath(
          child: new Container(
            width: 25.0,
            height: 40.0,
            decoration: new BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ),
          clipper: new BookmarkClipper(),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    final shadowColor =_enabled ? new Color(0x55EB5757) : new Color(0x00000000);
    final color = _enabled ? new Color(0xFFFF0000) : new Color(0xFFDEDEDE);

    return new Container(
      alignment: Alignment.topRight,
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          this.setState((){
            _enabled = !_enabled;
          });
        },
        child: icon(shadowColor, color),
      ),
    );
  }
}
