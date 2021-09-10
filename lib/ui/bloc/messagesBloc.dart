import 'package:rxdart/rxdart.dart';
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
    var messages = await messageProvider.getMessages();
    changeMessages(messages);
  }

  void sendMessage(message) async {
    await messageProvider.createMessage(message).then((value) {
      getMessages();
    });
  }
}
