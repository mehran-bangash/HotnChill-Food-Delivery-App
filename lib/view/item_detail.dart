import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotnchill/view/bottom_nav.dart';
import 'package:hotnchill/view_model/item_detail_view_model.dart';
import 'package:provider/provider.dart';

class ItemDetail extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  final String? detail;
  final String? price;

  const ItemDetail({
    super.key,
    this.imageUrl,
    this.title,
    this.detail,
    this.price,
  });

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  bool isExpandedText = false;
  late ItemDetailViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ItemDetailViewModel>(context, listen: false);
    // Parse price but don't set it yet
    final parsedPrice = int.tryParse(widget.price ?? '0') ?? 0;

    // Use Future.microtask to defer the initialization
    Future.microtask(() {
      viewModel.initialize(parsedPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<ItemDetailViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
                    MaterialPageRoute(builder: (context) => BottomNav()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 0),
                  child: Icon(Icons.arrow_back, color: Colors.black, size: 40),
                ),
              ),
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = constraints.maxWidth * 0.6;
                    return Container(
                      height: size,
                      width: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          widget.imageUrl ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error,
                              color: Colors.red,
                              size: size * 0.3,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            return loadingProgress == null
                                ? child
                                : Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(height: 1, width: screenWidth, color: Colors.black54),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(
                      widget.title ?? "",
                      style: TextStyle(
                        fontFamily: "poppins",
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: viewModel.decrement,
                        child: Container(
                          height: 25,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.black,
                          ),
                          child: Icon(Icons.remove, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        viewModel.quantity.toString(),
                        style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: viewModel.increment,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            height: 25,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.black,
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpandedText = !isExpandedText;
                    });
                  },
                  child: Text(
                    maxLines: isExpandedText ? null : 4,
                    overflow:
                        isExpandedText
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                    widget.detail ?? "",
                    style: TextStyle(
                      fontFamily: "poppins",
                      color: Colors.grey.shade600,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Delivery Time",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.access_alarm, size: 25),
                  SizedBox(width: 5),
                  Text(
                    "30 min",
                    style: TextStyle(
                      fontFamily: "poppins",
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Price",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rs ${viewModel.totalPrice}",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.addFoodCard(
                        imageUrl: widget.imageUrl!,
                        itemName: widget.title!,
                        quantity: viewModel.quantity.toString(),
                        totalPrice: viewModel.totalPrice.toString(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Container(
                          height: 43,
                          width: screenWidth*0.5,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Add to card",
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: 25,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.cartShopping,
                                  color: Colors.white,
                                  size: 19,
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
      ),
    );
  }
}
