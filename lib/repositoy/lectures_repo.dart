import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/lecture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class LectureRepository {
  Future<String> fetchLastSeenLectureId(String courseId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('course_user_progress')
        .doc(courseId)
        .get();
    return userDoc.data()?['lastSeenLectureId'] ?? '';
  }

  Future<void> downloadLecture(
      Lecture lecture, BuildContext context, String courseId) async {
    // Ensure FlutterDownloader is initialized
    // await FlutterDownloader.initialize();

    // Get the external storage directory
    // String _localPath = (await ExtStorage.getExternalStoragePublicDirectory(
    // ExtStorage.DIRECTORY_DOWNLOADS))!;
    // final directory = await getExternalStorageDirectory();
    Directory directory = Directory('/storage/emulated/0/Download');
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to access storage directory'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final savedDir = directory.path; // Ensure this directory exists

    // Create the directory if it does not exist
    final downloadDir = Directory('$savedDir');
    print(
        '=====================================================download directroy====$downloadDir');
    if (!downloadDir.existsSync()) {
      downloadDir.createSync(recursive: true);
    }

    final url = lecture.lectureUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No download URL available for this lecture'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: downloadDir.path,
        fileName:
            '${lecture.title}.mp4', // Ensure this is a valid file extension
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download started'),
            backgroundColor: Colors.green,
          ),
        );
        updateLectureDownloadStatus(lecture.id, true, courseId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading lecture: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error downloading lecture: $e');
    }
  }

  Future<void> updateLectureDownloadStatus(
      String? lectureId, bool isDownloaded, String courseId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('courses')
        .doc(courseId)
        .collection('lectures')
        .doc(lectureId)
        .update({
      'is_downloaded': true,
    });
    try {
      await firestore.collection('lectures').doc(lectureId).update({
        'is_downloaded': isDownloaded,
      });
      print('Lecture download status updated successfully');
    } catch (e) {
      print('Error updating lecture download status: $e');
    }
  }

  Future<List<Lecture>> fetchDownloadedLectures(String courseId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('lectures')
          .where('is_downloaded', isEqualTo: true)
          .orderBy('sort')
          .get();

      return result.docs
          .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
          .toList();
    } catch (e) {
      print('Error fetching downloaded lectures: $e');
      return [];
    }
  }
}
