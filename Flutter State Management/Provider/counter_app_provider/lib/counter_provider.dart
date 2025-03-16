// Create a Counter Model + ChangeNotifier
import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier { // creating a state Management Class
  int _count = 0; // defining the Private(-) State Variable(it cannot be accessed directly from outside this class)
  int get count => _count; //This is a getter method that allows external widgets to read the value of _count.

  void increment() {
    _count++;
    notifyListeners(); // Update UI : Notify all listeners to rebuild the UI
  }
}
