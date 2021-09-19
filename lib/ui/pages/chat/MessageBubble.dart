import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final int indx;
  const MessageBubble(this.message, this.indx);

  String parseTime(String time) {
    var timeparse = time.split(":");
    print(timeparse);

    var hour = int.parse(timeparse[0]);
    var decoration;
    if (hour > 12) {
      decoration = "pm";
    } else {
      decoration = "am";
    }
    var newTime = timeparse[0] + ":" + timeparse[1] + " ${decoration}";

    return newTime;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: !message.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: message.isUser
                ? Color.fromRGBO(79, 77, 140, 1)
                : Color.fromRGBO(143, 142, 191, 1),
            borderRadius: BorderRadius.only(
                topRight:
                    !message.isUser ? Radius.circular(10) : Radius.circular(0),
                bottomLeft: Radius.circular(10),
                topLeft:
                    message.isUser ? Radius.circular(10) : Radius.circular(0),
                bottomRight: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(color: Colors.white),
            ),
            Container(
              width: 55,
              child: Row(
                children: [
                  Text(
                    parseTime(message.time),
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
