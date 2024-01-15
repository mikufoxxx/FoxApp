class Weather {
  final String cityName;
  final double currentTemp;
  final String mainCondition;
  final String description;

  Weather(
      {required this.cityName,
      required this.currentTemp,
      required this.mainCondition,
      required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['cityName'],
        currentTemp: json['currentTemp'],
        mainCondition: json['mainCondition'],
        description: json['description']);
  }
}
