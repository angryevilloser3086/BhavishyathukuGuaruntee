// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web =FirebaseOptions(
        apiKey: "AIzaSyBMg7coOVDddbu2pQdiOSS9gIcL9g0eXOc",
        authDomain: "bhavishyathukuguarantee-d3199.firebaseapp.com",
        projectId: "bhavishyathukuguarantee-d3199",
        storageBucket: "bhavishyathukuguarantee-d3199.appspot.com",
        messagingSenderId: "174297607342",
        appId: "1:174297607342:web:b5badce64bf01ab422513f",
        measurementId: "G-0XVQ3VP3E9");

  static  const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIrBtPCOzcpxkBaMhlwiv_2Edc3Mq91yQ',
    appId: '1:174297607342:android:973c3fba57d5f4d322513fe',
    messagingSenderId: '174297607342',
    projectId: 'bhavishyathukuguarantee-d3199',
    storageBucket: 'bhavishyathukuguarantee-d3199.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_NfJWu5WK5ijKTFRj078WFFQHBCPHMro',
    appId: '1:174297607342:ios:66b07193d08c291622513f',
    messagingSenderId: '174297607342',
    projectId: 'bhavishyathukuguarantee-d3199',
    storageBucket: 'bhavishyathukuguarantee-d3199.appspot.com',
    androidClientId: '174297607342-ciuq9nkmut1lkqq650mql6kijhp5r4n9.apps.googleusercontent.com',
    iosBundleId: 'com.example.vregistration',
  );
}