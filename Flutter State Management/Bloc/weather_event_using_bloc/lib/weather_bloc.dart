import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

// Define events: what heppens in the app(fetch weather)
abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {}

class ToggleWeather extends WeatherEvent {}

// Define States(the different conditions of our app): the WeatherState

abstract class WeatherStates {}

class InitialWeather extends WeatherStates {}

class LoadingWeather extends WeatherStates {}

class LoadedWeather extends WeatherStates {
  // final String weather;
  // LoadedWeather(this.weather);

  // Show Weather Icons Dynamically!
  final String condition;
  final int temperature;

  LoadedWeather(this.condition, this.temperature);
}

// Create a Bloc to handle events and update states
class WeatherBloc extends Bloc<WeatherEvent, WeatherStates> {
  // bool isSunny = true;

  WeatherBloc() : super(InitialWeather()) {
    on<FetchWeather>((event, emit) async {
      emit(LoadingWeather()); // Show loading state
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      // emit(LoadedWeather("☀️ Sunny 25°C")); // Send new state

      // Randomly select weather condition
      final weatherConditions = ["Sunny", "Rainy", "Cloudy", "Snowy", "Stormy"];
      final random = Random();
      String selectedCondition =
          weatherConditions[random.nextInt(weatherConditions.length)];
      int temperature = random.nextInt(30); // Random temp between 0 - 30°C

      emit(LoadedWeather(selectedCondition, temperature));
    });

    // on<ToggleWeather>((event, emit) async {
    //   emit(LoadingWeather());
    //   await Future.delayed(const Duration(seconds: 2));

    //   if (isSunny) {
    //     emit(LoadedWeather("❄️ Snowy 0°C"));
    //   } else {
    //     emit(LoadedWeather("☀️ Sunny 25°C"));
    //   }

    //   isSunny = !isSunny;
    // });
  }
}
