import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/entities/preferences.dart';
import 'package:tour_guide/data/providers/preferencesProvider.dart';

class PreferencesBloc {
  BehaviorSubject<Preferences> _preferencesController =
      BehaviorSubject<Preferences>();

  Stream<Preferences> get preferencesStream => _preferencesController.stream;
  Function get changePreferences => _preferencesController.sink.add;
  Preferences get getPreferences => _preferencesController.value;

  void getPreferencesData() async {
    final result = await PreferencesProvider().getPreferencesByUser();
    changePreferences(result);
  }
}
