import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/entities/category.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/ui/bloc/validators.dart';

class LoginBloc with Validators {
  final userProvider = UserProvider();

  BehaviorSubject<String> _emailController;

  BehaviorSubject<String> _passwordController;

  BehaviorSubject<String> _requestResult;
  bool flagControllersAreClosed;

  LoginBloc() {
    flagControllersAreClosed = false;
    init();
  }

  // Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<String> get requestResultStream => _requestResult.stream;

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  Function(String) get changeRequestResult => _requestResult.sink.add;

  // Obtener el último valor ingresado a los streams
  String get email => _emailController.value;

  String get password => _passwordController.value;

  String get requestResult => _requestResult.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _requestResult?.close();
    flagControllersAreClosed = true;
  }

  init() {
    if (_emailController != null && !_emailController.isClosed) {
      if (flagControllersAreClosed) {
        throw new Exception('Race condition at LoginBloc');
      }
      return;
    }
    flagControllersAreClosed = false;
    _emailController = BehaviorSubject<String>();
    _passwordController = BehaviorSubject<String>();
    _requestResult = BehaviorSubject<String>();
  }

  Future<String> login(String email) async {
    try {
      return await userProvider.loginUser(email);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      return await userProvider.getCategories();
    } catch (e) {
      return Future.error(e);
    }
  }

}
