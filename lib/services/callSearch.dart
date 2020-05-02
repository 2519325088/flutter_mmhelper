import 'package:flutter/material.dart';

class CallSearch with ChangeNotifier {
  bool isClick = false;

  onChangeMethod(bool isClickq) {
    isClick = isClickq;
    notifyListeners();
  }
}
