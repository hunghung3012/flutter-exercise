import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  static const String apiKey = "6cdcbd9bb96bdbd0c91107b976b19f0f"; // <-- THAY API KEY

  static Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather"
            "?lat=16.0544&lon=108.2022&appid=$apiKey&units=metric"
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load weather");
    }

    return json.decode(response.body);
  }
}
