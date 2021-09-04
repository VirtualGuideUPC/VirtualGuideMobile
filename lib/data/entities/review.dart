class Review {
  int id;
  String userName;
  String profilePic;
  String date;
  String comment;
  int commentRanking;
  int touristicPlace;
  int user;
  int ranking;
  List<ReviewImage> images;
  String touristicPlaceName;
  String province;

  Review(
      {this.id,
      this.userName,
      this.profilePic,
      this.date,
      this.comment,
      this.ranking,
      this.commentRanking,
      this.touristicPlace,
      this.user,
      this.touristicPlaceName,
      this.province});

  Review.fromJson(Map json) {
    this.id = json["review_id"];
    this.userName = json["user_name"];
    this.profilePic = json["profile_pic"];
    this.date = json["date"];
    this.comment = json["comment"];
    this.ranking = json["ranking"];
    this.commentRanking = json["comment_ranking"];
    this.touristicPlace = json["touristic_place"];
    this.user = json["user"];
    this.touristicPlaceName = json["touristic_place_name"] ?? '';
    this.province = json["province"] ?? '';
    this.images = json["images"]
        ?.map((item) => ReviewImage.fromJson(item))
        ?.toList()
        ?.cast<ReviewImage>();
  }
}

class ReviewImage {
  String url;
  int number;

  ReviewImage(this.url, this.number);
  ReviewImage.fromJson(Map json) {
    this.url = json["url"];
    this.number = json["number"];
  }
}

class CreateReviewDto {
  String comment;
  int commentRanking;
  String date;
  int ranking;
  int touristicPlace;
  int user;

  CreateReviewDto(
      {this.comment,
      this.commentRanking,
      this.date,
      this.ranking,
      this.touristicPlace,
      this.user});
}
