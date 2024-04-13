import 'package:flutter/material.dart';
import '../models/producto.dart';
import 'cards/product_card_med.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({
    super.key,
    required this.products, this.scrollDirection = Axis.horizontal,
  });

  final List<Producto> products;
  final Axis scrollDirection;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        itemBuilder: (context, index) => ProductCard(
          product: products[index],
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 16.0),
        itemCount: products.length,
        scrollDirection: scrollDirection,
        shrinkWrap: true,
      ),
    );
  }
}
