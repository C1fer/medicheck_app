import 'package:flutter/material.dart';
import '../../models/producto.dart';

class ViewedCoverageModel extends ChangeNotifier{
  Producto? recentProduct;

  Producto? get viewedProduct  => recentProduct;

  int? get viewedProductID  => recentProduct?.idProducto;

  Future<void> set(Producto selectedProduct) async {
    recentProduct = selectedProduct;
    notifyListeners();
  }
}