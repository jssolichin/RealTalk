import 'package:flutter/material.dart';
import 'QuestionCard.dart';
import 'PageIndicator.dart';

const double _kViewportFraction = 0.75;


class QuestionCarousel extends StatefulWidget {
  @override
  _QuestionCarouselPagerState createState() =>
      new _QuestionCarouselPagerState();
}

class _QuestionCarouselPagerState extends State<QuestionCarousel> {

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  final PageController _pageController = new PageController(
      viewportFraction: _kViewportFraction);
  ValueNotifier<double> selectedIndex = new ValueNotifier<double>(0.0);

  _contentWidget(QuestionCard qc, Alignment alignment, double resize) {
    return new Stack(
      children: <Widget>[
        new Center(
          child: new Container(
            alignment: alignment,
            width: 320.0 * resize,
            height: 450.0 * resize,
            child: new Stack(
              children: <Widget>[
                qc
              ],
            ),
          ),
        )
      ],
    );
  }

  Iterable<Widget> _buildPages() {
    final List<Widget> pages = <Widget>[];

    for (int index = 0; index < 3; index++) {
      var alignment = Alignment.center
          .add(new Alignment(
          (selectedIndex.value - index) * _kViewportFraction, 0.0));
      var resizeFactor = (1 -
          (((selectedIndex.value - index).abs() * 0.2).clamp(0.0, 1.0)));

      pages.add(
          _contentWidget(
            new QuestionCard(index),
            alignment,
            resizeFactor,
          )
      );
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 550.0,
        child: new Stack(
          children: <Widget>[
            new NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification.depth == 0 &&
                    notification is ScrollUpdateNotification) {
                  selectedIndex.value = _pageController.page;
                  setState(() {});
                }
                return false;
              },
              child: new PageView(
                controller: _pageController,
                children: _buildPages(),
              ),
            ),
            new Align(
                alignment: FractionalOffset.center,
                child: new Padding(
                  padding: const
                  EdgeInsets.only(top: 520.0),
                  child: new PageIndicator(
                    controller: _pageController,
                    color: new Color(0x77000000),
                    itemCount: 3,
                    onPageSelected: (int page) {
                      _pageController.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                )
            ),
          ],
        )
    );
  }

}