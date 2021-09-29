import 'package:tour_guide/data/entities/review.dart';

class ExperienceDetailed {
  List<String> pictures;
  String name;
  String longInfo;
  List<Category> categories;
  String latitude;
  String longitude;
  double avgRanking;
  bool isFavourite;
  int numberComments;
  int id;
  List<Review> reviews;
  List<SimilarExperience> similarExperience;

  ExperienceDetailed(
      {this.pictures,
      this.name,
      this.longInfo,
      this.categories,
      this.latitude,
      this.longitude,
      this.avgRanking,
      this.numberComments,
      this.reviews,
      this.similarExperience,
      this.id,
      this.isFavourite});

  ExperienceDetailed.fromJson(Map json) {
    this.id = json["id"];
    this.pictures = json["pictures"]
        ?.map((item) {
          return item["url"];
        })
        ?.toList()
        ?.cast<String>();
    this.name = json["name"];
    this.longInfo = json["long_info"];
    this.categories = json["categories"]
        ?.map((item) => Category.fromJson(item))
        ?.toList()
        ?.cast<Category>();
    this.latitude = json["latitude"];
    this.longitude = json["longitude"];
    this.isFavourite = json["isFavourite"];
    this.avgRanking = json["avg_ranking"] != null ? json["avg_ranking"] / 1 : 0;
    this.numberComments = json["number_comments"];
    this.reviews = json["reviews"]
        ?.map((item) => Review.fromJson(item))
        ?.toList()
        ?.cast<Review>();
    this.similarExperience = json["similarExperiences"]
        ?.map((item) => SimilarExperience.fromJson(item))
        ?.toList()
        ?.cast<SimilarExperience>();
  }
}

class SimilarExperience {
  int id;
  String name;
  String pic;
  String shortInfo;
  String province;
  double avgRanking;
  int numberComments;

  SimilarExperience(
      {this.id,
      this.name,
      this.pic,
      this.shortInfo,
      this.avgRanking,
      this.numberComments});

  SimilarExperience.fromJson(Map json) {
    this.id = json["touristicplace_id"];
    this.name = json["name"];
    this.pic = json["picture"];
    this.shortInfo = json["short_info"];
    this.province = json["province_name"];
    this.avgRanking = json["avg_ranking"] / 1;
    this.numberComments = json["number_comments"];
  }
}

class Category {
  int id;
  String name;
  int nExperiences;

  Category({
    this.id,
    this.name,
    this.nExperiences,
  });

  Category.fromJson(Map json) {
    this.id = json["id"];
    this.name = json["name"];
    this.nExperiences = json["n_experiences"];
  }
}
