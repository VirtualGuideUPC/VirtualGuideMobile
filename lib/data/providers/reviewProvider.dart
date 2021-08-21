import 'dart:convert';

import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:tour_guide/data/entities/review.dart';

class ReviewProvider {
  Future<List<Review>> getReviewsFromTouristicPlace(
      String touristicPlaceId) async {
    final url = Uri.parse(
        'https://virtualguide2.herokuapp.com/api/reviews/tp/$touristicPlaceId/');

    final String userToken = UserPreferences().getToken();

    final http.Response resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });
    print("resopnde code: " + resp.statusCode.toString());

    if (resp.statusCode == 200) {
      var decodedJson = json.decode(resp.body) as List;
      print(decodedJson);
      var items = decodedJson.map((e) => Review.fromJson(e)).toList();
      return items;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<Review> createReview(CreateReviewDto createReviewDto) async {
    final url =
        Uri.parse('https://virtualguide2.herokuapp.com/api/reviews/create/');

    final String userToken = UserPreferences().getToken();

    var body = jsonEncode({
      "comment": createReviewDto.comment,
      "comment_ranking": createReviewDto.commentRanking,
      "date": createReviewDto.date,
      "ranking": createReviewDto.ranking,
      "touristic_place": createReviewDto.touristicPlace,
      "user": createReviewDto.user
    });

    final http.Response resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userToken,
          'Cookie': 'jwt=$userToken'
        },
        body: body);
    print("resopnde code: " + resp.statusCode.toString());

    if (resp.statusCode == 200) {
      var decodedJson = json.decode(resp.body);
      print(decodedJson);
      var review = Review.fromJson(decodedJson);
      return review;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }
}
