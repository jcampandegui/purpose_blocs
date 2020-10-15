import 'package:equatable/equatable.dart';
import 'package:purpose_blocs/models/purpose.dart';

abstract class PurposesState extends Equatable {
  const PurposesState();

  @override
  List<Object> get props => [];
}

class PurposesLoadInProgress extends PurposesState {}

class PurposesLoadSuccess extends PurposesState {
  final List<Purpose> purposes;

  const PurposesLoadSuccess([this.purposes = const []]);

  @override
  List<Object> get props => [purposes];

  @override
  String toString() => 'PurposesLoadSuccess { number of purposes: ${purposes.length} }';
}

class PurposesLoadFailure extends PurposesState {}