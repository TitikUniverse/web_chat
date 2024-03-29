import 'package:flutter/material.dart';

/// a screen wrapper that responsible to build / draw a screen
/// base on the screen width we have
class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.dekstop,
  });

  final Widget mobile;
  final Widget tablet;
  final Widget dekstop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;
  static bool isTable(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1200;
  static bool isDekstop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  String previousLayout = "";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        if (constrains.maxWidth >= 1200) {
          return widget.dekstop;
        } else if (constrains.maxWidth >= 800 && constrains.maxWidth < 1200) {
          return widget.tablet;
        } else {
          return widget.mobile;
        }
      },
    );
  }
}
