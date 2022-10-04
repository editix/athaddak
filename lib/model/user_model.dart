class UserModel {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? province;
  String? dateOfBirth;
  String? profileImage;
  List? challengeHistory = [];
  List? challengeMember = [];
  int? challenges = 0;
  int? winnings = 0;
  int? events = 0;
  int? points = 0;

  //parsing data to JSON
  UserModel(
      {this.uid,
      this.name,
      this.email,
      this.challengeHistory,
      this.challengeMember,
      this.phone,
      this.province,
      this.dateOfBirth,
      this.profileImage,
      this.challenges,
      this.winnings,
      this.events,
      this.points});

  //Access and fetching data from the server (cloud firestore)
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        challengeHistory: map['challengeHistory'],
        challengeMember: map['challengeMember'],
        phone: map['phone'],
        province: map['province'],
        dateOfBirth: map['dateOfBirth'],
        profileImage: map['profileImage'],
        challenges: map['challenges'],
        winnings: map['winning'],
        events: map['events'],
        points: map['points']);
  }

  //Sending data to server (cloud firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'challengeHistory': challengeHistory,
      'challengeMember': challengeMember,
      'phone': phone,
      'province': province,
      'dateOfBirth': dateOfBirth,
      'profileImage': profileImage,
      'challenges': challenges,
      'winning': winnings,
      'events': events,
      'points': points
    };
  }
}
