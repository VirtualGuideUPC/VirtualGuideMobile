class User {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String tokenNotification;
  final int countryId;
  String birthday;
  final bool isForeign;
  final String icon;

  User(
      {this.id,
      this.email,
      this.name,
      this.lastName,
      this.password,
      this.tokenNotification,
      this.countryId,
      this.birthday,
      this.isForeign,
      this.icon});

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
