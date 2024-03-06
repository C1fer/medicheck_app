import 'package:flutter/material.dart';
import '../producto.dart';

class SavedProductModel extends ChangeNotifier{
  final List<Producto> _savedProducts = [];

  List<Producto> get savedProducts => _savedProducts;
  List<int> get savedProductIDs => _savedProducts.isNotEmpty ? _savedProducts.map((product) => product.idProducto).toList() : [];

  void addSavedProduct(Producto newProduct){
    _savedProducts.add(newProduct);
    printAll();
    notifyListeners();
  }

  void addSavedProducts(List<Producto> newProducts){
    _savedProducts.addAll(newProducts);
    printAll();
    notifyListeners();
  }

  void deleteSavedProduct(Producto product){
    _savedProducts.removeWhere((element) => element.idProducto == product.idProducto);
    printAll();
    notifyListeners();
  }

  void clear(){
    _savedProducts.clear();
    notifyListeners();
  }

  void replaceItems(List<Producto> newProducts){
    _savedProducts.clear();
    savedProducts.addAll(newProducts);
    printAll();
    notifyListeners();
  }

  void printAll(){
    for (Producto x in _savedProducts){
      print(x.nombre);
    };
  }

  bool isProductInList(int productID){
    try{
      var result = _savedProducts.firstWhere((Producto product) => product.idProducto == productID);
      return true;
    }
    catch(except){
      print(except);
    }
   return false;
  }

}