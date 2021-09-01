
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
  List<int> typePlaces;
  List<int> categories;
  List<int> subcategories;

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
      this.isForeign,
      this.typePlaces,
      this.categories,
      this.subcategories});
}