import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca Bandung'),
        elevation: 0,
      ),
      body: Center(
        child: weatherProvider.isLoading
            ? const CircularProgressIndicator()
            : weatherProvider.weatherDescription == null
            ? const Text('Gagal memuat data cuaca.')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon Cuaca
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.2),
              ),
              child: Center(
                child: Icon(
                  _getWeatherIcon(weatherProvider.weatherDescription!),
                  size: 100,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Deskripsi Cuaca
            Text(
              weatherProvider.weatherDescription!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            // Suhu
            Text(
              '${weatherProvider.temperature}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            // Info Tambahan
            Text(
              'Bandung, Indonesia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          weatherProvider.fetchWeather();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  /// Fungsi untuk menentukan ikon cuaca berdasarkan deskripsi
  IconData _getWeatherIcon(String description) {
    if (description.contains('Clear')) {
      return Icons.wb_sunny;
    } else if (description.contains('Cloud')) {
      return Icons.cloud;
    } else if (description.contains('Rain')) {
      return Icons.umbrella;
    } else if (description.contains('Snow')) {
      return Icons.ac_unit;
    } else {
      return Icons.wb_cloudy;
    }
  }
}
