import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/repositoy/ranking_repo.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> fetchCoursesByRanking(
      String rankingType) async {
    RankingRepository rankingRepo = RankingRepository();
    Map<String, String> rankingData = await rankingRepo.fetchRankingMetadata();

    String field;
    bool descending;

    switch (rankingData[rankingType]) {
      case 'Students Also Search for':
        field = 'searchPopularity';
        descending = true;
        break;
      case 'Top Courses in IT':
        field = 'coursePopularity';
        descending = true;
        break;
      case 'Top Sellers':
        field = 'sales';
        descending = true;
        break;
      case 'Because you Viewed':
        field = 'viewCount';
        descending = true;
        break;
      default:
        throw Exception("Unknown ranking type");
    }

    QuerySnapshot querySnapshot = await _firestore
        .collection('courses')
        .orderBy(field, descending: descending)
        .get();

    return querySnapshot.docs;
  }
}
