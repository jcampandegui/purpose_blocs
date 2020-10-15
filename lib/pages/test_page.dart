import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Purpose p = new Purpose(DateTime.now().microsecondsSinceEpoch.toString());
          BlocProvider.of<PurposesBloc>(context).add(AddPurpose(p));
        }
      ),
    );
  }
}