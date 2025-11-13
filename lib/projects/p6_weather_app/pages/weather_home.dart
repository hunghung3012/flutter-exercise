import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../services/weather_api.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  Future<Map<String, dynamic>>? weatherFuture;
  final Color primary = const Color(0xFF53B175); // rgb(83, 177, 117)
  final Color primaryDark = const Color(0xFF3D8A5A);
  final Color primaryLight = const Color(0xFF6FD99A);

  @override
  void initState() {
    super.initState();
    weatherFuture = _loadWeather();
  }

  Future<Map<String, dynamic>> _loadWeather() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Quyền truy cập vị trí bị từ chối");
    }

    final Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Lấy thông tin địa chỉ từ tọa độ
    final weatherData = await WeatherApi.getWeather(pos.latitude, pos.longitude);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Ưu tiên: locality (thành phố) > administrativeArea (tỉnh) > name từ API
        weatherData['cityName'] = place.locality ??
            place.administrativeArea ??
            weatherData['name'];
        weatherData['country'] = place.country ?? weatherData['sys']['country'];
      }
    } catch (e) {
      // Nếu geocoding lỗi, giữ nguyên tên từ API
      weatherData['cityName'] = weatherData['name'];
      weatherData['country'] = weatherData['sys']['country'];
    }

    return weatherData;
  }

  String _getWeatherEmoji(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
      case 'drizzle':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  // Hàm mới: Lấy mô tả chi tiết thời tiết bằng tiếng Việt
  String _getDetailedWeatherDescription(String main, String description) {
    switch (main.toLowerCase()) {
      case 'clear':
        return 'Trời quang đãng';
      case 'clouds':
        if (description.toLowerCase().contains('few')) {
          return 'Ít mây';
        } else if (description.toLowerCase().contains('scattered')) {
          return 'Mây rải rác';
        } else if (description.toLowerCase().contains('broken')) {
          return 'Nhiều mây';
        } else if (description.toLowerCase().contains('overcast')) {
          return 'U ám';
        }
        return 'Nhiều mây';
      case 'rain':
        if (description.toLowerCase().contains('light')) {
          return 'Mưa nhỏ';
        } else if (description.toLowerCase().contains('heavy')) {
          return 'Mưa to';
        }
        return 'Có mưa';
      case 'drizzle':
        return 'Mưa phùn';
      case 'thunderstorm':
        return 'Có dông';
      case 'snow':
        return 'Có tuyết';
      case 'mist':
        return 'Sương mù';
      case 'fog':
        return 'Sương mù dày';
      default:
        return description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary,
              primaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder(
            future: weatherFuture,
            builder: (context, snapshot) {
              // LOADING
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Đang tải thông tin thời tiết...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // ERROR
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Có lỗi xảy ra",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("Thử lại"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              weatherFuture = _loadWeather();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              final city = data["cityName"] ?? data["name"];
              final country = data["country"] ?? data["sys"]["country"];
              final temp = data["main"]["temp"];
              final feelsLike = data["main"]["feels_like"];
              final humidity = data["main"]["humidity"];
              final windSpeed = data["wind"]["speed"];
              final desc = data["weather"][0]["description"];
              final main = data["weather"][0]["main"];
              final icon = data["weather"][0]["icon"];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // 🏠 Nút back và Location trên cùng 1 hàng
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Nút back
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                          // Location Header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$city, $country',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Spacer để cân bằng
                          const SizedBox(width: 48),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // 🌡️ Temperature Card - Main Feature (làm rộng hơn)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 36,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Icon thời tiết
                            Text(
                              _getWeatherEmoji(main),
                              style: const TextStyle(fontSize: 100),
                            ),

                            const SizedBox(height: 12),

                            // Mô tả chi tiết thời tiết (Nhiều mây, ít mây, v.v.)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getDetailedWeatherDescription(main, desc),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primaryDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Nhiệt độ lớn
                            Text(
                              "${temp.toStringAsFixed(0)}°",
                              style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: primary,
                                height: 1,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Mô tả thời tiết (description từ API)
                            Text(
                              desc.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Cảm giác như - Thiết kế nổi bật hơn

                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 📊 Weather Details
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.water_drop,
                              label: 'Độ ẩm',
                              value: '$humidity%',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.air,
                              label: 'Gió',
                              value: '${windSpeed.toStringAsFixed(1)} m/s',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // 🔄 Refresh Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.refresh, size: 24),
                          label: const Text(
                            'Làm mới',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              weatherFuture = _loadWeather();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}