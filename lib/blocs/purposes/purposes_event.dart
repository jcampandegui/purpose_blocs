import 'package:equatable/equatable.dart';
import 'package:purpose_blocs/models/purpose.dart';

abstract class PurposesEvent extends Equatable {
  const PurposesEvent();

  @override
  List<Object> get props => [];
}

class PurposesLoad extends PurposesEvent {
  final DateTime date;

  const PurposesLoad({this.date});

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'PurposesLoad { date: $date }';
}

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

class CheckBrokenPurposes extends PurposesEvent {
  final DateTime debugDate;

  const CheckBrokenPurposes({this.debugDate});

  @override
  List<Object> get props => [debugDate];

  @override
  String toString() => 'CheckBrokenPurposes { date: ${debugDate.toString()} }';
}