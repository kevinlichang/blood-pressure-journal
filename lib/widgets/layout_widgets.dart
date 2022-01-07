import 'package:flutter/material.dart';

class LayoutDecider extends StatelessWidget {
  final Widget leftScreen;
  final Widget rightScreen;

  const LayoutDecider(
      {Key? key, required this.leftScreen, required this.rightScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 700) {
        return VerticalLayout(singleScreen: leftScreen);
      } else {
        return HorizontalLayout(
            leftScreen: leftScreen, rightScreen: rightScreen);
      }
    });
  }
}

class VerticalLayout extends StatelessWidget {
  final Widget singleScreen;

  const VerticalLayout({Key? key, required this.singleScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: singleScreen,
    );
  }
}

class HorizontalLayout extends StatelessWidget {
  final Widget leftScreen;
  final Widget rightScreen;

  const HorizontalLayout(
      {Key? key, required this.leftScreen, required this.rightScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: leftScreen),
        Expanded(child: rightScreen),
      ],
    );
  }
}
