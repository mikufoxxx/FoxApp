import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const URL = "使用openweather api";

  Future<Weather> queryWeather(String cityName) async {
    final res = await http.get(Uri.parse('$URL$cityName'));

    if (res.statusCode == 200) {
      return Weather.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('无法获取当前天气数据😰');
    }
  }

  Future<String> CurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = '${placemarks[0].locality},${placemarks[0].isoCountryCode?.toLowerCase()}';

    return city ?? "";
  }
}
