
class User {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String tokenNotification;
  final int countryId;
  final String birthday;
  final bool isForeign;

  User({
      this.id,
      this.email,
      this.name,
      this.lastName,
      this.password,
      this.tokenNotification,
      this.countryId,
      this.birthday,
      this.isForeign});
}