// class Experience {
//   String uniqueId;

//   String name;
//   String costInfo;
//   double price;
//   String scheduleInfo;
//   String historicInfo;
//   String longInfo;
//   String shortInfo;
//   String activitiesInfo;
//   String latitude;
//   String longitude;
//   int tpRange;
//   int province;
//   int typePlace;

//   Experience({
//     this.name,
//     this.costInfo,
//     this.price,
//     this.scheduleInfo,
//     this.historicInfo,
//     this.longInfo,
//     this.shortInfo,
//     this.activitiesInfo,
//     this.latitude,
//     this.longitude,
//     this.tpRange,
//     this.province,
//     this.typePlace,
//   });
//   Experience.fromJson(Map json){
//     this.costInfo=json["cost_info"];
//     this.name=json["name"];
//     this.price=json["price"];
//     this.scheduleInfo=json["schedule_info"];
//     this.historicInfo=json["historic_info"];
//     this.longInfo=json["long_info"];
//     this.shortInfo=json["short_info"];
//     this.activitiesInfo=json["activities_info"];
//     this.latitude=json["latitude"];
//     this.longitude=json["longitude"];
//     this.tpRange=json["tp_range"];
//     this.province=json["province"];
//     this.typePlace=json["type_place"];
//   }
//   getPosterPath(){
//     return "https://res.cloudinary.com/dfr41axmh/image/upload/v1624038048/duhxfihcm47a3ditxkrx.jpg";
//   }
// }
class Experience {
  int id;
  String name;
  String shortInfo;
  String latitude;
  String longitude;
  String picture;
  int tpRange;
  String province;
  int typePlace;
  bool isFavorite;
  bool isRecommended;
  double avgRanking;
  int nComments;

  Experience(
      {this.id,
      this.name,
      this.shortInfo,
      this.latitude,
      this.longitude,
      this.picture,
      this.tpRange,
      this.province,
      this.typePlace,
      this.isFavorite,
      this.avgRanking,
      this.nComments,
      this.isRecommended});
  Experience.fromJson(Map json) {
    this.id = json["touristicplace_id"];
    this.name = json["name"];
    this.shortInfo = json["short_info"];
    this.latitude = json["latitude"];
    this.longitude = json["longitude"];
    this.picture = json["picture"];
    this.tpRange = json["tp_range"];
    this.province = json["province_name"];
    this.typePlace = json["type_place"];
    this.isFavorite = json["isFavourite"] ?? false;
    this.isRecommended = json["isRecommended"] ?? false;
    this.avgRanking = (json["avg_ranking"] ?? 1) / 1;
    this.nComments = json["number_comments"];
  }
  String getPosterPath() {
    return this.picture;
  }
}
