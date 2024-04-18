import 'package:flutter/material.dart';

import '../producto.dart';
import '../cobertura.dart';

class ProductCoveragesModel extends ChangeNotifier{
  final List<Cobertura> _coverages = [];
  Producto? _refProduct;

  List<Cobertura> get coverages => _coverages;

  int get coveragesLength => _coverages.length;

  Producto? get product => _refProduct;

  void clear(){
    _coverages.clear();
    notifyListeners();
  }

  void addAll(List<Cobertura> newCoverages){
      _coverages.addAll(newCoverages);
      _refProduct = coverages.first.idProductoNavigation;
      notifyListeners();
  }

  void replaceAll(List<Cobertura> newCoverages){
    _coverages.clear();
    _coverages.addAll(newCoverages);
    _refProduct = coverages.first.idProductoNavigation;
    notifyListeners();
  }




}