import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> storeUserEmailAndName(
      String uid, String email, String name) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
      });
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  Future<void> initializeRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        minimumFetchInterval: Duration(minutes: 1),
        fetchTimeout: Duration(seconds: 10),
      ));
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Error initializing Remote Config: $e');
    }
  }

  bool getIsSaleConfig() {
    return _remoteConfig.getBool('isSale');
  }
}
