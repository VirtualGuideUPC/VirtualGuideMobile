class Department{
  int id;
  String name;
  List<String> pictures;

  Department.fromJson(Map json){
    this.id=json["department_id"];
    this.name=json["name"];
    this.pictures=<String>[json["photo"]];
  }
}