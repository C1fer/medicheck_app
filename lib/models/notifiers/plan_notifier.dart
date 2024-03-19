import 'package:flutter/material.dart';

import '../plan.dart';

class PlanModel extends ChangeNotifier {
  final List<Plan> _userPlans = [];
  Plan? _selectedPlan;

  int? get selectedPlanID => _selectedPlan?.idPlan;

  Plan? get selectedPlan => _selectedPlan;

  List<Plan> get plans => _userPlans;

  Future<void> setCurrentPlan(Plan newPlan) async {
    _selectedPlan = newPlan;
    notifyListeners();
  }

  Future<void> updateSelectedPlan(String selectedPlanID) async {
    Plan selectedPlan = _userPlans
        .firstWhere((Plan plan) => plan.idPlan.toString() == selectedPlanID);
    setCurrentPlan(selectedPlan);
  }

  Future<void> addPlans(List<Plan> plans) async {
    _userPlans.clear();
    _userPlans.addAll(plans);
    setCurrentPlan(plans.first);
    notifyListeners();
  }
}
