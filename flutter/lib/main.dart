import 'package:ecommerce/common/widgets/bottom_bar.dart';
import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/features/admin/screens/admin_screen.dart';
import 'package:ecommerce/features/auth/screens/auth_screen.dart';
import 'package:ecommerce/features/auth/services/auth_service.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:ecommerce/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Scaffold(
        body: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            if (userProvider.user.token.isNotEmpty) {
              return userProvider.user.type == 'user'
                  ? const BottomBar()
                  : const AdminScreen();
            } else {
              return const AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
