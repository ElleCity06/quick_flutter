import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_flutter/quick_flutter.dart';

class ToastUtil {
  static bool _isFirst = true;

  static show(String text, {bool long = false}) {
    if (text.length > 0) {
      if (_isFirst) {
        _isFirst = false;
      } else {
        Fluttertoast.cancel();
      }
      Fluttertoast.showToast(
        msg: text,
        toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }

  static showDebug(String text, {bool long = false}) {
    if (!QuickFlutter.isDebug) return;
    if (text.length > 0) {
      if (_isFirst) {
        _isFirst = false;
      } else {
        Fluttertoast.cancel();
      }
      Fluttertoast.showToast(
        msg: text,
        toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }
}
