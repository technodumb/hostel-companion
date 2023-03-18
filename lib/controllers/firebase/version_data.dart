import 'package:cloud_firestore/cloud_firestore.dart';

class VersionData {
  final db = FirebaseFirestore.instance;
  final String version = 'v1.0';
  String currentVersion = '0.0.0';

  Future<String> getVersion() async {
    try {
      return await db
          .collection('app_version')
          .doc('all_versions')
          .get()
          .then((value) => value.data()!['current_version'] as String);
    } catch (e) {
      print("GetVersion: $e");
    }
    return '0.0.0';
  }

  Future<bool> isLatest() async {
    currentVersion = await getVersion();
    return currentVersion == version;
  }

  Future<String> getLatestUpdate() async {
    try {
      return await db
          .collection('app_version')
          .doc('all_versions')
          .get()
          .then((value) => value.data()![currentVersion] as String);
    } catch (e) {
      print("GetLatestUpdate: $e");
    }
    return '0.0.0';
  }
}
