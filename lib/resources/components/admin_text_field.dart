import 'package:flutter/material.dart';

class AdminTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  const AdminTextField({super.key, required this.title, required this.controller});

  @override
  State<AdminTextField> createState() => _AdminTextFieldState();
}

class _AdminTextFieldState extends State<AdminTextField> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 10),
          child: Text(
            widget.title,
            style: TextStyle(
              fontFamily: "poppins",
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 8, right: 10),
          child: Container(
            height: 50,
            width: 500,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: InputBorder.none, // Removes the underline
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ), // Adds padding inside TextField
              ),
            ),
          ),
        ),
      ],
    );
  }
}

