// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:crypto/crypto.dart';

abstract class CryptHelper {
  static String toMD5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }
}
