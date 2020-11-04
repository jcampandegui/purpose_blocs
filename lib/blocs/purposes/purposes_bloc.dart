import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:purpose_blocs/blocs/calendar/calendar_barrel.dart';
import 'package:purpose_blocs/models/purpose_dao.dart';
import 'purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';

class PurposesBloc extends Bloc<PurposesEvent, PurposesState> {
  PurposeDao _purposeDao = PurposeDao();
  final CalendarBloc calendarBloc;
  StreamSubscription calendarSubscription;

  DateTime currentDate;

  PurposesBloc({@required this.calendarBloc})
      : super(PurposesLoadInProgress()) {
    currentDate = calendarBloc.state;

    calendarSubscription = calendarBloc.listen((state) {
      currentDate = state;
      add(PurposesLoad());
    });
  }

  @override
  Stream<PurposesState> mapEventToState(PurposesEvent event) async* {
    if (event is PurposesLoad) {
      yield* _mapPurposesLoadToState(event);
    } else if (event is AddPurpose) {
      yield* _mapPurposeAddedToState(event);
    } else if (event is UpdatePurpose) {
      yield* _mapPurposeUpdatedToState(event);
    } else if (event is DeletePurpose) {
      yield* _mapPurposeDeletedToState(event);
    } else if(event is CheckBrokenPurposes) {
      yield* _mapCheckBrokenPurposesToState();
    }
  }

  Stream<PurposesState> _mapPurposesLoadToState(PurposesLoad event) async* {
    try {
      yield* _reloadPurposes();
    } catch (_) {
      yield PurposesLoadFailure();
    }
  }

  Stream<PurposesState> _mapPurposeAddedToState(AddPurpose event) async* {
    await _purposeDao.insert(event.purpose);
    yield* _reloadPurposes();
  }

  Stream<PurposesState> _mapPurposeUpdatedToState(UpdatePurpose event) async* {
    await _purposeDao.update(event.purpose);
    yield* _reloadPurposes();
  }

  Stream<PurposesState> _mapPurposeDeletedToState(DeletePurpose event) async* {
    await _purposeDao.delete(event.purpose);
    yield* _reloadPurposes();
  }

  Stream<PurposesState>  _mapCheckBrokenPurposesToState() async* {
    await _purposeDao.markBroken();
    yield* _reloadPurposes();
  }

  Stream<PurposesState> _reloadPurposes({bool all = false}) async* {
    List<Purpose > purposes;
    if (all) purposes = await _purposeDao.getAll();
    else purposes = await _purposeDao.getForSelectedDay(this.currentDate);
    yield PurposesLoadSuccess(purposes);
  }

  @override
  Future<void> close() {
    calendarSubscription.cancel();
    return super.close();
  }
}