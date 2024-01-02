import 'package:flutter/material.dart';

// その他だったら、テキストフィールドの内容を送信する
  String otherToText(String value, TextEditingController controller) {
    if (value == "その他") {
      return controller.text;
    }
    return value;
  }