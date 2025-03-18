import 'package:flutter_bloc/flutter_bloc.dart';

// Define events: what heppens in the app(fetch weather)
abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {}

// Define States(the different conditions of our app): the WeatherState

abstract class WeatherStates {}

class InitialWeather extends WeatherStates {}

class LoadingWeather extends WeatherStates {}

class LoadedWeather extends WeatherStates {
  final String weather;
  LoadedWeather(this.weather);
}

// Create a Bloc to handle events and update states
class WeatherBloc extends Bloc<WeatherEvent, WeatherStates> {
  WeatherBloc() : super(InitialWeather()) {
    on<FetchWeather>((event, emit) async {
      emit(LoadingWeather()); // Show loading state
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      emit(LoadedWeather("☀️ Sunny 25°C")); // Send new state
    });
  }
}


