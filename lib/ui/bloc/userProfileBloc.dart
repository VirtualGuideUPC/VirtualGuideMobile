import 'dart:async';

import 'package:rxdart/rxdart.dart';

class UserProfileBloc {
  final _name = BehaviorSubject<String>();
  final _lastname = BehaviorSubject<String>();

  Stream<String> get name => _name.stream.transform(validateNameOrLastName);
  Sink<String> get sinkName => _name.sink;

  Stream<String> get lastname =>
      _lastname.stream.transform(validateNameOrLastName);
  Sink<String> get sinkLastname => _lastname.sink;

  final validateNameOrLastName =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length != 1) {
      isNameOrLastName(value)
          ? sink.add(value)
          : sink.addError('datos incorrectos');
    }
  });

  static bool isNameOrLastName(String name) {
    String value = r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$";

    RegExp regExp = RegExp(value);
    return regExp.hasMatch(name);
  }

  final _birthdayController = BehaviorSubject<String>();
  Stream<String> get birthdayStream =>
      _birthdayController.stream.transform(validateBirthday);
  Function(String) get changeBirthday => _birthdayController.sink.add;
  Sink<String> get sinkBirthday => _birthdayController.sink;

  String get getBirthday => _birthdayController.value;

  final validateBirthday =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length != 1) {
      hasEnoughAge(value)
          ? sink.add(value)
          : sink.addError('Debe ser mayor de 14 años');
    }
  });

  static bool hasEnoughAge(String date) {
    DateTime birthDay = DateTime.parse(date);
    DateTime today = DateTime.now();

    int totalDays = today.difference(birthDay).inDays;

    int years = totalDays ~/ 365;

    return years > 14;
  }
}
