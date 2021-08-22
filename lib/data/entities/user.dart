
class User {
  int id;
  String name;
  String lastName;
  String email;
  String password;
  String tokenNotification;
  int countryId;
  String birthday;
  String picture;
  bool isForeign;

  User({
      this.id,
      this.email,
      this.name,
      this.lastName,
      this.password,
      this.tokenNotification,
      this.countryId,
      this.birthday,
      this.picture,
      this.isForeign});
}