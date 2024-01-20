import 'dart:convert';

import 'package:medicheck/models/cobertura.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachedCoveragesService {
  static Future<List<String>> getSerializedCachedCoverages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('cached_coverages');
    print(items);
    return items ?? [];
  }

  static Future<List<Cobertura>> get() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('cached_coverages');
    print(items);
    if (items != null){
      return items.map((item) => Cobertura.fromJson(jsonDecode(item))).toList();
    }
    return [];
  }

  static void add(Cobertura coverage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('cached_coverages') ?? [];
    final String coverageJson = json.encode(coverage.toJson());
    if (!items.contains(coverageJson)) {
      items.add(coverageJson);
      prefs.setStringList('cached_coverages', items);
    }
  }

  static void deleteCache() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_coverages');

  }
}
