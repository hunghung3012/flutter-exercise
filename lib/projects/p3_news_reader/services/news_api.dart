import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const String apiKey = "4e3a18bccd2f4e9da651253eb2e861b4"; // <<< Thay API KEY vào đây
  static const String baseUrl = "https://newsapi.org/v2/top-headlines?country=us";

  static Future<List<dynamic>> fetchNews() async {
    final url = Uri.parse("$baseUrl&apiKey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["articles"];
    } else {
      throw Exception("Failed to load news.");
    }
  }
}
