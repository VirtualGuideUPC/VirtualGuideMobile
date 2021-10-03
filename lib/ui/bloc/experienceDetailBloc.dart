import 'package:flutter/cupertino.dart';

enum ExperienceDetailState { normal, details }

class ExperienceDetailBloc with ChangeNotifier {
  ExperienceDetailState detailedState = ExperienceDetailState.normal;

  void changeToNormal() {
    this.detailedState = ExperienceDetailState.normal;
    notifyListeners();
  }

  void changeToDetails() {
    this.detailedState = ExperienceDetailState.details;
    notifyListeners();
  }
}
