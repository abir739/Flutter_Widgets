import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Riverpod ')),
      ),
      body: Center(
        child: Consumer(builder: (context, ref, child) {
          final count = ref.watch(counterProvider);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center ,
            children: [
              Text('count: $count'),
              ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state++,
                  child: const Text('Increment'))
            ],
          );
        }),
      ),
    ));
  }
}
