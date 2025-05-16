import 'package:flutter/material.dart';
import 'package:hotnchill/services/shared_prefences.dart';
import 'package:hotnchill/utils/routes/route_names.dart';
import 'package:hotnchill/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import '../view_model/auth_view_model.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
  final sharedprefences=SharedPreferencesHelper();
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                Container(
                  height: screenHeight * 0.35,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(40, 70),
                      bottomLeft: Radius.elliptical(40, 70),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.23,
                  right: screenWidth * 0.06,
                  left: screenWidth * 0.06,
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    elevation: 15,
                    child: Container(
                      height: screenHeight * 0.6, // Adjusted height to fit content
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Center(
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller:userViewModel.nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outlined, size: 25),
                                hintText: 'Name',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: userViewModel.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined, size: 25),
                                hintText: 'abc@example.com',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: userViewModel.passwordController,
                              obscureText: authViewModel.obscurePassword, // Use ViewModel state
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_open_outlined, size: 25),
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    authViewModel.obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: authViewModel.togglePasswordVisibility, // Use ViewModel method
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            authViewModel.isLoading
                                ? Center(child: CircularProgressIndicator())
                                : GestureDetector(
                              onTap: () async {
                                if (userViewModel.nameController.text.isEmpty) {
                                  Utils.flushBarErrorMessage("Please enter name", context);
                                  return;
                                }
                                if (userViewModel.emailController.text.isEmpty) {
                                  Utils.flushBarErrorMessage("Please enter email", context);
                                  return;
                                }
                                if (!isValidEmail(userViewModel.emailController.text)) {
                                  Utils.flushBarErrorMessage("Please enter a valid email", context);
                                  return;
                                }
                                if (userViewModel.passwordController.text.isEmpty) {
                                  Utils.flushBarErrorMessage("Please enter password", context);
                                  return;
                                 }
                                if (userViewModel.passwordController.text.length < 6) {
                                  Utils.flushBarErrorMessage("Password must be at least 6 characters", context);
                                  return;
                                }


                                try {
                                  bool isSuccess = await authViewModel.getRegister(
                                    userViewModel.emailController.text,
                                    userViewModel.passwordController.text,
                                    context,
                                  );

                                  if (isSuccess) {
                                    if (authViewModel.currentUserId != null) {
                                      await sharedprefences.saveUserId(authViewModel.currentUserId!);
                                      await sharedprefences.saveUserName(userViewModel.nameController.text);
                                      await sharedprefences.saveUserEmail(userViewModel.emailController.text);
                                    }
                                    await userViewModel.addUserDetail();
                                   Navigator.pushReplacementNamed(context, RouteNames.bottomNav);
                                    Utils.flushBarErrorMessage("Registration SuccessFully", context);
                                  } else {
                                    Utils.flushBarErrorMessage("Registration failed! Try again.", context);
                                  }
                                } catch (e) {
                                  Utils.flushBarErrorMessage("Network Error: ${e.toString()}", context);
                                }
                              },
                              child: Center(
                                child: Material(
                                  elevation: 7,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: Container(
                                    height: screenHeight * 0.05,
                                    width: screenWidth * 0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, RouteNames.login);
                              },
                              child: Center(
                                child: Text(
                                  "Already have an account? Login",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
