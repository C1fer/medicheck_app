import 'package:flutter/material.dart';
import 'plan.dart';
import 'usuario.dart';

class UserInfoModel extends ChangeNotifier{
  Usuario? _currentUser;
  Plan? _selectedPlan;

  Usuario? get curentUser => _currentUser;

  int? get selectedPlanID => _selectedPlan?.idPlan;

  Plan? get selectedPlan => selectedPlan;

  Future<void> setCurrentPlan(Plan newPlan) async{
    _selectedPlan = newPlan;
    notifyListeners();
  }

  Future<void> setCurrentUser(Usuario user) async{
    _currentUser = user;
    notifyListeners();
  }
}