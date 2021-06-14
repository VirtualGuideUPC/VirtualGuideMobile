import 'dart:async';



class Validators {

  final validateName= StreamTransformer<String,String>.fromHandlers(handleData: (name,sink){
    Pattern pattern=r'[^\d]+';
    RegExp  regExp=new RegExp(pattern);
    if(regExp.hasMatch(name)){
      sink.add(name);
    }else{
      sink.addError('El nombre no es valido');
    }
  });
  final validateLastName= StreamTransformer<String,String>.fromHandlers(handleData: (lastName,sink){
    Pattern pattern=r'[^\d]+';
    RegExp  regExp=new RegExp(pattern);
    if(regExp.hasMatch(lastName)){
      sink.add(lastName);
    }else{
      sink.addError('El apellido no es valido');
    }
  });

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: ( email, sink ) {


      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp   = new RegExp(pattern);

      if ( regExp.hasMatch( email ) ) {
        sink.add( email );
      } else {
        sink.addError('El correo no es correcto');
      }

    }
  );


  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {

      if ( password.length >= 6 ) {
        sink.add( password );
      } else {
        sink.addError('Más de 6 caracteres por favor');
      }

    }
  );

  final validateBirthDate= StreamTransformer<String,String>.fromHandlers(handleData: (birthDate,sink){
    Pattern pattern=r'^(\d{1,2})/(\d{1,2})/(\d{4})$';
    RegExp  regExp=new RegExp(pattern);
    if(regExp.hasMatch(birthDate)){
      sink.add(birthDate);
    }else{
      sink.addError('Formato no válido');
    }
  });


}
