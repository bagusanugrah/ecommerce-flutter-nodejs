import 'package:ecommerce/models/product.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ProductQuantityChart extends StatelessWidget {
  final List<Product> products;

  const ProductQuantityChart({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalQuantity = products.fold<double>(0, (sum, item) => sum + item.quantity);

    return PieChart(
      PieChartData(
        sections: products.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          final percentage = (product.quantity / totalQuantity) * 100;

          return PieChartSectionData(
            color: getRandomColor(index),
            value: product.quantity,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Color getRandomColor(int index) {
    final random = Random(index);
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }
}
