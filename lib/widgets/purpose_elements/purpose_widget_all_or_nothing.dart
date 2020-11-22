import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/calendar/calendar_barrel.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';

enum menuOptions { delete }

class PurposeWidgetAllOrNothing extends StatelessWidget {
  final Purpose purpose;

  const PurposeWidgetAllOrNothing({Key key, this.purpose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: BlocBuilder<CalendarBloc, DateTime>(
      builder: (context, date) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                  ),
                  Expanded(child: Text(purpose.name)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: PopupMenuButton(
                        onSelected: (option) =>
                            _manageMenuClick(option, context),
                        color: Color.fromARGB(255, 30, 30, 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: menuOptions.delete,
                                  child: Text('Borrar'))
                            ]),
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
                decoration: BoxDecoration(
                    color: purpose.broken
                        ? Color.fromARGB(255, 150, 150, 150)
                        : Color.fromARGB(255, 200, 50, 50),
                    borderRadius: BorderRadius.circular(100)),
                margin: EdgeInsets.only(left: 10, bottom: 10),
                child: purpose.broken
                    ? IconButton(icon: Icon(Icons.error), onPressed: null)
                    : purpose.isCompletedForDate(date)
                        ? IconButton(
                            icon: Icon(Icons.check),
                            onPressed: purpose.canBeEdited(date)
                                ? () {
                                    BlocProvider.of<PurposesBloc>(context).add(
                                        UpdatePurpose(purpose
                                            .removeStreak(DateTime.now())));
                                  }
                                : null)
                        : IconButton(
                            icon: Icon(Icons.widgets),
                            onPressed: purpose.canBeEdited(date)
                                ? () {
                                    BlocProvider.of<PurposesBloc>(context).add(
                                        UpdatePurpose(
                                            purpose.addStreak(DateTime.now())));
                                  }
                                : null))
          ],
        );
      },
    ));
  }

  void _manageMenuClick(menuOptions option, BuildContext context) {
    switch (option) {
      case menuOptions.delete:
        {
          BlocProvider.of<PurposesBloc>(context).add(DeletePurpose(purpose));
        }
        break;

      default:
        {
          print('Menu option not recognized');
        }
        break;
    }
  }
}
