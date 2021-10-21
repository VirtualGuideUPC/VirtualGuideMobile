import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:tour_guide/data/entities/review.dart';

class ReviewProvider {
  Future<List<Review>> getReviewsFromTouristicPlace(
      String touristicPlaceId) async {
    final url = Uri.parse(
        'http://ec2-34-226-195-132.compute-1.amazonaws.com/api/reviews/tp/$touristicPlaceId/');

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

  Future<Review> createReview(
      CreateReviewDto createReviewDto, List<File> pictures) async {
    final url = Uri.parse(
        'http://ec2-34-226-195-132.compute-1.amazonaws.com/api/reviews/create/');

    final String userToken = UserPreferences().getToken();

    var formData = FormData.fromMap({
      "comment": createReviewDto.comment,
      "comment_ranking": createReviewDto.commentRanking,
      "date": createReviewDto.date,
      "ranking": createReviewDto.ranking,
      "touristic_place": createReviewDto.touristicPlace,
      "user": createReviewDto.user,
    });
    if (pictures.length > 0) {
      for (var file in pictures) {
        formData.files.addAll([
          MapEntry("image", await MultipartFile.fromFile(file.path)),
        ]);
      }
    }

    var resp = await Dio().post(url.toString(),
        data: formData,
        options: Options(headers: <String, String>{
          'Authorization': userToken,
          'Cookie': 'jwt=$userToken'
        }));

    print("resopnde code: " + resp.statusCode.toString());

    if (resp.statusCode == 200) {
      var data = resp.data as Map<String, dynamic>;

      var review = Review(
          comment: data['comment'],
          commentRanking: data['comment_ranking'],
          date: data['date'],
          ranking: data['ranking'],
          touristicPlace: data['touristic_place'],
          user: data['user'],
          id: data['review_id']);
      return review;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<List<Review>> getReviewsByUserId(String UserId) async {
    final url = Uri.parse(
        'http://ec2-34-226-195-132.compute-1.amazonaws.com/api/reviews/user/$UserId');

    final String userToken = UserPreferences().getToken();

    final http.Response resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userToken,
      'Cookie': 'jwt=$userToken'
    });
    print("resopnde code: " + resp.statusCode.toString());

    if (resp.statusCode == 200) {
      var decodedJson =
          json.decode(Utf8Decoder().convert(resp.bodyBytes).toString()) as List;
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
}
