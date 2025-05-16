import 'package:flutter/material.dart';

class AdminDetailTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  const AdminDetailTextField({super.key, required this.title, required this.controller});

  @override
  State<AdminDetailTextField> createState() => _AdminDetailTextFieldState();
}

class _AdminDetailTextFieldState extends State<AdminDetailTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            height: 120, // Increase height for multi-line text
            width: 500,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.multiline,
              maxLines: null, // Allows unlimited lines
              expands: true, // Ensures text area fills the container
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}