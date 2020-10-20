import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:purpose_blocs/models/purpose_dao.dart';
import 'purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';

class PurposesBloc extends Bloc<PurposesEvent, PurposesState> {
  PurposeDao _purposeDao = PurposeDao();

  PurposesBloc() : super(PurposesLoadInProgress());

  @override
  Stream<PurposesState> mapEventToState(PurposesEvent event) async* {
    if (event is PurposesLoad) {
      yield* _mapPurposesLoadToState();
    } else if (event is AddPurpose) {
      yield* _mapPurposeAddedToState(event);
    } else if (event is UpdatePurpose) {
      yield* _mapPurposeUpdatedToState(event);
    } else if (event is DeletePurpose) {
      yield* _mapPurposeDeletedToState(event);
    }
  }

  Stream<PurposesState> _mapPurposesLoadToState() async* {
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

  Stream<PurposesState> _reloadPurposes() async* {
    //final List<Purpose > purposes = await _purposeDao.getAll();
    int weekDay = DateTime.now().weekday;
    final List<Purpose > purposes = await _purposeDao.getForSelectedDay(weekDay);
    yield PurposesLoadSuccess(purposes);
  }
}