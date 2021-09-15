import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/message.dart';
import 'package:tour_guide/ui/bloc/messagesBloc.dart';
import 'package:tour_guide/ui/pages/chat/MessageBubble.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _textController = TextEditingController();
  var messagesBloc = MessagesBloc();
  @override
  void initState() {
    messagesBloc.getMessages();

    super.initState();
  }

  void sendMessage() {
    if (_textController.text.isNotEmpty) {
      messagesBloc.sendMessage(_textController.text);
      _textController.clear();
    }
  }

  Widget _labelDay(String date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      decoration: BoxDecoration(
          color: Color.fromRGBO(106, 194, 194, 1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        date,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;
    var backgroundColor = Theme.of(context).dialogBackgroundColor;

    Widget _messagesArea() {
      return StreamBuilder(
        stream: messagesBloc.messagesStream,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            var messages = snapshot.data as List<Message>;
            return messages.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (ctx, indx) {
                      Widget _labelday = SizedBox();

                      if (indx != 0 &&
                          messages[indx].date != messages[indx - 1].date) {
                        _labelday = _labelDay(messages[indx].date);
                      }

                      return Column(
                        children: [
                          _labelday,
                          MessageBubble(messages[indx], indx)
                        ],
                      );
                    })
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("No ha creado mensajes")
                    ],
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }
        },
      );
    }

    Widget _messageInput() {
      return Container(
        color: backgroundColor,
        width: _screenWidth,
        child: Row(
          children: [
            Flexible(
                flex: 5,
                child: Container(
                  child: TextFormField(
                    controller: _textController,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyText1.color),
                    decoration: InputDecoration(
                      hintText: "¡Escribe Algo!",
                      hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color)),
                    ),
                  ),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        primary: Color.fromRGBO(106, 194, 194, 1),
                        padding: EdgeInsets.all(15),
                      ),
                      onPressed: () {
                        sendMessage();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                      )),
                ))
          ],
        ),
      );
    }

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: _messagesArea(),
              ),
            ),
            _messageInput()
          ],
        ),
      ),
    ));
  }
}
