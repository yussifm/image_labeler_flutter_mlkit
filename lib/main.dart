import 'package:flutter/material.dart';
import 'package:image_labeler_flutter/Screens/Image_label_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Labeller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageLabelerScreen(),
    );
  }
}
