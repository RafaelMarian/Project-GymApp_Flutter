import 'package:flutter/material.dart';

class SlideRightRouteJogging extends PageRouteBuilder {
  final Widget widget;
  SlideRightRouteJogging({required this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0), // Slide from right to left
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
