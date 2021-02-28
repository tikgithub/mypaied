class UserModel {
  String email;
  String photo;

  UserModel(this.email, this.photo);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'photo': photo,
    };
  }

  fromMap(Map<String, dynamic> maps) {
    this.email = maps['email'];
    this.photo = maps['photo'];
  }
}
