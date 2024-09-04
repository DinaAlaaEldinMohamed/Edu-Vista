import 'package:cloud_firestore/cloud_firestore.dart';

class RankingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateCourseRankings() async {
    try {
      // Fetch ranking metadata
      final rankSnapshot =
          await _firestore.collection('ranking_metadata').doc('ranks').get();
      final rankData = rankSnapshot.data();

      if (rankData != null) {
        // Fetch all courses
        final coursesSnapshot = await _firestore.collection('courses').get();

        for (var courseDoc in coursesSnapshot.docs) {
          final courseData = courseDoc.data();
          final rating = courseData['rating'] is int
              ? (courseData['rating'] as int).toDouble()
              : (courseData['rating'] as double? ?? 0.0);
          final enrollments = (courseData['enrollments'] ?? 0) as int;
          final category = courseData['category'] as DocumentReference;

          List<String> newRanks = [];

          // Determine rank based on rating
          newRanks.addAll(_getRanksBasedOnRating(rating, rankData));

          // Determine rank based on category
          final categoryRank =
              await _getRankBasedOnCategory(category, rankData);
          if (categoryRank != null) {
            newRanks.add(categoryRank);
          }

          // Determine rank based on enrollments
          newRanks.addAll(_getRanksBasedOnSales(enrollments, rankData));

          // Remove duplicates and set rank field in Firestore
          final uniqueRanks = newRanks.toSet().toList();
          await _firestore
              .collection('courses')
              .doc(courseDoc.id)
              .update({'ranks': uniqueRanks});
        }
      }
    } catch (e) {
      print('Error updating rankings: $e');
    }
  }

  List<String> _getRanksBasedOnRating(
      double rating, Map<String, dynamic> rankData) {
    List<String> ranks = [];
    if (rating >= 4.5) {
      ranks.add('Top Rated');
    }
    return ranks;
  }

  Future<String?> _getRankBasedOnCategory(
      DocumentReference category, Map<String, dynamic> rankData) async {
    try {
      // Fetch category details
      final categorySnapshot = await category.get();
      final categoryData = categorySnapshot.data() as Map<String, dynamic>?;

      if (categoryData != null) {
        final categoryName = categoryData['name'] as String? ?? '';

        if (categoryName == 'Software Engineering') {
          return 'Top Courses in IT';
        } else if (categoryName == 'UI/UX') {
          return 'Top Design Courses';
        }
      }
    } catch (e) {
      print('Error fetching category data: $e');
    }
    return null;
  }

  List<String> _getRanksBasedOnSales(
      int enrollments, Map<String, dynamic> rankData) {
    List<String> ranks = [];
    if (enrollments >= 500) {
      ranks.add('Top Sellers');
    } else {
      ranks.add('Popular');
    }
    return ranks;
  }

  Future<List<String>> getAvailableRankings() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('ranking_metadata')
          .doc('ranks')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('rankings')) {
          return List<String>.from(data['rankings']);
        } else {
          print('Rankings field not found');
          return [];
        }
      } else {
        print('Document does not exist');
        return [];
      }
    } catch (e) {
      print('Error fetching available rankings: $e');
      return [];
    }
  }
}
