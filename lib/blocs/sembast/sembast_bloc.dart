import 'dart:async';
import 'package:bloc/bloc.dart';
import 'sembast_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';

class PurposesBloc extends Bloc<PurposesEvent, PurposesState> {
  //final TodosRepositoryFlutter todosRepository;
  // TODO: replace dummy element and logic to work with a proper DB
  final List<Purpose> dummy = [
    new Purpose('Purpose 1', streak: 10),
    new Purpose('Purpose 2', streak: 1),
    new Purpose('Purpose 3', streak: 2),
    new Purpose('Purpose 4', streak: 3),
  ];

  // TODO: update
  //PurposesBloc({@required this.todosRepository}) : super(PurposesLoadInProgress());
  PurposesBloc() : super(PurposesLoadInProgress());

  @override
  Stream<PurposesState> mapEventToState(PurposesEvent event) async* {
    print('Some event happened => $event');
    if (event is PurposesLoad) {
      yield* _mapPurposesLoadToState();
    } else if (event is PurposeAdded) {
      yield* _mapPurposeAddedToState(event);
    } else if (event is PurposeUpdated) {
      yield* _mapPurposeUpdatedToState(event);
    } else if (event is PurposeDeleted) {
      yield* _mapPurposeDeletedToState(event);
    }
  }

  Stream<PurposesState> _mapPurposesLoadToState() async* {
    try {
      // TODO: update
      /*final todos = await this.todosRepository.loadTodos();
      yield TodosLoadSuccess(
        todos.map(Todo.fromEntity).toList(),
      );*/
      final purposes = dummy;
      yield PurposesLoadSuccess(purposes);
    } catch (_) {
      yield PurposesLoadFailure();
    }
  }

  Stream<PurposesState> _mapPurposeAddedToState(PurposeAdded event) async* {
    if (state is PurposesLoadSuccess) {
      final List<Purpose> updatedPurposes = List.from(
          (state as PurposesLoadSuccess).purposes)
        ..add(event.purpose);
      yield PurposesLoadSuccess(updatedPurposes);
      // TODO: update with DB save
      //_saveTodos(updatedPurposes);
    }
  }

  Stream<PurposesState> _mapPurposeUpdatedToState(PurposeUpdated event) async* {
    if (state is PurposesLoadSuccess) {
      final List<Purpose> updatedPurposes = (state as PurposesLoadSuccess).purposes.map((
          purpose) {
        return purpose.id == event.purpose.id ? event.purpose : purpose;
      }).toList();
      print(updatedPurposes);
      yield PurposesLoadSuccess(updatedPurposes);
      // TODO: update with DB save
      //_saveTodos(updatedPurposes);
    }
  }

  Stream<PurposesState> _mapPurposeDeletedToState(PurposeDeleted event) async* {
    if (state is PurposesLoadSuccess) {
      final updatedPurposes = (state as PurposesLoadSuccess)
          .purposes
          .where((purpose) => purpose.id != event.purpose.id)
          .toList();
      yield PurposesLoadSuccess(updatedPurposes);
      // TODO: update with DB save
      //_saveTodos(updatedPurposes);
    }
  }

  // TODO: implement save with proper DB
  /*Future _saveTodos(List<Todo> todos) {
    return todosRepository.saveTodos(
      todos.map((todo) => todo.toEntity()).toList(),
    );
  }*/
}