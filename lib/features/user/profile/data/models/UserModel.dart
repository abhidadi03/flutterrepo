class Profile {
  final int id;
  final String name;
  final String email;
  final String firebaseUid;
  final String? phoneNo;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.firebaseUid,
    required this.phoneNo,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      firebaseUid: json['firebase_uid'],
      phoneNo: json['phone_no'],
    );
  }
}
