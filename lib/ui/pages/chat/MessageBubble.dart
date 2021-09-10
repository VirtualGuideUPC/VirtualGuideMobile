import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final int indx;
  const MessageBubble(this.message, this.indx);

  @override
  Widget build(BuildContext context) {
    message.isUser = true;
    return Align(
      alignment: message.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: message.isUser
                ? Color.fromRGBO(79, 77, 140, 1)
                : Color.fromRGBO(143, 142, 191, 1),
            borderRadius: BorderRadius.only(
                topRight:
                    message.isUser ? Radius.circular(10) : Radius.circular(0),
                bottomLeft: Radius.circular(10),
                topLeft:
                    !message.isUser ? Radius.circular(10) : Radius.circular(0),
                bottomRight: Radius.circular(10))),
        child: Text(
          message.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
