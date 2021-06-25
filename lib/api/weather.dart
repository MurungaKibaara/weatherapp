import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
// import 'package:flutter_config/flutter_config.dart';

import 'package:weatherapp/utils/location.dart';

final apiKey =
    "c7e1208b1f15aaa4c1ef6ba665a97b2f"; //FlutterConfig.get('open_api_key');
final apiUrl =
    "http://api.openweathermap.org/data/2.5/weather"; //FlutterConfig.get('open_api_url');

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({@required this.weatherIcon, @required this.weatherImage});
}

class WeatherData {
  WeatherData({@required this.locationData});

  LocationHelper locationData;
  double currentTemperature;
  int currentCondition;
  String currentAddress;

  Future<void> getCurrentTemperature() async {
    Response response = await get(
        '$apiUrl?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=$apiKey&units=metric');

    print(response.body);
    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentAddress = currentWeather['name'];
        currentCondition = currentWeather['weather'][0]['id'];
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 800) {
      return WeatherDisplayData(
        weatherIcon: Icon(
          FontAwesomeIcons.cloud,
          size: 75.0,
        ),
        weatherImage: AssetImage('assets/cloudy.png'),
      );
    } else {
      var now = new DateTime.now();

      if (now.hour >= 18) {
        return WeatherDisplayData(
          weatherImage: AssetImage('assets/night.png'),
          weatherIcon: Icon(
            FontAwesomeIcons.moon,
            size: 75.0,
            color: Colors.white,
          ),
        );
      } else {
        return WeatherDisplayData(
          weatherIcon: Icon(
            FontAwesomeIcons.sun,
            size: 75.0,
            color: Colors.white,
          ),
          weatherImage: AssetImage('assets/sunny.png'),
        );
      }
    }
  }
}
