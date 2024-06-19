import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apiproject/model.dart';

class InstagramData {
  final String accessToken = 'IGQWROaU55UHNMS0t1aVh6bk1oVHI4V1NhYko3UHpiY1hoWkptYTB0LU1GdGo5MWY1aEE4RHlZAOGl4Q2lxQzJlejhsb3VKcVFIOEs2MEpxTjMzekR0NHFESG44d3g4cmZAtRS1OdlcyWFZAjSnNJYXNKemZArSXo3RTgZD';
  String? nextUrl;

  Future<List<InstagramPost>> fetchPosts(int limit) async {
    String url = nextUrl ??
        'https://graph.instagram.com/me/media?fields=id,caption,media_url,media_type,timestamp,children%7Bmedia_url%7D&limit=$limit&access_token=$accessToken';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      nextUrl = jsonResponse['paging']['next'];

      return data.map((json) => InstagramPost.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load the data');
    }
  }

  void resetPagination() {
    nextUrl = null;
  }
}