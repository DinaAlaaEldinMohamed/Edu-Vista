class UserMetaData {
  String? phoneNumber;
  String? address;
  String? university;
  int? age;
  String? bio;
  //String? id;
  UserMetaData({this.phoneNumber, this.address, this.university});

  UserMetaData.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    university = json['university'];
    age = json['age'] as int?;
    bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    //json['id'] = id;
    json['phoneNumber'] = phoneNumber;
    json['address'] = address;
    json['university'] = university;
    json['age'] = age;
    json['bio'] = bio;
    return json;
  }
}
