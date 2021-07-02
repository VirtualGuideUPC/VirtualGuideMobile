class Department{
  int id;
  String name;
  List<String> pictures;

  Department.fromJson(Map json){
    this.id=json["id"];
    this.name=json["name"];
    this.pictures=json["pictures"].cast<String>();
  }
}