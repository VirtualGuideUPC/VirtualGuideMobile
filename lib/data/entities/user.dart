class User {
  int id;
  String name;
  String lastName;
  String email;
  String password;
  String tokenNotification;
  int countryId;
  String birthday;
  String icon;
  bool isForeign;
  List<int> typePlaces;
  List<int> categories;
  List<int> subcategories;

  User(
      {this.id,
      this.email,
      this.name,
      this.lastName,
      this.password,
      this.tokenNotification,
      this.countryId,
      this.birthday,
      this.icon,
      this.isForeign,
      this.typePlaces,
      this.categories,
      this.subcategories});


  factory User.fromJson(Map json) {
    return User(
        name: json['name'],
        birthday: json['birthday'],
        email: json['email'],
        countryId: json['country'],
        icon: json['icon'],
        lastName: json['last_name']);
  }
}

class UserUpdateDto {
  int user;
  String name;
  String lastName;
  String birthday;
  int country;
}
