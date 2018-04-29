import 'package:flutter/material.dart';
import 'Page.dart';

class MyAppHome extends StatefulWidget {
  const MyAppHome();

  @override
  MyAppHomeState createState() => new MyAppHomeState();
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class CustomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: const Icon(Icons.album),
            title: const Text('The Enchanted Nightingale'),
            subtitle:
                const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          new ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              children: <Widget>[
                new FlatButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                new FlatButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class NavigationIconView {
  final Widget _icon;
  final Color color;
  final String _title;
  final AnimationController controller;
  final BottomNavigationBarItem item;

  CurvedAnimation _animation;

  NavigationIconView({
    Widget icon,
    String title,
    Color color,
    TickerProvider vsync,
  })
      : _icon = icon,
        color = color,
        _title = title,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: new Text(title),
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  FadeTransition transition(
      BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 0.2), // Slightly down.
            end: Offset.zero,
          )
              .animate(_animation),
          child: new Column(
            children: <Widget>[
              new CustomCard(),
              new IconTheme(
                data: new IconThemeData(
                  color: iconColor,
                  size: 120.0,
                ),
                child: new Semantics(
                  label: 'Placeholder for $_title tab',
                  child: _icon,
                ),
              ),
            ],
          )),
    );
  }
}

const double unitSize = kToolbarHeight;

class _HeadingLayout extends MultiChildLayoutDelegate {
  _HeadingLayout();

  static const String title = 'title';
  static const String description = 'description';

  @override
  void performLayout(Size size) {
    final double halfWidth = size.width / 2.0;
    final double halfHeight = size.height;
    const double margin = 0.0;

    final double maxTitleWidth = halfWidth + unitSize - margin;
    final BoxConstraints titleBoxConstraints =
        new BoxConstraints(maxWidth: maxTitleWidth);
    final Size titleSize = layoutChild(title, titleBoxConstraints);
    final double titleX = 0.0;
    final double titleY = halfHeight - titleSize.height;
    positionChild(title, new Offset(titleX, titleY));

    final double descriptionY = titleY + titleSize.height + margin;
    positionChild(description, new Offset(titleX, descriptionY));
  }

  @override
  bool shouldRelayout(_HeadingLayout oldDelegate) => false;
}

// A card that highlights the "featured" catalog item.
class _Heading extends StatelessWidget {
//  _Heading({ Key key, @required this.product })
//      : assert(product != null),
//        assert(product.featureTitle != null),
//        assert(product.featureDescription != null),
//        super(key: key);

//  final Product product;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new MergeSemantics(
      child: new SizedBox(
        height: screenSize.width > screenSize.height
            ? (screenSize.height - kToolbarHeight) * 10
            : (screenSize.height - kToolbarHeight) * 100,
        child: new Container(
          child: new CustomMultiChildLayout(
            delegate: new _HeadingLayout(),
            children: <Widget>[
              new LayoutId(
                id: _HeadingLayout.title,
                child: new Text(
                  "HOME",
//style: QTheme.of(context).MainQuestion,
//                    style: theme.featureTitleStyle
                ),
              ),
              new LayoutId(
                id: _HeadingLayout.description,
                child: new Text("Let's make a friend today"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyAppHomeState extends State<MyAppHome> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
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

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

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
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Welcome to Flutter'),
//        ),
//        body: new Center(
//            child: _buildTransitionsStack()
//        ),
      body: new SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50.0),
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Page(),
              ])),
      bottomNavigationBar: botNavBar,
    );
  }
}
