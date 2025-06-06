// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAq3Ma0LXL0IbUVntpUTV8qEucvMgTq2us',
    appId: '1:976988586166:web:b0f43e356a431a09506617',
    messagingSenderId: '976988586166',
    projectId: 'hotnchill-a5b8b',
    authDomain: 'hotnchill-a5b8b.firebaseapp.com',
    storageBucket: 'hotnchill-a5b8b.firebasestorage.app',
    measurementId: 'G-W3DSJF0251',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEfOaZWXl7hgQizNDl4NVSN0w5FEvhewE',
    appId: '1:976988586166:android:2a59b3324f4c8b60506617',
    messagingSenderId: '976988586166',
    projectId: 'hotnchill-a5b8b',
    storageBucket: 'hotnchill-a5b8b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMKhv0mUhB4BzHsswHPQIGsRa_ubr_514',
    appId: '1:976988586166:ios:e3bedd03e804cc0f506617',
    messagingSenderId: '976988586166',
    projectId: 'hotnchill-a5b8b',
    storageBucket: 'hotnchill-a5b8b.firebasestorage.app',
    iosBundleId: 'com.example.hotnchill',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAq3Ma0LXL0IbUVntpUTV8qEucvMgTq2us',
    appId: '1:976988586166:web:389335d5f78debf3506617',
    messagingSenderId: '976988586166',
    projectId: 'hotnchill-a5b8b',
    authDomain: 'hotnchill-a5b8b.firebaseapp.com',
    storageBucket: 'hotnchill-a5b8b.firebasestorage.app',
    measurementId: 'G-QDT7R1J795',
  );

}