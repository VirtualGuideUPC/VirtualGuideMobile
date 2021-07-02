class ExperienceDetailed {
  List<String> pictures;
  String name;
  String longInfo;
  List<Type> types;
  String latitude;
  String longitude;
  double ranking;
  int numberComments;
  List<Review> reviews;
  List<SimilarExperience> similarExperience;

  ExperienceDetailed({
    this.pictures,
    this.name,
    this.longInfo,
    this.types,
    this.latitude,
    this.longitude,
    this.ranking,
    this.numberComments,
    this.reviews,
    this.similarExperience,
  });
  ExperienceDetailed.fromJson(Map json){
    this.pictures=json["pictures"].cast<String>();
    this.name=json["name"];
    this.longInfo=json["long_info"];
    this.types=json["types"].map((item)=>Type.fromJson(item)).toList().cast<Type>();
    this.latitude=json["latitude"];
    this.longitude=json["longitude"];
    this.ranking=json["ranking"];
    this.numberComments=json["number_comments"];
    this.reviews=json["reviews"].map((item)=>Review.fromJson(item)).toList().cast<Review>();
    this.similarExperience=json["similar_experience"].map((item)=>SimilarExperience.fromJson(item)).toList().cast<SimilarExperience>();
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
    this.id=json["id"];
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
  bool isFavorite;
  String shortInfo;

  SimilarExperience({
    this.id,
    this.name,
    this.pic,
    this.isFavorite,
    this.shortInfo,
  });
  SimilarExperience.fromJson(Map json){
    this.id=json["id"];
    this.name=json["name"];
    this.pic=json["pic"];
    this.isFavorite=json["is_favorite"];
    this.shortInfo=json["short_info"];
  }
}

class Type {
  int id;
  String name;
  int nExperiences;

  Type({
    this.id,
    this.name,
    this.nExperiences,
  });
  Type.fromJson(Map json){
    this.id=json["id"];
    this.name=json["name"];
    this.nExperiences=json["n_experiences"];
  }
}
