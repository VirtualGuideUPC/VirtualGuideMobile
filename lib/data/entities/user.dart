
class User {
  final int id;
  final String name;
  final String last_name;
  final String email;
  final String password;
  final String token_notification;
  final int country_id;
  final String birthday;
  final bool is_foreign;

  User({
      this.id,
      this.email,
      this.name,
      this.last_name,
      this.password,
      this.token_notification,
      this.country_id,
      this.birthday,
      this.is_foreign});
}