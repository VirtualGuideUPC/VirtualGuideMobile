class TypePlace{
  int id;
  String name;
  String icon;
  bool isSelected;

  TypePlace.fromJson(Map json){
    this.id=json["typeplace_id"];
    this.name=json["name"];
    this.icon=json["icon"];
    this.isSelected=json["isSelected"];
  }
}