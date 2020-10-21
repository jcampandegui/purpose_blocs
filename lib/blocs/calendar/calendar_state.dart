import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationUpdated extends NavigationState {
  final Widget currentView;

  const NavigationUpdated(this.currentView);

  @override
  List<Object> get props => [currentView];

  @override
  String toString() => 'NavigationUpdated { currentView: $currentView }';
}