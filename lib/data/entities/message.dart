class Message {
  int id;
  String text;
  int user;
  String date;
  bool isUser;
  String time;
  String url;

  Message({this.text, this.user, this.date, this.isUser, this.url, this.time});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        text: json["text"],
        date: json["date"],
        time: json["time"],
        isUser: json["is_user"],
        url: json["url"],
        user: json["user"]);
  }
}
