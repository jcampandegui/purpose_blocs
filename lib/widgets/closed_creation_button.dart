import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:purpose_blocs/widgets/all_or_nothing_creation.dart';

class ClosedCreationButton extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String openedWidget;

  const ClosedCreationButton({
    Key key,
    this.title,
    this.description,
    this.icon,
    this.openedWidget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        closedBuilder: (_, openContainer) {
          return InkWell(
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20, left: 10),
                  child: Icon(this.icon),
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            this.title,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              this.description)
                        ],
                      ),
                    ))
              ],
            ),
            onTap: openContainer,
          );
        },
        closedElevation: 0,
        closedColor: Color.fromARGB(255, 200, 50, 50),
        closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        transitionDuration: Duration(milliseconds: 400),
        openColor: Theme.of(context).scaffoldBackgroundColor,
        openBuilder: (context, closeContainer) {
          if(openedWidget == 'allOrNothing') return AllOrNothingCreation(closeContainerCallback: closeContainer,);
          return null;
        });
  }
}