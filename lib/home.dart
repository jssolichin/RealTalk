import 'package:flutter/material.dart';

import 'Page.dart';

class MyAppHome extends StatefulWidget {
  const MyAppHome();

  @override
  MyAppHomeState createState() => new MyAppHomeState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    String title,
    Color color,
    TickerProvider vsync,
  })  : _icon = icon,
        color = color,
        _title = title,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: new Text(title),
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: const Duration(milliseconds: 250),
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color color;
  final String _title;
  final AnimationController controller;
  final BottomNavigationBarItem item;
  var pageAnimator;
  CurvedAnimation _animation;

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
    pageAnimator = new PageAnimator(
      title: title,
      color: color,
    );

    return new Stack(
        children: <Widget>[
          _getGradient(color),
          new SingleChildScrollView(
            child: pageAnimator,
          )
        ]);
  }

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {

    return new FadeTransition(
      opacity: _animation,
      child: _buidPage(_title),
    );
  }
}

class MyAppHomeState extends State<MyAppHome> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();

    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.home),
        title: 'Home',
        color: new Color(0xFFE545FF),
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.group),
        title: 'Group',
        color: Colors.deepOrange,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.mood),
        title: 'Friends',
        color: Colors.teal,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.favorite),
        title: 'Intimate',
        color: Colors.indigo,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.star),
        title: 'Starred',
        color: Colors.pink,
        vsync: this,
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.forward();
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[index].controller.forward();
        });
      },
    );

    return new Scaffold(
      body: new Center(child: _buildTransitionsStack()),
      bottomNavigationBar: botNavBar,
    );
  }
}
