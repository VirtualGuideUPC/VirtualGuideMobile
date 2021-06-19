
class Experience {
  String uniqueId;

  String name;
  String costInfo;
  double price;
  String scheduleInfo;
  String historicInfo;
  String longInfo;
  String shortInfo;
  String activitiesInfo;
  String latitude;
  String longitude;
  int range;
  int province;
  int typePlace;

  Experience({
    this.name,
    this.costInfo,
    this.price,
    this.scheduleInfo,
    this.historicInfo,
    this.longInfo,
    this.shortInfo,
    this.activitiesInfo,
    this.latitude,
    this.longitude,
    this.range,
    this.province,
    this.typePlace,
  });
  Experience.fromJson(Map json){
    this.costInfo=json["cost_info"];
    this.name=json["name"];
    this.price=json["price"];
    this.scheduleInfo=json["schedule_info"];
    this.historicInfo=json["historic_info"];
    this.longInfo=json["long_info"];
    this.shortInfo=json["short_info"];
    this.activitiesInfo=json["activities_info"];
    this.latitude=json["latitude"];
    this.longitude=json["longitude"];
    this.range=json["range"];
    this.province=json["province"];
    this.typePlace=json["type_place"];
  }
  getPosterPath(){
    return "https://res.cloudinary.com/dfr41axmh/image/upload/v1624038048/duhxfihcm47a3ditxkrx.jpg";
  }
}
