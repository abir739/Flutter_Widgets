import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_event_using_bloc/weather_bloc.dart';
import 'package:weather_event_using_bloc/weather_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => WeatherBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider( // Ensure WeatherScreen has access to WeatherBloc
        create: (context) => WeatherBloc(),
        child: const WeatherScreen(),
      ),
    );
  }
}
