import 'package:flutter/material.dart';
import 'home.dart';
import 'styles.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  createState() => new MyAppState();
}

Widget buildApp(BuildContext context, Widget child) {
  return new Theme(
      data: new ThemeData(
        scaffoldBackgroundColor: new Color(0xFF454545),
        platform: Theme.of(context).platform,
      ),
      child: new QTheme(child: child));
}

class MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'RealTalk',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => buildApp(context, new MyAppHome()),
      },
      onGenerateRoute: _getRoute,
    );
  }
}

Route<Null> _getRoute(RouteSettings settings) {
  // Routes, by convention, are split on slashes, like filesystem paths.
  final List<String> path = settings.name.split('/');
  // We only support paths that start with a slash, so bail if
  // the first component is not empty:
  if (path[0] != '') return null;
  // If the path is "/stock:..." then show a stock page for the
  // specified stock symbol.
  if (path[1].startsWith('stock:')) {
    // We don't yet support subpages of a stock, so bail if there's
    // any more path components.
    if (path.length != 2) return null;
    // Extract the symbol part of "stock:..." and return a route
    // for that symbol.
    final String symbol = path[1].substring(6);
    return new MaterialPageRoute<Null>(
      settings: settings,
      builder: (BuildContext context) => new Text("test"),
    );
  }
  // The other paths we support are in the routes table.
  return null;
}
