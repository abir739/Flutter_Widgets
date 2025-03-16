import 'package:counter_app_provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( 
    // Wrap App with Provider, so CounterProvider is available everywhere.
    ChangeNotifierProvider(
    create: (context) => CounterProvider(),
    child: const  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home:Scaffold(
        appBar: AppBar(title: const Center(child:  Text("Provider Example"))),
        body: Center(
          
          /* 🔹 Why Do We Use Consumer Instead of Provider.of?
              ✅ Consumer only rebuilds the widget inside it, making the app more efficient.
              ❌ Provider.of(context) rebuilds the entire widget tree when notifyListeners() is called.
           */
          child: Consumer<CounterProvider>( // Consumer<CounterProvider> listens for changes and updates the UI.
            builder: (context, provider, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Count: ${provider.count}'),
                ElevatedButton(onPressed: provider.increment, child: const Text('Increment'))
              ],
            )),
        ),
      ),
    );
  }
}

