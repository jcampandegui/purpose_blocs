import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';

enum menuOptions { delete }

class PurposeWidgetAllOrNothing extends StatelessWidget {
  final Purpose purpose;
  
  const PurposeWidgetAllOrNothing({
    Key key,
    this.purpose
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Container(margin: EdgeInsets.only(left: 10),),
                Expanded(child: Text(purpose.name)),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: PopupMenuButton(
                    onSelected: (option) => _manageMenuClick(option, context),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: menuOptions.delete,
                            child: Text('Borrar')
                        )
                      ]
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Container()),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 200, 50, 50),
              borderRadius: BorderRadius.circular(100)
            ),
            margin: EdgeInsets.only(left: 10, bottom: 10),
            child: IconButton(icon: Icon(Icons.widgets), onPressed: () => BlocProvider.of<PurposesBloc>(context).add(UpdatePurpose(purpose.copyWith(streak: purpose.streak + 1)))),
          )
        ],
      ),
    );
  }

  void _manageMenuClick(menuOptions option, BuildContext context) {
    switch(option) {
      case menuOptions.delete: {
        BlocProvider.of<PurposesBloc>(context).add(DeletePurpose(purpose));
      }
      break;

      default: {
        print('Menu option not recognized');
      }
      break;
    }
  }
}