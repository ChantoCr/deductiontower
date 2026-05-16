import 'dart:convert';

import 'package:flutter/services.dart';

class JsonLoader {
  const JsonLoader();

  Future<List<dynamic>> loadList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as List<dynamic>;
  }

  Future<Map<String, dynamic>> loadMap(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
