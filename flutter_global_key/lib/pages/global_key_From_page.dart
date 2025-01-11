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
  final formKey = GlobalKey<FormState>();

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Username', border: OutlineInputBorder()),
            validator: (value) =>
                value != null ? 'Please enter your username' : null,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value != null && !value.contains('@')
                ? 'Not a Valid Email'
                : null,
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
            validator: (value) => value != null && value.length < 6
                ? 'Password needs 6 characters.'
                : null,
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: double.maxFinite,
            height: 40,
            child:
                ElevatedButton(onPressed: submit, child: const Text('Submit')),
          )
        ],
      ),
    );
  }
}
