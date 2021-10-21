import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/datasource/messagesDb.dart';
import 'package:tour_guide/data/entities/message.dart';
import 'package:tour_guide/data/providers/messageProvider.dart';

class MessagesBloc {
  MessageProvider messageProvider = MessageProvider();

  final _email = BehaviorSubject<String>.seeded('');

  BehaviorSubject<List<Message>> _messagesController =
      BehaviorSubject<List<Message>>();
  Stream<List<Message>> get messagesStream => _messagesController.stream;
  Function get changeMessages => _messagesController.sink.add;
  List<Message> get messages => _messagesController.value;

  Stream<String> get singleMessage => _email.stream.transform(validateMessage);
  Sink<String> get sinksingleMessage => _email.sink;

  final validateMessage =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0) {
      sink.add(value);
    } else {
      sink.addError('no text');
    }
  });

  void getMessages() async {
    List<Message> dbMessages = await MessagesDb().getAllMessagesDb();
    if (dbMessages.length > 0) {
      changeMessages(dbMessages);
    } else if (dbMessages.length == 0) {
      var messages = await messageProvider.getMessages();

      messages.forEach((element) {
        MessagesDb().insertMessage(element);
      });

      changeMessages(messages);
    }
  }

  Future<void> sendMessage(message) async {
    await messageProvider.createMessage(message).then((value) {
      getMessages();
    });
  }
}
