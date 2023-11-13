import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/home_layout.dart';
import 'package:todo_app/shared/components/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/splash_screen.jpg'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'TO DO LIST',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'E F F I C I E N T',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        nextScreen: const HomeLayout(),
        duration: 280,
        splashIconSize: double.infinity,
        splashTransition: SplashTransition.scaleTransition,
        curve: Curves.easeInOutCirc,
      ),
    );
  }
}
