import 'package:flutter/material.dart';

class SecondProfileCard extends StatefulWidget {
  final String title;
  final IconData icon;

  const SecondProfileCard({super.key, required this.title, required this.icon});


  @override
  State<SecondProfileCard> createState() => _SecondProfileCardState();
}

class _SecondProfileCardState extends State<SecondProfileCard> {
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
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 8, right: 8,bottom: 8),
                child: Icon(widget.icon,size: 30,),
              )        ,
              Text(widget.title,style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
              ),)

            ],),
        )
    );
  }
}
