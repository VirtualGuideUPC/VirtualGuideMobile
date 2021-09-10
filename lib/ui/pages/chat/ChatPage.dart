import 'package:flutter/material.dart';
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
    setState(() {
      _textController.text = "¡Escribe Algo!";
    });
    super.initState();
  }

  void sendMessage() {
    if (_textController.text.isNotEmpty) {
      messagesBloc.sendMessage(_textController.text);
      _textController.clear();
    }
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
            var messages = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (ctx, indx) {
                  return MessageBubble(messages[indx], indx);
                });
          } else {
            return Text("loading");
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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyText1.color),
                    decoration: InputDecoration(
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

    Widget _labelDay = Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      decoration: BoxDecoration(
          color: Color.fromRGBO(106, 194, 194, 1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        "Hoy",
        style: TextStyle(color: Colors.black),
      ),
    );

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
