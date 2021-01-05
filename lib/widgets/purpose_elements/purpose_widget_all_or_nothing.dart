import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/calendar/calendar_barrel.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';

// debug
enum menuOptions { delete, markBroken }

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
                                  child: Text('Borrar')),
                              /*PopupMenuItem(
                                  value: menuOptions.markBroken,
                                  child: Text('Broken'))*/
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
                        : purpose.colorDarker/*Color.fromARGB(255, 200, 50, 50)*/,
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Borrar propósito"),
                content: new Text(
                    "¿Seguro que quieres borrar este propósito? Esta acción no se puede deshacer"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Aceptar"),
                    textColor: Color.fromARGB(255, 255, 100, 100),
                    onPressed: () {
                      BlocProvider.of<PurposesBloc>(context).add(DeletePurpose(purpose));
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("Cancelar"),
                    textColor: Color.fromARGB(255, 255, 100, 100),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        break;
      case menuOptions.markBroken:
        {
          BlocProvider.of<PurposesBloc>(context).add(UpdatePurpose(purpose.copyWith(broken: !purpose.broken)));
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
