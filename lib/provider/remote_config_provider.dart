// ignore_for_file: avoid_print

import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigProvider with ChangeNotifier {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isSale = false;

  bool get isSale => _isSale;

  RemoteConfigProvider() {
    _initializeRemoteConfig();
  }

  Future<void> _initializeRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        minimumFetchInterval: const Duration(seconds: 5),
        fetchTimeout: const Duration(seconds: 10),
      ));

      await fetchAndActivate();
    } catch (e) {
      print('Error initializing Remote Config: $e');
    }
  }

  Future<void> fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
      _isSale = _remoteConfig.getBool('isSale');
      notifyListeners();
    } catch (e) {
      print('Error fetching and activating Remote Config: $e');
    }
  }
}
