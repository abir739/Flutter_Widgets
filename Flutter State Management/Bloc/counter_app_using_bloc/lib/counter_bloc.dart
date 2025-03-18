// 1️⃣ Define CounterCubit (State Management)

import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}

/*
🔹 CounterCubit extends Cubit<int> → This means CounterCubit is a class that will handle an integer state (our counter).
🔹 CounterCubit() : super(0); → The initial value of our counter is 0.
🔹 emit(state + 1); → When we call increment(), it updates the state (like setState() in normal Flutter).
*/


/* 🛠️ Summary
✅ Cubit is a simple way to manage state in Flutter.
✅ emit() updates the state, similar to setState().
✅ BlocProvider makes the Cubit available in the app.
✅ BlocBuilder listens for state changes and updates the UI. */