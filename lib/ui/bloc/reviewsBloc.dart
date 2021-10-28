import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/review.dart';
import 'package:tour_guide/data/providers/reviewProvider.dart';
import 'package:tour_guide/data/providers/userProvider.dart';

class ReviewsBloc {
  ReviewProvider _reviewProvider = ReviewProvider();

  // ignore: close_sinks
  BehaviorSubject<List<Review>> _reviewController =
      BehaviorSubject<List<Review>>();
  Stream<List<Review>> get reviewsStream => _reviewController.stream;
  Function get changeReviews => _reviewController.sink.add;
  List<Review> get reviews => _reviewController.value;

  BehaviorSubject<int> reviewStars = BehaviorSubject<int>.seeded(1);
  Stream<int> get reviewStarsStream => reviewStars.stream;
  Function get changeStarsStream => reviewStars.sink.add;
  int get stars => reviewStars.stream.value;

  void changerating(stars) {
    changeStarsStream(stars);
  }

  void getReviewsByUserId() async {
    final _prefs = UserPreferences();

    final results =
        await _reviewProvider.getReviewsByUserId(_prefs.getUserId().toString());
    changeReviews(results);
  }
}
