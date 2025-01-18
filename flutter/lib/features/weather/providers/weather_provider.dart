import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  String? _weatherDescription;
  String? _temperature;
  bool _isLoading = false;

  String? get weatherDescription => _weatherDescription;
  String? get temperature => _temperature;
  bool get isLoading => _isLoading;

  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    const String apiUrl = 'https://wttr.in/Bandung?format=%C+%t';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = response.body.split(' ');
        _weatherDescription = data[0]; // Deskripsi cuaca
        _temperature = data[1]; // Suhu
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      _weatherDescription = null;
      _temperature = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
