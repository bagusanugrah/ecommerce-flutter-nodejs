import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/features/account/widgets/below_app_bar.dart';
import 'package:ecommerce/features/account/widgets/orders.dart';
import 'package:ecommerce/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Carrefour', // Tulisan menggantikan gambar logo
                  style: const TextStyle(
                    fontSize: 24, // Sesuaikan ukuran font
                    fontWeight: FontWeight.bold, // Font dengan ketebalan bold
                    fontFamily: 'Serif', // Gunakan font yang elegan (contoh: Serif)
                    color: Colors.black, // Warna tulisan
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: const [
          BelowAppBar(),
          SizedBox(height: 10),
          TopButtons(),
          SizedBox(height: 20),
          Orders(),
        ],
      ),
    );
  }
}
