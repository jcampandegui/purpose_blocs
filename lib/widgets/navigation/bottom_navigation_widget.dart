import 'package:flutter/material.dart';
import 'package:purpose_blocs/widgets/navigation/navigation_item.dart';

class BottomNavigationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              NavigationItem(label: 'nav1', icon: Icons.ac_unit, selected: true,),
              NavigationItem(label: 'nav2', icon: Icons.ac_unit, selected: false,),
              NavigationItem(label: 'nav3', icon: Icons.ac_unit, selected: false,),
              NavigationItem(label: 'nav4', icon: Icons.ac_unit, selected: false,),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
          ),
        ),
      shape: CircularNotchedRectangle(),
    );
  }
}