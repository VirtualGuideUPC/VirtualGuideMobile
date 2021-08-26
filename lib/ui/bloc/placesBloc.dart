import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/entities/review.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/data/providers/placesProvider.dart';
import 'package:tour_guide/data/providers/reviewProvider.dart';

class PlacesBloc {
  PlacesProvider placesProvider = PlacesProvider();
  ExperienceProvider experienceProvider = ExperienceProvider();
  ReviewProvider reviewProvider = ReviewProvider();

  BehaviorSubject<List<dynamic>> _searchResultsController =
      BehaviorSubject<List<dynamic>>();
  Stream<List<dynamic>> get searchResultStream =>
      _searchResultsController.stream;
  Function get changeSearchResult => _searchResultsController.sink.add;
  List<dynamic> get searchResult => _searchResultsController.value;

  BehaviorSubject<List<Experience>> _experiencesController =
      BehaviorSubject<List<Experience>>();
  Stream<List<Experience>> get experiencesStream =>
      _experiencesController.stream;
  Function get changeExperiences => _experiencesController.sink.add;
  List<Experience> get experiences => _experiencesController.value;

  BehaviorSubject<List<Review>> _reviewController =
      BehaviorSubject<List<Review>>();
  Stream<List<Review>> get reviewsStream => _reviewController.stream;
  Function get changeReviews => _reviewController.sink.add;
  List<Review> get reviews => _reviewController.value;

  void getLocations(String term) async {
    final results = await placesProvider.getLocations(term);
    changeSearchResult(results);
  }

  void getExperiences(String userId, double lat, double long) async {
    final List<Experience> experiences =
        await _getExperiences(userId, lat, long);
    changeExperiences(experiences);
    print("Experiencas encontradas -> " + experiences.length.toString());
  }

  Future<Map> getLocationDetail(String placeId) async {
    final Map locationDetail = await placesProvider.getLocationDetail(placeId);
    return locationDetail;
  }

  void postAddFavoriteExperience(String experienceId) async {
    await experienceProvider.postAddFavoriteExperience(experienceId);
  }

  Future<List<Experience>> _getExperiences(
      String userId, double lat, double lng) async {
    final List<Experience> experiences =
        await experienceProvider.getExperiences(userId, lat, lng);
    return experiences;
  }

  Future<ExperienceDetailed> getExperienceDetail(String experienceId) async {
    try {
      return await experienceProvider.getExperienceDetail(experienceId);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Review>> _getReviews(String touristicPlaceId) async {
    return await reviewProvider.getReviewsFromTouristicPlace(touristicPlaceId);
  }

  Future<Review> postReview(
      CreateReviewDto createReviewDto, List<File> pictures) async {
    await reviewProvider.createReview(createReviewDto, pictures);
  }

  void dispose() {
    _searchResultsController?.close();
    _experiencesController?.close();
  }
}
