import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotnchill/repository/item_repository.dart';
import 'package:hotnchill/view/item_detail.dart';
import 'package:hotnchill/view/sign_up.dart';
import 'package:hotnchill/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isExpandedText = false;
  bool iceCream = false, pizza = false, hotChicken = false, burger = false;


  Stream<QuerySnapshot>? foodStream;

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    // Set iceCream to true by default
    foodStream = ItemRepository().getFoodItem("Burger");
  }

  Widget showHorizontalProduct() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                        ItemDetail(imageUrl: ds["imageUrl"], title:ds["name"], detail: ds["detail"], price: ds["price"]),));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Material(
                      color: Colors.white,
                      elevation: 5,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        margin: EdgeInsets.only(top: 20, left: 10),
                        height: 350,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Image.network(
                                        ds["imageUrl"],
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ); // shows if image fails
                                        },
                                        loadingBuilder: (
                                          context,
                                          child,
                                          progress,
                                        ) {
                                          return progress == null
                                              ? child
                                              : Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  ds["name"],
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    isExpandedText = !isExpandedText;
                                    setState(() {});
                                  },
                                  child: Text(
                                    ds["detail"],
                                    maxLines:
                                        isExpandedText
                                            ? null
                                            : 1, // Expand text when clicked
                                    overflow:
                                        isExpandedText
                                            ? TextOverflow.visible
                                            : TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Rs ${ds["price"]}",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
            : CircularProgressIndicator();
      },
    );
  }

  Widget showVerticalItem() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context,AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
             itemCount: snapshot.data.docs.length,
             shrinkWrap: true,
              padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
               DocumentSnapshot ds=snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                        ItemDetail(imageUrl: ds["imageUrl"], title:ds["name"], detail: ds["detail"], price: ds["price"]),));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          // Ensures proper width distribution
                          child: Material(
                            elevation: 8,
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              margin: EdgeInsets.only(top: 10, left: 5),
                              height: MediaQuery.of(context).size.height * 0.19,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.15,
                                        width: MediaQuery.of(context).size.width * 0.35,
                                        child: Image.network(
                                          ds["imageUrl"],
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.error,color: Colors.red,);

                                          },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            return loadingProgress==null?child:Center(child: CircularProgressIndicator(),);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 13),
                                  Expanded(
                                    // Wrap Column to avoid overflow
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 28,
                                        left: 5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ds["name"],
                                            style: TextStyle(
                                              fontFamily: "poppins",
                                              color: Colors.black,
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isExpandedText =
                                                !isExpandedText;
                                              });
                                            },
                                            child: Flexible(
                                              child: Text(
                                                ds["detail"],
                                                maxLines:
                                                isExpandedText ? null : 1,
                                                overflow:
                                                isExpandedText
                                                    ? TextOverflow.visible
                                                    : TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: "poppins",
                                                  color: Colors.grey.shade600,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Flexible(
                                            child: Text(
                                              "Rs:${ds["price"]}",
                                              style: TextStyle(
                                                fontFamily: "poppins",
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
            : CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel=Provider.of<UserViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: Icon(Icons.arrow_back, size: 30, color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  "${userViewModel.user?.displayName}",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delicious Food",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "Discover and Get Great Food",
                      style: TextStyle(
                        fontFamily: "poppins",
                        color: Colors.blueGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              showItem(),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  "Explore Menu",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(height: 8),

              SizedBox(
                height: 350, // Give it a fixed height
                child: showHorizontalProduct(),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                child: Text(
                  "Best Seller",
                  style: TextStyle(
                    fontFamily: "poppins",
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Column(
                children: [
                  showVerticalItem()

                ],
              ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 🍦 Ice Cream
        GestureDetector(
          onTap: () {
            iceCream = true;
            hotChicken = false;
            burger = false;
            pizza = false;
            foodStream = ItemRepository().getFoodItem("Icecream");
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.19,
                decoration: BoxDecoration(
                  color: iceCream ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Image.asset(
                          "assets/images/ice-cream.png",
                          color: iceCream ? Colors.white : Colors.black,
                          fit: BoxFit.contain,
                          width: constraints.maxWidth * 0.8,
                          height: constraints.maxHeight * 0.8,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        // 🍔 Burger
        GestureDetector(
          onTap: () {
            iceCream = false;
            hotChicken = false;
            burger = true;
            pizza = false;
            foodStream = ItemRepository().getFoodItem("Burger");
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 8),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.19,
                decoration: BoxDecoration(
                  color: burger ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Image.asset(
                          "assets/images/burger.png",
                          color: burger ? Colors.white : Colors.black,
                          fit: BoxFit.contain,
                          width: constraints.maxWidth * 0.8,
                          height: constraints.maxHeight * 0.8,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        // 🍗 Hot Chicken
        GestureDetector(
          onTap: () {
            iceCream = false;
            hotChicken = true;
            burger = false;
            pizza = false;
            foodStream = ItemRepository().getFoodItem("ChickenHot");
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 8),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.19,
                decoration: BoxDecoration(
                  color: hotChicken ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Image.asset(
                          "assets/images/chicken.png",
                          color: hotChicken ? Colors.white : Colors.black,
                          fit: BoxFit.contain,
                          width: constraints.maxWidth * 0.8,
                          height: constraints.maxHeight * 0.8,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        // 🍕 Pizza
        GestureDetector(
          onTap: () {
            iceCream = false;
            hotChicken = false;
            burger = false;
            pizza = true;
            foodStream = ItemRepository().getFoodItem("Pizza");
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 8),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.19,
                decoration: BoxDecoration(
                  color: pizza ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Image.asset(
                          "assets/images/pizza.png",
                          color: pizza ? Colors.white : Colors.black,
                          fit: BoxFit.contain,
                          width: constraints.maxWidth * 0.8,
                          height: constraints.maxHeight * 0.8,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
