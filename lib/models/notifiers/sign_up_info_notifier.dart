import 'package:flutter/material.dart';
import '../usuario.dart';

class SignUpModel extends ChangeNotifier{
  String? _documentNo;
  String? _documentType;
  String? _emailAddress;
  String? _phoneNo;
  String? _pwd;

  String? get docNo  => _documentNo;
  String? get docType  => _documentType;
  String? get emailAddr  => _emailAddress;
  String? get phoneNo  => _phoneNo;
  String? get pwd  => _pwd;


  Future <void> clear() async {
    _documentNo = null;
    _emailAddress = null;
    _phoneNo = null;
    _pwd = null;
    notifyListeners();
  }

  Future <void> set (String docNo, String docType, String emailAddr, String? phoneNo, String pwd) async {
    _documentNo = docNo;
    _documentType = docType;
    _emailAddress = emailAddr;
    _phoneNo = phoneNo;
    _pwd = _pwd;
    notifyListeners();
  }


}