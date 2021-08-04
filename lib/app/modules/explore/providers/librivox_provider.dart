import 'dart:convert';

import 'package:audiobooks/app/modules/explore/models/librivox_audiobooks.dart';
import 'package:dio/dio.dart';

class LibrivoxProvider {
  static const String BASEURL = "https://librivox.org/api/feed/audiobooks/";
  static const String JSONFORMAT = "&format=json";
  Dio dio = Dio();

  Future getCategories() async {}

  Future getFeed() async {
    try {
      final response = await dio.get("${BASEURL}title$JSONFORMAT");

      List<Map<String, dynamic>> books =
          (response.data['books'] as List).map((e) => e as Map<String, dynamic>).toList();
      if (books.isNotEmpty) {
        print(response.data['books'].length);
        LibrivoxAudiobook audiobook = LibrivoxAudiobook.fromMap(books.first);
      }
    } catch (e) {
      print(e);
    }
  }
}
