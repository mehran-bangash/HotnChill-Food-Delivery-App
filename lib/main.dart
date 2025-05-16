import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hotnchill/services/shared_prefences.dart';
import 'package:hotnchill/utils/routes/routes.dart';
import 'package:hotnchill/view/bottom_nav.dart';
import 'package:hotnchill/view/login.dart';
import 'package:hotnchill/view/onboard.dart';
import 'package:hotnchill/view_model/admin_add_item_view_model.dart';
import 'package:hotnchill/view_model/auth_view_model.dart';
import 'package:hotnchill/view_model/item_detail_view_model.dart';
import 'package:hotnchill/view_model/user_view_model.dart';
import 'package:hotnchill/view_model/wallet_view_model.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await _setupStripe();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _setupFirebaseAppCheck(); // 👈 custom setup based on emulator or real device

  runApp(const MyApp());
}

Future<void> _setupStripe() async {
  if (!kIsWeb) {
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  }
}


Future<void> _setupFirebaseAppCheck() async {
  final deviceInfo = DeviceInfoPlugin();
  bool isEmulator = false;

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    isEmulator = !androidInfo.isPhysicalDevice;
  }

  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: isEmulator
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
    );
  } catch (e) {
    debugPrint('Firebase AppCheck failed: $e');
    // Optional: handle fallback or retry
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showOnboarding = true;
  final sharedPreferences = SharedPreferencesHelper();

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await sharedPreferences.getUserID();
    if (prefs != null) {
      setState(() {
        _showOnboarding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => AdminAddItemViewModel()),
        ChangeNotifierProvider(create: (_) => ItemDetailViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HotnChill',
        onGenerateRoute: Routes.generateRoutes,
        home: _showOnboarding
            ? const Onboard()
            : StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData && snapshot.data!.emailVerified) {
              return const BottomNav();
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}
