import 'package:flutter/material.dart';
import '../usuario.dart';

class UserInfoModel extends ChangeNotifier{
  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  int? get currentUserID => _currentUser?.idUsuario;

  Future<void> setCurrentUser(Usuario user) async{
    _currentUser = user;
    notifyListeners();
  }

  Future <void> clear() async {
    _currentUser = null;
    notifyListeners();
  }
}