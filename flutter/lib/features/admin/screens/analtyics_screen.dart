import 'package:ecommerce/common/widgets/loader.dart';
import 'package:ecommerce/features/admin/services/admin_services.dart';
import 'package:ecommerce/features/admin/widgets/product_quantity_chart.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Column(
      children: [
        SizedBox(
          height: 250,
          child: ProductQuantityChart(products: products!),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, index) {
              final product = products![index];
              return Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: getRandomColor(index),
                  ),
                  const SizedBox(width: 8),
                  Text(product.name),
                ],
              );
            },
          ),
        ),
      ],
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
