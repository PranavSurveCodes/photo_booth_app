// import 'package:flutter/material.dart';
// import 'package:photo_booth/app.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';


// void main()async {
//   // photo booth app
//     await dotenv.load(fileName: ".env"); // load environment variables

//   runApp(MyApp());
// }



import 'package:flutter/material.dart';
import 'package:photo_booth/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}
