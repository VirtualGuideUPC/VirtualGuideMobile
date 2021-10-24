import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tour_guide/data/datasource/messagesDb.dart';
import 'package:tour_guide/data/entities/message.dart';
import 'package:tour_guide/ui/bloc/messagesBloc.dart';
import 'package:tour_guide/ui/pages/chat/MessageBubble.dart';
import 'dart:math' as math;

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _textController = TextEditingController();
  var messagesBloc = MessagesBloc();
  bool _visible = true;
  bool _isLoading = false;
  ScrollController scrollController;

  @override
  void initState() {
    messagesBloc.getMessages();
    scrollController = new ScrollController()..addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void sendMessage() async {
    if (_textController.text.isNotEmpty) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        messagesBloc
            .sendMessage(_textController.text)
            .then((value) => {scrollDown(), FocusScope.of(context).unfocus()});
        _textController.clear();
      });
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

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _visible = false;
      });
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _visible = true;
      });
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
            var messages = snapshot.data as List<Message>;
            return messages.length > 0
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: messages.length,
                            itemBuilder: (ctx, indx) {
                              Widget _labelday = SizedBox();

                              if (indx == 0) {
                                _labelday = _labelDay(messages[0].date);
                              }

                              if (indx != 0 &&
                                  messages[indx].date !=
                                      messages[indx - 1].date) {
                                _labelday = _labelDay(messages[indx].date);
                              }

                              return Column(
                                children: [
                                  _labelday,
                                  MessageBubble(messages[indx], indx)
                                ],
                              );
                            }),
                      ),
                      if (_isLoading)
                        Container(
                            width: double.infinity - 100,
                            height: 40,
                            child: Image.asset(
                              'assets/img/loading-nobackground.gif',
                              fit: BoxFit.cover,
                            ))
                    ],
                  )
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
                  child: StreamBuilder(
                      stream: messagesBloc.singleMessage,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: _textController,
                          textAlign: TextAlign.left,
                          onChanged: (val) =>
                              messagesBloc.sinksingleMessage.add(val),
                          style: TextStyle(
                              fontSize: 18,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color),
                          decoration: InputDecoration(
                            hintText: "¡Escribe Algo!",
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)),
                          ),
                        );
                      }),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: StreamBuilder(
                      stream: messagesBloc.singleMessage,
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: _textController.text.length > 0
                                  ? Color.fromRGBO(106, 194, 194, 1)
                                  : Colors.grey,
                              padding: EdgeInsets.all(15),
                            ),
                            onPressed: () async {
                              if (_textController.text.length > 0) {
                                sendMessage();
                                setState(() {
                                  _isLoading = true;
                                });
                                await Future.delayed(Duration(seconds: 2))
                                    .then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.black,
                            ));
                      }),
                ))
          ],
        ),
      );
    }

    Widget downButton = Positioned(
      left: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: _visible ? 1.0 : 0.0,
        child: Transform.rotate(
          angle: 270 * math.pi / 180,
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                primary: Color.fromRGBO(106, 194, 194, 1),
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500),
                );
              },
              icon: Icon(Icons.arrow_back),
              label: Text("")),
        ),
      ),
    );

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Container(
          child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        child: _messagesArea(),
                      ),
                      /* ElevatedButton(
                        onPressed: () {
                          MessagesDb().deleteDftabase();
                        },
                        child: Text("Bajarse DB")),*/
                      downButton,
                    ],
                  ),
                ),
                _messageInput()
              ],
            ),
          ),
        ],
      )),
    ));
  }
}
