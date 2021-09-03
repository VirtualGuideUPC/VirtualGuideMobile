import 'package:rxdart/rxdart.dart';

class UserProfileBloc {
  final _birthdayController = BehaviorSubject<String>();
  Stream<String> get birthdayStream => _birthdayController.stream;
  Function(String) get changeBirthday => _birthdayController.sink.add;
  String get getBirthday => _birthdayController.value;
}
