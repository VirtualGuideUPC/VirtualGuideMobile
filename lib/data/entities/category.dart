class Category{
  int id;
  String name;
  String icon;
  bool isSelected;

  Category.fromJson(Map json){
    this.id=json["id"];
    this.name=json["name"];
    this.icon=json["icon"];
    this.isSelected=json["isSelected"];
  }
}