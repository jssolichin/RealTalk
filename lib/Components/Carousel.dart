import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';
import 'dart:io';

import 'QuestionCard.dart';
import 'PageIndicator.dart';


const double _kViewportFraction = 0.75;


class QuestionCarousel extends StatefulWidget {

  final Function onBookmarkPressed;
  final snapshot;

  QuestionCarousel({this.onBookmarkPressed, this.snapshot});

  @override
  _QuestionCarouselPagerState createState() =>
      new _QuestionCarouselPagerState();
}

class _QuestionCarouselPagerState extends State<QuestionCarousel> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> _message = new Future<String>.value('');

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  PageController _pageController;
  int _currentIndex = 0;

  ValueNotifier<double> selectedIndex = new ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = new PageController(initialPage: _currentIndex);

    _handleSignIn()
      .then((FirebaseUser user) {
//        print(user);
      })
      .catchError((e) => print(e));

  }

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user = await _auth.signInAnonymously();
    print("signed in " + user.displayName);
    return user;
  }


  Future<String> _testSignInAnonymously() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInAnonymously succeeded: $user';
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

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

  Widget _buildPage(context, index, snapshot) {

    var alignment = Alignment.center
          .add(new Alignment(
          (selectedIndex.value - index) * _kViewportFraction, 0.0));
      var resizeFactor = (1 -
          (((selectedIndex.value - index).abs() * 0.2).clamp(0.0, 1.0)));

      return _contentWidget(
        new QuestionCard(
          content: index,
          resizeFactor: resizeFactor,
          onBookmarkPressed: () {
            widget.onBookmarkPressed();
          },
          data: snapshot,
        ),
        alignment,
        resizeFactor,
      );

  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 580.0,
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
              child: new PageView.builder(
                controller: _pageController,
                itemCount: widget.snapshot.data.documents.length,
                onPageChanged: _handlePageChanged,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = widget.snapshot.data.documents[index];

                  return _buildPage(context, index, ds);
                }
              )
            ),
            new MaterialButton(
                child: const Text('Test signInAnonymously'),
                onPressed: () {
                  setState(() {
                    _message = _testSignInAnonymously();
                  });
                }),
            new FutureBuilder<String>(
                future: _message,
                builder: (_, AsyncSnapshot<String> snapshot) {
                  return new Text(snapshot.data ?? '',
                      style:
                      const TextStyle(color: Color.fromARGB(255, 0, 155, 0)));
                }),
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