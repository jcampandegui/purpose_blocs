import 'package:equatable/equatable.dart';
import 'package:purpose_blocs/models/app_tab.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class UpdateNavigation extends NavigationEvent {
  final AppTab appTab;

  const UpdateNavigation(this.appTab);

  @override
  List<Object> get props => [appTab];

  @override
  String toString() => 'UpdateNavigation { appTab: $appTab }';
}