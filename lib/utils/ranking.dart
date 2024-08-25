import 'package:cloud_firestore/cloud_firestore.dart';

class Ranking {
  static Future<void> setRankingData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('ranking_metadata').doc('ranks').set({
        'view': 'Because you Viewed',
        'search': 'Students Also Search for',
        'top_courses': 'Top Courses in IT',
        'top_seller': 'Top Sellers',
      });

      print('Ranking metadata set successfully');
    } catch (e) {
      print('Error setting ranking metadata: $e');
    }
  }

  static Future<Map<String, String>> getRankingData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final doc =
          await firestore.collection('ranking_metadata').doc('ranks').get();
      if (doc.exists) {
        return Map<String, String>.from(doc.data() ?? {});
      } else {
        print('Ranking metadata document does not exist');
        return {};
      }
    } catch (e) {
      print('Error fetching ranking metadata: $e');
      return {};
    }
  }
}
