import 'package:flutter/material.dart';
import 'features/home/view/home_screen.dart';
import 'features/image_viewer/view/image_viewer_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ポケモンAPI学習',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/image_viewer': (context) => const ImageViewerScreen(),
      },
    );
  }
}

