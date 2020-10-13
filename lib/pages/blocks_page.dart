import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/widgets/purpose_elements/single_purpose.dart';

class BlocksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposesBloc, PurposesState>(builder: (context, state) {
      print(state);
      if (state is PurposesLoadSuccess) {
        List<Purpose> purposes = state.purposes;
        print('Change in blocBuilder');
        print(purposes);
        return Scaffold(
          //body: SinglePurpose(purpose: purposes[0]),
          body: GridView.count(
            crossAxisCount: 2,
            children: List.generate(purposes.length, (index) {
              return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(purposes[index].name),
                ),
                onTap: () {
                  PurposesBloc purposesBloc =
                      BlocProvider.of<PurposesBloc>(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SinglePurpose(
                              purposeId: purposes[index].id,
                              purposesBloc: purposesBloc,
                            )),
                  );
                },
              );
            }),
          ),
        );
      } else if (state is PurposesLoadFailure) {
        return Scaffold(
          body: Center(
            child: Text('Error al cargar propósitos'),
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
