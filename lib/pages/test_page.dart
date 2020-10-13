import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final String text;

  const TestPage({
    Key key,
    this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}