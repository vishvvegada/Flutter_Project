class User {
  int? id;
  String fullName;
  String email;
  String mobileNumber;
  String dateOfBirth;
  String city;
  String gender;
  String hobbies;
  String password;
  bool isFavorite;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.city,
    required this.gender,
    required this.hobbies,
    required this.password,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
      'city': city,
      'gender': gender,
      'hobbies': hobbies,
      'password': password,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      dateOfBirth: map['dateOfBirth'],
      city: map['city'],
      gender: map['gender'],
      hobbies: map['hobbies'],
      password: map['password'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}