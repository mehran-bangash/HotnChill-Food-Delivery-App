import 'package:flutter/material.dart';
import 'package:hotnchill/view_model/auth_view_model.dart';
import 'package:hotnchill/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/routes/route_names.dart';
import '../utils/utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, RouteNames.signUp);
                  },
                  child: Container(
                    height: screenHeight * 1.0,
                    width: screenWidth,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 550),
                      child: Center(
                        child: Text(
                          "Do not have and account? Sign up",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: screenHeight * 0.38,
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
                      height: screenHeight * 0.5,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.3,
                                top: screenHeight * 0.05,
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    size: 25,
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: TextField(
                                controller:passwordController,
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
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouteNames.forgotPassword,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Forgot Password",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            authViewModel.isLoading
                                ? Center(child: CircularProgressIndicator())
                                : GestureDetector(
                                  onTap: () async {
                                    if (emailController.text.isEmpty) {
                                      Utils.flushBarErrorMessage(
                                        "Please enter email",
                                        context,
                                      );
                                      return;
                                    }
                                    if (!isValidEmail(emailController.text)) {
                                      Utils.flushBarErrorMessage(
                                        "Please enter a valid email",
                                        context,
                                      );
                                      return;
                                    }
                                    if (passwordController.text.isEmpty) {
                                      Utils.flushBarErrorMessage(
                                        "Please enter password",
                                        context,
                                      );
                                      return;
                                    }
                                    // if (passwordController.text.length < 6) {
                                    //   Utils.flushBarErrorMessage(
                                    //     "Password must be at least 6 characters",
                                    //     context,
                                    //   );
                                    //   return;
                                    // }
                                    try {
                                      bool isSuccess = await authViewModel
                                          .getLogin(
                                            emailController.text,
                                            passwordController.text,
                                            context,
                                          );
                                      if (isSuccess) {
                                        String? uid =
                                             authViewModel
                                                .currentUserId; // ✅ Get UID from ViewModel
                                        if (uid != null) {
                                          await userViewModel.fetchUserDetail(
                                            uid,
                                          );
                                          Navigator.pushReplacementNamed(
                                            context,
                                            RouteNames.bottomNav,
                                          );
                                        } else {
                                          Utils.flushBarErrorMessage(
                                            "User not logged in.",
                                            context,
                                          );
                                        }
                                      } else {
                                        Utils.flushBarErrorMessage(
                                          "Login failed! Try again.",
                                          context,
                                        );
                                      }
                                    } catch (e) {
                                      Utils.flushBarErrorMessage(
                                        "Network Error: ${e.toString()}",
                                        context,
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Material(
                                      elevation: 7,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        width: screenWidth * 0.4,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Center(
                                          child: authViewModel.isLoading?CircularProgressIndicator(color: Colors.green,): Text(
                                            "Login",
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
