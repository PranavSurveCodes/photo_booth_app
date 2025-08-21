import 'package:flutter/material.dart';
import 'package:photo_booth/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main()async {
  // photo booth app
    await dotenv.load(fileName: ".env"); // load environment variables

  runApp(MyApp());
}
