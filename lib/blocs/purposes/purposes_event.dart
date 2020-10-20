import 'package:equatable/equatable.dart';
import 'package:purpose_blocs/models/purpose.dart';

abstract class PurposesEvent extends Equatable {
  const PurposesEvent();

  @override
  List<Object> get props => [];
}

class PurposesLoad extends PurposesEvent {}

class AddPurpose extends PurposesEvent {
  final Purpose purpose;

  const AddPurpose(this.purpose);

  @override
  List<Object> get props => [purpose];

  @override
  String toString() => 'AddPurpose { purpose: $purpose }';
}

class UpdatePurpose extends PurposesEvent {
  final Purpose purpose;

  const UpdatePurpose(this.purpose);

  @override
  List<Object> get props => [purpose];

  @override
  String toString() => 'UpdatePurpose { purpose: $purpose }';
}

class DeletePurpose extends PurposesEvent {
  final Purpose purpose;

  const DeletePurpose(this.purpose);

  @override
  List<Object> get props => [purpose];

  @override
  String toString() => 'DeletePurpose { purpose: $purpose }';
}

class LoadPurposesInDay extends PurposesEvent {
  final DateTime date;

  const LoadPurposesInDay(this.date);

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'LoadPurposesInDay { date: $date }';
}