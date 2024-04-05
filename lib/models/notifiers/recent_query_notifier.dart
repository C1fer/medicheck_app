import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';

class ViewedCoverageModel extends ChangeNotifier{
  Cobertura? recentCoverage;

  Cobertura? get viewedCoverage  => recentCoverage;

  int? get viewedCoverageID  => recentCoverage?.idCobertura;

  Future<void> set(Cobertura selectedCoverage) async {
    recentCoverage = selectedCoverage;
    notifyListeners();
  }
}