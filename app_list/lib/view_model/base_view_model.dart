import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  BaseViewModel();

  bool loading = false;
  bool mounted = true;

  void setLoading() {
    loading = true;
    if (!mounted) return;
    notifyListeners();
  }

  void finishedLoading() {
    loading = false;
    if (!mounted) return;
    notifyListeners();
  }
}
