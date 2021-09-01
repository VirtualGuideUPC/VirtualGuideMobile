class Subcategory{
  int id;
  String name;
  String icon;
  bool isSelected;

  Subcategory.fromJson(Map json){
    this.id=json["subcategory_id"];
    this.name=json["name"];
    this.icon=json["icon"];
    this.isSelected=json["status"];
  }
}