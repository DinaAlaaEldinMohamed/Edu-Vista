import 'package:cloud_firestore/cloud_firestore.dart';

class RankingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> fetchRankingMetadata() async {
    DocumentSnapshot rankingMetadata =
        await _firestore.collection('ranking_metadata').doc('ranks').get();
    if (!rankingMetadata.exists) {
      throw Exception('Ranking metadata not found');
    }
    return rankingMetadata.data() as Map<String, String>;
  }
}
