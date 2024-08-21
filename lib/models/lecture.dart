import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture {
  String id;
  String title;
  String description;
  Duration duration;
  Timestamp createdAt;
  String videoUrl; // URL of the video

  Lecture({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.createdAt,
    required this.videoUrl,
  });

  factory Lecture.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lecture(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: Duration(minutes: data['duration'] ?? 0),
      createdAt: data['created_at'] ?? Timestamp.now(),
      videoUrl: data['video_url'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'duration': duration.inMinutes,
      'created_at': createdAt,
      'video_url': videoUrl,
    };
  }
}
