import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:weatherapp/service/weather_service.dart';
import 'dart:ui';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.CurrentCity();

    try {
      final weather = await _weatherService.queryWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition, String? description) {
    if (mainCondition == null || description == null)
      return 'assets/clearsky.json';

    if (mainCondition == 'Clouds') {
      switch (description.toLowerCase()) {
        case 'few clouds':
          return 'assets/fewclouds.json';
        case 'scattered clouds':
        case 'broken clouds':
        case 'overcast clouds':
          return 'assets/scatteredclouds.json';
      }
    }
    switch (mainCondition) {
      case 'Mist':
      case 'Smoke':
      case 'Haze':
      case 'Dust':
      case 'Fog':
      case 'Sand':
      case 'Ash':
      case 'Squall':
      case 'Tornado':
        return 'assets/mist.json';
      case 'Thunderstorm':
        return 'assets/thunder.json';
      case 'Clear':
        return 'assets/clearsky.json';
      case 'Snow':
        return 'assets/snow.json';
      case 'Drizzle':
        return 'assets/showerrain.json';
      case 'Rain':
        return 'assets/rain.json';
      default:
        return 'assets/clearsky.json';
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const RiveAnimation.asset(
          'assets/new_file.riv',
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
          child: SizedBox(
              height: ScreenUtil().setHeight(1080),
              width: ScreenUtil().setWidth(1080),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.15),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          width: 2,
                          color: Colors.white38
                        )),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weather?.cityName ?? 'Loading',
                              style: GoogleFonts.josefinSans(
                                  fontSize: 120.sp,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.orange),
                            ),
                            Lottie.asset(getWeatherAnimation(
                                _weather?.mainCondition,
                                _weather?.description)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_weather?.currentTemp.round().toString()}°C',
                                  style: GoogleFonts.josefinSans(
                                      fontSize: 100.sp,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.orange),
                                ),
                                SizedBox(
                                  width: 120.w,
                                ),
                                Column(
                                  children: [
                                    Text(_weather?.mainCondition ?? '',
                                        style: GoogleFonts.josefinSans(
                                            fontSize: 100.sp,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w800,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.orange)),
                                    Text(_weather?.description ?? '',
                                        style: GoogleFonts.inter(
                                            fontSize: 30.sp,
                                            color: Colors.orange,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ]),
    );
  }
}
