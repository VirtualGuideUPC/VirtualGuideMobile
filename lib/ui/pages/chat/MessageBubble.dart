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
    var _screenWidth = MediaQuery.of(context).size.width;
    print(message.url.length);
    return Align(
      alignment: !message.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        constraints: BoxConstraints(maxWidth: _screenWidth * 0.7, minWidth: 10),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: Colors.white),
            ),
            if (message.url.length > 14)
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: _screenWidth * 0.7,
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(message.url), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(143, 142, 191, 1)),
              ),
            Container(
              constraints: BoxConstraints(maxWidth: _screenWidth * 0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: message.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        parseTime(message.time),
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      /* if (!message.isUser)
                        Container(
                          margin: EdgeInsets.all(5),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                        )*/
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
