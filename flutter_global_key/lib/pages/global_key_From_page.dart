import 'package:flutter/material.dart';

class GlobalKeyFromPage extends StatefulWidget {
  const GlobalKeyFromPage({super.key});

  @override
  State<GlobalKeyFromPage> createState() => _GlobalKeyFromPageState();
}

class _GlobalKeyFromPageState extends State<GlobalKeyFromPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(padding: EdgeInsets.all(25.0), child: FormWidget()),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
              labelText: 'Username', border: OutlineInputBorder()),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.maxFinite,
          height: 40,
          child: ElevatedButton(onPressed: () {}, child: const Text('Submit')),
        )
      ],
    );
  }
}
