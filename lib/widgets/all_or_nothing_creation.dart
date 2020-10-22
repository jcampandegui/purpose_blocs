import 'package:flutter/material.dart';

class AllOrNothingCreation extends StatefulWidget {
  @override
  _AllOrNothingCreationState createState() => _AllOrNothingCreationState();
}

class _AllOrNothingCreationState extends State<AllOrNothingCreation> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: TextFormField(
                      initialValue: 'Nuevo propósito',
                      style: TextStyle(
                        fontSize: 42
                      ),
                      validator: (value) {
                        if(value.isEmpty) return '¡No dejes el nombre vacío!';
                        return null;
                      },
                    ),
                  ),
                  RaisedButton(
                      child: Text('Crear'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          //BlocProvider.of<PurposesBloc>(context).add(AddPurpose(purpose))
                        }
                      }
                  )
                ],
              ),
            )
        )
    );
  }
}