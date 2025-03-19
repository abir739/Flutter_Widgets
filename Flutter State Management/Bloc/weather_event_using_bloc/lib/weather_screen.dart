import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_event_using_bloc/weather_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  // Helper method to get the correct icon
  IconData getWeatherIcon(String condition) {
    switch (condition) {
      case "Sunny":
        return Icons.wb_sunny;
      case "Rainy":
        return Icons.umbrella;
      case "Cloudy":
        return Icons.wb_cloudy;
      case "Snowy":
        return Icons.ac_unit;
      case "Stormy":
        return Icons.flash_on;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App with BLoC")),
      body: Center(
        child: BlocBuilder<WeatherBloc, WeatherStates>(
          builder: (context, state) {
            if (state is InitialWeather) {
              return ElevatedButton(
                onPressed: () =>
                    context.read<WeatherBloc>().add(FetchWeather()),
                child: const Text("Get Weather"),
              );
            } else if (state is LoadingWeather) {
              return const CircularProgressIndicator();
            } else if (state is LoadedWeather) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   "Weather: ${state.weather}",
                  //   style: const TextStyle(fontSize: 24),
                  // ),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () =>
                  //       context.read<WeatherBloc>().add(FetchWeather()),
                  //   child: const Text("Refresh Weather"),
                  // ),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () =>
                  //       context.read<WeatherBloc>().add(ToggleWeather()),
                  //   child: const Text("Toggle Weather ☀️ ❄️"),
                  // )
                  Icon(
                    getWeatherIcon(state.condition), // Get the icon dynamically
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${state.condition} ${state.temperature}°C",
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<WeatherBloc>().add(FetchWeather()),
                    child: const Text("Refresh Weather"),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
