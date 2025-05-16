import 'package:flutter/material.dart';

class FirstProfileCard extends StatefulWidget {
  final String firstTitle;
  final String secondTitle;
  final IconData icon;

  const FirstProfileCard({
    super.key,
    required this.firstTitle,
    required this.icon,
    required this.secondTitle,
  });

  @override
  State<FirstProfileCard> createState() => _FirstProfileCardState();
}

class _FirstProfileCardState extends State<FirstProfileCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        height: screenHeight * 0.09,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
              child: Icon(widget.icon, size: 27),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  widget.firstTitle,
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.secondTitle,
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
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
