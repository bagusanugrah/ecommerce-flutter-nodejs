import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/admin/models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> salesData;

  const CategoryProductsChart({
    Key? key,
    required this.salesData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: salesData
            .asMap()
            .entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: entry.value.earning.toDouble(),
                    color: Colors.blue, // Menggunakan parameter 'color'
                  ),
                ],
              ),
            )
            .toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < salesData.length) {
                  return Text(
                    salesData[index].label,
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const Text('');
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
