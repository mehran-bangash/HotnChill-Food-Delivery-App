import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../model/user_model.dart';
import '../services/auth_service.dart';
import '../utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AuthViewModel with ChangeNotifier {
  static final AuthViewModel _instance = AuthViewModel._internal();
  factory AuthViewModel() => _instance;
  AuthViewModel._internal();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading=>_isLoading;
  bool _obscurePassword = true; // Add this line
  bool get obscurePassword => _obscurePassword;
  String? get currentUserId {
    try {
      // Returns UID if user is logged in, otherwise null
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (e, stackTrace) {
      // Log error for debugging (use a proper logger in production)
      debugPrint('Error fetching current user UID: $e');
      debugPrint('Stack trace: $stackTrace');
      return null; // Fail gracefully
    }
  }
  Future<String?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }
  Future<bool> checkInternet() async {
    List<ConnectivityResult> connectivityResult =
    await Connectivity().checkConnectivity();

    // Return true if any connection exists (not 'none')
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<bool> getRegister(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check Internet Connection
      bool isConnected = await checkInternet();
      if (!isConnected) {
        _isLoading = false;
        notifyListeners();
        Utils.toastMessage("No internet Connection");
        return false;
      }

      UserModel? user = await _authService.register(email, password);

      _isLoading = false;
      notifyListeners();

      if (user != null) {
       Utils.toastMessage("Registration Successfully ");
        return true;
      }
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      Utils.toastMessage(e.toString());
      return false;
    }
  }

  Future<bool> getLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check Internet Connection
      bool isConnected = await checkInternet();
      if (!isConnected) {
        _isLoading = false;
        notifyListeners();
        Utils.toastMessage("No internet connection");
        return false;
      }

      String? errorMessage = await _authService.login(email, password);

      _isLoading = false;
      notifyListeners();

      if (errorMessage != null) {
        Utils.toastMessage(errorMessage);// Show error message
        return false;
      }

      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      Utils.toastMessage("An error occurred. Please try again.");
      return false;
    }
  }

  Future<bool> getLinkForPassword(String email, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      bool isConnected = await checkInternet();
      if (!isConnected) {
        _isLoading = false;
        notifyListeners();
        Utils.toastMessage("No Internet Connection");
        return false;
      }

      String? errorMessage = await _authService.forgotPassword(email);

      if (errorMessage != null) {
        Utils.toastMessage(errorMessage);// Show error message
        return false;
      }
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
     Utils.toastMessage( "An error occurred. Please try again.");
      return false;
    }
  }
  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      Utils.toastMessage("Error: ${e.toString()}");
      return false;
    }
  }


  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners(); // This will rebuild dependent widgets
  }
}
