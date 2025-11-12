import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Votify/services/api_service.dart';
import 'package:Votify/services/auth_service.dart';
import 'package:Votify/pages/shared/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        Provider(create: (context) => ApiService()),
      ],
      child: MaterialApp(
        title: 'Vote App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}