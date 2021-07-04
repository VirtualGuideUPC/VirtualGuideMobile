class ExperienceDetailed {
  List<String> pictures;
  String name;
  String longInfo;
  List<Category> categories;
  String latitude;
  String longitude;
  double avgRanking;
  int numberComments;
  List<Review> reviews;
  List<SimilarExperience> similarExperience;

  ExperienceDetailed({
    this.pictures,
    this.name,
    this.longInfo,
    this.categories,
    this.latitude,
    this.longitude,
    this.avgRanking,
    this.numberComments,
    this.reviews,
    this.similarExperience,
  });
  ExperienceDetailed.fromJson(Map json){
    this.pictures=json["pictures"]?.map((item){return item["url"];})?.toList()?.cast<String>();
    this.name=json["name"];
    this.longInfo=json["long_info"];
    this.categories=json["categories"]?.map((item)=>Category.fromJson(item))?.toList()?.cast<Category>();
    this.latitude=json["latitude"];
    this.longitude=json["longitude"];
    this.avgRanking=json["avg_ranking"]/1;
    this.numberComments=json["number_comments"];
    this.reviews=json["reviews"]?.map((item)=>Review.fromJson(item))?.toList()?.cast<Review>();
    this.similarExperience=json["similarExperiences"]?.map((item)=>SimilarExperience.fromJson(item))?.toList()?.cast<SimilarExperience>();
  }
}

class Review {
  int id;
  String userName;
  String profilePic;
  String date;
  String comment;
  int ranking;

  Review({
    this.id,
    this.userName,
    this.profilePic,
    this.date,
    this.comment,
    this.ranking,
  });
  Review.fromJson(Map json){
    this.id=json["review_id"];
    this.userName=json["user_name"];
    this.profilePic=json["profile_pic"];
    this.date=json["date"];
    this.comment=json["comment"];
    this.ranking=json["ranking"];
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

  SimilarExperience({
    this.id,
    this.name,
    this.pic,
    this.shortInfo,
    this.avgRanking,
    this.numberComments
  });
  SimilarExperience.fromJson(Map json){
    this.id=json["touristicplace_id"];
    this.name=json["name"];
    this.pic=json["picture"];
    this.shortInfo=json["short_info"];
    this.province=json["province_name"];
    this.avgRanking=json["avg_ranking"]/1;
    this.numberComments=json["number_comments"];
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
  Category.fromJson(Map json){
    this.id=json["id"];
    this.name=json["name"];
    this.nExperiences=json["n_experiences"];
  }
}
