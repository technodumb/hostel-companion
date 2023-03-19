import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hostel_companion/controllers/provider/toggle_controller.dart';
import 'package:hostel_companion/routes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/provider/firebase_firestore_provider.dart';
import 'controllers/provider/food_data.dart';
import 'controllers/provider/range_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseFirestoreProvider>(
            create: (_) => FirebaseFirestoreProvider()),
        ChangeNotifierProvider<FoodData>(create: (_) => FoodData()),
        ChangeNotifierProvider<ToggleController>(
            create: (_) => ToggleController()),
        ChangeNotifierProvider<RangeController>(
            create: (_) => RangeController())
      ],
      child: MaterialApp(
        title: 'Hostel Companion',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const HomeScreen(),
        initialRoute: '/load',
        routes: routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
