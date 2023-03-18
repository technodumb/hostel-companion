import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hostel_companion/controllers/firebase/version_data.dart';

class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  bool isSignedIn = false;
  VersionData versionData = VersionData();

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
      print("checkInternetConnectionAndNavigate");
      bool isLatest = await versionData.isLatest();
      if (!isLatest) {
        String latestUpdate = await versionData.getLatestUpdate();
        // open the latestUpdate link in webview
        _updateDialog(latestUpdate);
      }
      if (isSignedIn) {
        Navigator.pushNamed(context, '/home');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } else {
      _retryDialog();
    }
  }

  void _updateDialog(String link) async {
    print("updateDialog");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update available"),
            content: Text("Please update the app to continue."),
            actions: <Widget>[
              TextButton(
                child: Text("UPDATE"),
                onPressed: () async {
                  final downloadTask = await FlutterDownloader.enqueue(
                    url: link,
                    savedDir: '/storage/emulated/0/Download',
                    showNotification: true,
                    openFileFromNotification: true,
                  );

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
