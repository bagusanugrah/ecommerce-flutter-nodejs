import 'package:ecommerce/common/widgets/loader.dart';
import 'package:ecommerce/features/account/widgets/single_product.dart';
import 'package:ecommerce/features/admin/screens/add_product_screen.dart';
import 'package:ecommerce/features/admin/screens/update_product_screen.dart';
import 'package:ecommerce/features/admin/services/admin_services.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  void navigateToUpdateProduct(String productId) {
    Navigator.pushNamed(
      context,
      UpdateProductScreen.routeName,
      arguments: productId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
      body: GridView.builder(
        itemCount: products!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (context, index) {
          final productData = products![index];
          return GestureDetector(
            onTap: () => navigateToUpdateProduct(productData.id!),
            child: Column(
              children: [
                SizedBox(
                  height: 140,
                  child: SingleProduct(
                    image: productData.images[0],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        productData.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      onPressed: () => deleteProduct(productData, index),
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: navigateToAddProduct,
        tooltip: 'Add a Product',
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }
}
