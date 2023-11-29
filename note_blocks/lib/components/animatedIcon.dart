import 'package:flutter/material.dart';

class _AnimatedLeadingIcon extends StatefulWidget {
  @override
  _AnimatedLeadingIconState createState() => _AnimatedLeadingIconState();
}

class _AnimatedLeadingIconState extends State<_AnimatedLeadingIcon> {
  bool isMenuOpen = false;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
    // Burada menü açma/kapama işlemleri yapılabilir.
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isMenuOpen ? Icons.menu_open : Icons.menu,
      ),
      onPressed: toggleMenu,
    );
  }
}
