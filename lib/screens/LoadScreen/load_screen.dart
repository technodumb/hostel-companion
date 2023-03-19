import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hostel_companion/controllers/firebase/version_data.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:hostel_companion/controllers/provider/toggle_controller.dart';
import 'package:hostel_companion/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  bool isSignedIn = false;
  VersionData versionData = VersionData();
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<bool> checkInternetConnection() async {
    print("checkInternetConnection");
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
    return false;
  }

  void _checkInternetConnectionAndNavigate() async {
    print("checkInternetConnectionAndNavigate");
    bool isConnected = await checkInternetConnection();
    print("checkInternetConnectionAndNavigate");
    if (isConnected) {
      final FlutterSecureStorage storage = FlutterSecureStorage(
        aOptions: _getAndroidOptions(),
      );
      String? value = await storage.read(key: 'isSignedIn');
      print(value);
      if (value == 'true') {
        setState(() {
          isSignedIn = true;
        });
      }
      print("checkInternetConnectionAndNavigate");
      bool isLatest = await versionData.isLatest();
      print(isLatest);
      if (!isLatest) {
        String latestUpdate = await versionData.getLatestUpdate();
        // open the latestUpdate link in webview
        _updateDialog(latestUpdate, versionData.currentVersion);
      } else if (isSignedIn) {
        final toggleData =
            Provider.of<ToggleController>(context, listen: false);
        final firebaseFirestoreProvider =
            Provider.of<FirebaseFirestoreProvider>(context, listen: false);
        final foodData = Provider.of<FoodData>(context, listen: false);
        await firebaseFirestoreProvider.checkUserAuth(
            await storage.read(key: 'username') ?? "",
            await storage.read(key: 'password') ?? "");
        firebaseFirestoreProvider.refreshFoodDates();
        print(firebaseFirestoreProvider.userModel.noFoodDates);
        firebaseFirestoreProvider.initialToggle(toggleData, foodData);
        Navigator.pushNamed(context, '/home');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } else {
      _retryDialog();
    }
  }

  void _updateDialog(String link, String ver) async {
    print("updateDialog");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          FlutterDownloader.registerCallback(TestClass.callback);
          return AlertDialog(
            title: Text("Update available"),
            content: Text("Please update the app to continue."),
            actions: <Widget>[
              TextButton(
                child: Text("UPDATE"),
                onPressed: () async {
                  // request storage permission
                  if (Platform.isAndroid) {
                    if (await Permission.storage.status.isDenied) {
                      await Permission.storage.request();
                    }
                  }
                  try {
                    final downloadTask = await FlutterDownloader.enqueue(
                      url: link,
                      savedDir: '/storage/emulated/0/Download',
                      showNotification: true,
                      openFileFromNotification: true,
                      saveInPublicStorage: true,
                      fileName: 'Hostel Companion $ver.apk',
                    );
                    print(downloadTask);
                  } catch (e) {
                    print("some error occurred \n$e");
                  }

                  // Navigator.of(context).pop();
                  // open the latestUpdate link in webview
                },
              ),
            ],
          );
        });
  }

  void _retryDialog() async {
    print("retryDialog");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("No internet connection"),
            content:
                Text("Please check your internet connection and try again."),
            actions: <Widget>[
              TextButton(
                  child: Text("RETRY"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _checkInternetConnectionAndNavigate();
                  })
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnectionAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
