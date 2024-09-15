import 'package:edu_vista/models/course.dart';

class CartItem {
  final String id;
  final String courseId;
  final String instructorName;
  final Course? course;

  CartItem({
    required this.id,
    required this.courseId,
    required this.instructorName,
    this.course,
  });

  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'] as String? ?? '',
      courseId: data['courseId'] as String? ?? '',
      instructorName: data['instructorName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'instructorName': instructorName,
    };
  }

  CartItem copyWith({Course? course}) {
    return CartItem(
      id: id,
      courseId: courseId,
      instructorName: instructorName,
      course: course ?? this.course,
    );
  }
}
