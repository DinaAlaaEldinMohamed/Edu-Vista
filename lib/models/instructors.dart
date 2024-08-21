import 'package:cloud_firestore/cloud_firestore.dart';

class Instructor {
  String? id;
  String? name;
  int? experienceYears;
  String? certificate;

  Instructor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    id = doc.id;
    name = data['name'];
    experienceYears = data['experience_years'];
    certificate = data['certificate'];
  }
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'experience_years': experienceYears,
      'certificate': certificate
    };
  }
}
