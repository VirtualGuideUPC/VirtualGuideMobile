import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/datasource/messagesDb.dart';
import 'package:tour_guide/data/entities/message.dart';
import 'package:tour_guide/data/providers/messageProvider.dart';

class MessagesBloc {
  MessageProvider messageProvider = MessageProvider();

  BehaviorSubject<List<Message>> _messagesController =
      BehaviorSubject<List<Message>>();
  Stream<List<Message>> get messagesStream => _messagesController.stream;
  Function get changeMessages => _messagesController.sink.add;
  List<Message> get messages => _messagesController.value;

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

  void sendMessage(message) async {
    await messageProvider.createMessage(message).then((value) {
      getMessages();
    });
  }
}
