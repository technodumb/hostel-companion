import 'package:flutter/material.dart';
import 'package:hostel_companion/controllers/provider/toggle_controller.dart';
import 'package:hostel_companion/routes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/provider/food_data.dart';
import 'controllers/provider/login_form.dart';
import 'controllers/provider/range_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        ChangeNotifierProvider(create: (_) => ToggleController()),
        ChangeNotifierProvider(create: (_) => FoodData()),
        ChangeNotifierProvider(create: (_) => RangeController()),
      ],
      child: MaterialApp(
        title: 'Hostel Companion',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const HomeScreen(),
        initialRoute: '/load',
        routes: routes,
      ),
    );
  }
}
