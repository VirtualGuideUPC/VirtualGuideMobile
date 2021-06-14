import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/ui/bloc/validators.dart';

class SigninBloc extends Validators{
  BehaviorSubject<String> _emailController    ;
  BehaviorSubject<String> _passwordController ;
  BehaviorSubject<String> _nameController     ;
  BehaviorSubject<String> _lastNameController ;
  BehaviorSubject<String> _countryController  ;
  BehaviorSubject<String> _birthDateController;
  BehaviorSubject<String> _requestResult;
  bool flagControllersAreClosed;
  SigninBloc(){
    flagControllersAreClosed=false;
    init();
  }
  // Recuperar los datos del Stream
  Stream<String> get emailStream    => _emailController.stream.transform( validateEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validatePassword );
  Stream<String> get nameStream => _nameController.stream.transform( validateName );
  Stream<String> get lastNameStream => _lastNameController.stream.transform( validateLastName );
  Stream<String> get countryStream => _countryController.stream;
  Stream<String> get birthDateStream => _birthDateController.stream.transform(validateBirthDate);
  Stream<String> get requestResultStream => _requestResult.stream;

  Stream<bool> get formValidStream => 
      Rx.combineLatest6(emailStream, passwordStream,nameStream,lastNameStream,countryStream,birthDateStream, (a,b,c,d,e,f) => true );

  // Insertar valores al Stream
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get changeCountry => _countryController.sink.add;
  Function(String) get changeBirthDate => _birthDateController.sink.add;
  Function(String) get changeRequestResult => _requestResult.sink.add;

    // Obtener el último valor ingresado a los streams
  String get email    => _emailController.value;
  String get password => _passwordController.value;
  String get name =>  _nameController.value;
  String get lastName =>_lastNameController.value;
  String get country =>_countryController.value;
  String get birthDate =>_birthDateController.value;
  String get requestResult => _requestResult.value;

  dispose() {
    _emailController.close();
    _passwordController.close();
    _nameController.close();
    _lastNameController.close();
    _countryController.close();
    _birthDateController.close();
    _requestResult.close();
    flagControllersAreClosed=true;
  }
  init(){
    if(_emailController!=null && !_emailController.isClosed){
      if(flagControllersAreClosed){throw new Exception('Race condition at SiginBloc');}
      return;
    }
    flagControllersAreClosed=false;
    
    _emailController    = BehaviorSubject<String>();
    _passwordController = BehaviorSubject<String>();
    _nameController     = BehaviorSubject<String>();
    _lastNameController = BehaviorSubject<String>();
    _countryController  = BehaviorSubject<String>();
    _birthDateController= BehaviorSubject<String>();
    _requestResult=BehaviorSubject<String>();
    }
  }