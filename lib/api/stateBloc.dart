import 'dart:async';

class StateHandlerBloc {
  final StreamController<dynamic> _stateStreamController =
      StreamController<dynamic>.broadcast();

  StreamSink<dynamic> get stateSink => _stateStreamController.sink;

  Stream<dynamic> get stateStream => _stateStreamController.stream;

  storeData(dynamic data) async {
    try {
      stateSink.add(data);
    } catch (e) {
      stateSink.add(e);
    }
  }

  dispose() {
    _stateStreamController.close();
  }
}

final notificationCountBloc = StateHandlerBloc(); //bottom nav
final appointmentNotificationCountBloc =
    StateHandlerBloc(); // doctor lai auune appoint noti
final allNurseNotificationCountBloc = StateHandlerBloc();
final allDoctorNotificationCountBloc = StateHandlerBloc();
final userSideAppointmentNotificationCountBloc =
    StateHandlerBloc(); // user lai auune appoint noti
final nurseAppointmentNotificationCountBloc =
    StateHandlerBloc(); // nurse lai auune appoint noti
final orderNotificationCountBloc = StateHandlerBloc();
final newsNotificationCountBloc = StateHandlerBloc();
final mapBloc = StateHandlerBloc();
