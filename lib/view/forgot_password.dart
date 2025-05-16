import 'package:flutter/material.dart';
import 'package:hotnchill/view_model/auth_view_model.dart';

import '../utils/routes/route_names.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
    final authViewModel=AuthViewModel();
    TextEditingController emailController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  "Password Recovery",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "Enter your email",
                style: TextStyle(
                  fontFamily: "poppins",
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 17,right: 17),
              child: TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white), // White text color
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                  filled: true,
                  hintText: "Enter email",
                  hintStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.black, // White background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.white), // White border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ), // White border when focused
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: authViewModel.isLoading
                  ? null
                  : () {
                authViewModel.getLinkForPassword(
                  emailController.text.trim(),
                  context,
                );
              },
              child: Center(
                child: Material(
                  elevation: 7,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: authViewModel.isLoading
                          ? CircularProgressIndicator(color: Colors.black)
                          : Text(
                        "Send Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30,),
            GestureDetector(
              onTap: () { Navigator.pushReplacementNamed(context, RouteNames.signUp);},
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Do not have an account ? ", style: TextStyle(color: Colors.white70, fontSize: 21)),
                    TextSpan(text: " Sign up", style: TextStyle(color: Colors.orangeAccent, fontSize: 22)),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
