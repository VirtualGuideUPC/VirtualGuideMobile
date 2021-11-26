import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tour_guide/data/datasource/messagesDb.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/message.dart';
import 'package:http/http.dart' as http;

class MessageProvider {
  Future<List<Message>> getMessages() async {
    final String userId = UserPreferences().getUserId().toString();

    final url = Uri.parse(
        'http://ec2-52-90-137-95.compute-1.amazonaws.com/api/users/message/userid/${userId}');

    final String userToken = UserPreferences().getToken();

    final http.Response resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });

    print("resopnde code: " + resp.statusCode.toString());
    if (resp.statusCode == 200) {
      List decodedJson =
          json.decode(Utf8Decoder().convert(resp.bodyBytes).toString()) as List;

      var messages = decodedJson.map((e) => Message.fromJson(e)).toList();

      return messages;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<Message> createMessage(String message) async {
    final String userId = UserPreferences().getUserId().toString();

    final url = Uri.parse(
        'http://ec2-54-172-42-125.compute-1.amazonaws.com/prediction');

    final String userToken = UserPreferences().getToken();

    String dateFormat =
        "${DateTime.now().toLocal().year.toString()}-${DateTime.now().toLocal().month.toString().padLeft(2, '0')}-${DateTime.now().toLocal().day.toString().padLeft(2, '0')}";

    var body = {
      "text": message,
      "user": int.parse(userId),
    };

    var resp = await Dio().post(url.toString(),
        data: body,
        options: Options(headers: <String, String>{
          'Authorization': userToken,
          'Cookie': 'session=$userToken',
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=5,max=100',
          'Content-Type': 'application/json; charset=UTF-8',
        }));

    print("resopnde code: " + resp.statusCode.toString());
    if (resp.statusCode == 200) {
      var messageHuman = Message.fromJson(resp.data['human_message']);
      messageHuman.isUser = true;
      var messageBot = Message.fromJson(resp.data['robot_response']);
      messageBot.isUser = false;

      print(messageHuman);
      print(messageBot);

      await MessagesDb().insertMessage(messageHuman);
      await MessagesDb().insertMessage(messageBot);
      return messageBot;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }
}
