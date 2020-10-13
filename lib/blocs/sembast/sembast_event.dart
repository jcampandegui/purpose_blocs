import 'package:equatable/equatable.dart';
import 'package:purpose_blocs/models/purpose.dart';

abstract class PurposesEvent extends Equatable {
  const PurposesEvent();

  @override
  List<Object> get props => [];
}

class PurposesLoad extends PurposesEvent {}

class PurposeAdded extends PurposesEvent {
  final Purpose purpose;

  const PurposeAdded(this.purpose);

  @override
  List<Object> get props => [purpose];

  @override
  String toString() => 'PurposeAdded { purpose: $purpose }';
}

class PurposeUpdated extends PurposesEvent {
  final Purpose purpose;

  const PurposeUpdated(this.purpose);

  @override
  List<Object> get props => [purpose];

  @override
  String toString() => 'PurposeUpdated { purpose: $purpose }';
}

class PurposeDeleted extends PurposesEvent {
  final Purpose purpose;

  const PurposeDeleted(this.purpose);

  @override
  List<Object> get props => [purpose];

  @override
  String toString() => 'PurposeDeleted { purpose: $purpose }';
}