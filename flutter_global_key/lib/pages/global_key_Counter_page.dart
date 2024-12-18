import 'package:flutter/material.dart';

class GlobalKeyCounterPage extends StatefulWidget {
  const GlobalKeyCounterPage({super.key});

  @override
  State<GlobalKeyCounterPage> createState() => _GlobalKeyCounterPageState();
}

class _GlobalKeyCounterPageState extends State<GlobalKeyCounterPage> {
  final keyCounter = GlobalKey<_CounterWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CounterWidget(
        key: keyCounter,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final _counter = keyCounter.currentState!._counter;

          keyCounter.currentState!._increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Text('Counter: $_counter'),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(onPressed: _increment, child: const Text('Tap me')),
        ],
      ),
    );
  }
}
