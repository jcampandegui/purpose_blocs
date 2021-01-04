import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final EdgeInsets insets;

  const NavigationItem({Key key, this.label, this.icon, this.selected, this.insets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:Container(
            padding: insets,
            child: RawMaterialButton(
              onPressed: () {},
              child: Icon(icon),
              padding: EdgeInsets.all(2),
              shape: CircleBorder(),
            )
        )
    );
  }
}