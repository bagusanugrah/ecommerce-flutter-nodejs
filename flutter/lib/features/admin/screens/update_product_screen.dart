import 'dart:io';

import 'package:ecommerce/common/widgets/custom_button.dart';
import 'package:ecommerce/common/widgets/custom_textfield.dart';
import 'package:ecommerce/constants/utils.dart';
import 'package:ecommerce/features/admin/services/admin_services.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';

class UpdateProductScreen extends StatefulWidget {
  static const String routeName = '/update-product';
  final String productId;

  const UpdateProductScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  String category = 'Mobiles';
  List<File> newImages = [];
  List<String> previousImages = [];
  final _updateProductFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  void fetchProductDetails() async {
    Product? product = await adminServices.fetchProductById(context, widget.productId);
    if (product != null) {
      setState(() {
        productNameController.text = product.name;
        descriptionController.text = product.description;
        priceController.text = product.price.toString();
        quantityController.text = product.quantity.toString();
        category = product.category;
        previousImages = product.images;
      });
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      newImages = res;
    });
  }

  void updateProduct() async {
    if (_updateProductFormKey.currentState!.validate()) {
      try {
        List<String> imageUrls = [];

        if (newImages.isNotEmpty) {
          // Step 1: Upload gambar baru ke Cloudinary
          for (File image in newImages) {
            String url = await adminServices.uploadImageToCloudinary(image, productNameController.text);
            imageUrls.add(url);
          }
        }

        // Step 2: Update produk
        adminServices.updateProduct(
          context: context,
          id: widget.productId,
          name: productNameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          quantity: double.parse(quantityController.text),
          category: category,
          images: imageUrls.isNotEmpty ? imageUrls : previousImages,
          oldImages: newImages.isNotEmpty ? previousImages : [],
          onSuccess: () {
            Navigator.pop(context);
            showSnackBar(context, 'Product updated successfully!');
          },
        );
      } catch (e) {
        showSnackBar(context, 'Failed to update product: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: previousImages.isEmpty && newImages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Form(
          key: _updateProductFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: selectImages,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: newImages.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newImages.length,
                      itemBuilder: (context, index) {
                        return Image.file(newImages[index]);
                      },
                    )
                        : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: previousImages.length,
                      itemBuilder: (context, index) {
                        return Image.network(previousImages[index]);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(controller: productNameController, hintText: 'Product Name'),
                const SizedBox(height: 10),
                CustomTextField(controller: descriptionController, hintText: 'Description', maxLines: 5),
                const SizedBox(height: 10),
                CustomTextField(controller: priceController, hintText: 'Price'),
                const SizedBox(height: 10),
                CustomTextField(controller: quantityController, hintText: 'Quantity'),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  value: category,
                  items: ['Mobiles', 'Essentials', 'Appliances', 'Books', 'Fashion', 'Other']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => category = val!),
                ),
                const SizedBox(height: 20),
                CustomButton(text: 'Update', onTap: updateProduct),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
