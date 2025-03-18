import 'package:counter_app_using_bloc/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    // 2️⃣ Provide CounterCubit to the app
    BlocProvider(
      create: (context) =>
          CounterCubit(), // Creates a new instance of CounterCubit, so any widget in the app can access the counter state.
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Counter App using Bloc'),
          ),
        ),

        // 3️⃣ Build UI with Bloc
        body: Center(
          child: BlocBuilder<CounterCubit, int>( // This widget listens to changes in CounterCubit and rebuilds the UI.
            builder: (contextr, count) { // count is the current counter value
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Count: $count'),
                ElevatedButton(
                  onPressed: () => context.read<CounterCubit>().increment(), //  Calls increment()
                  child: const Text('Increment')),
                ElevatedButton(onPressed: () => context.read<CounterCubit>().decrement(), 
                child: const Text('Decrement'))
              ],
            );
          }),
        ),
      ),
    );
  }
}
