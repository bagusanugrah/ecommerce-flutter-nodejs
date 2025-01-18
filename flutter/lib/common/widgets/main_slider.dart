import 'package:ecommerce/features/about/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/features/auth/screens/auth_screen.dart';
import 'package:ecommerce/features/weather/screens/weather_screen.dart';
import 'package:ecommerce/features/weather/providers/weather_provider.dart';

class MainSlider extends StatelessWidget {
  const MainSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: PageView(
        children: [
          const WeatherScreen(),
          const AuthScreen(),
          AboutScreen(),
        ],
      ),
    );
  }
}
