import 'dart:convert';

import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/message.dart';
import 'package:http/http.dart' as http;

class MessageProvider {
  Future<List<Message>> getMessages() async {
    final String userId = UserPreferences().getUserId().toString();

    final url = Uri.parse(
        'https://virtualguide2.herokuapp.com/api/users/message/userid/${userId}');

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
        'https://virtualguide2.herokuapp.com/api/users/message/create/');

    final String userToken = UserPreferences().getToken();

    String dateFormat =
        "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

    var body = {
      "text": message,
      "user": int.parse(userId),
      "date": dateFormat,
      "is_user": true,
      "url": "www.test10.com"
    };

    final http.Response resp =
        await http.post(url, body: jsonEncode(body), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });

    print("resopnde code: " + resp.statusCode.toString());
    if (resp.statusCode == 200) {
      var decodedJson =
          json.decode(Utf8Decoder().convert(resp.bodyBytes).toString());

      var message = Message.fromJson(decodedJson);

      return message;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }
}
