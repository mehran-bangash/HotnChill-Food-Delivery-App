import 'package:flutter/material.dart';
import 'package:hotnchill/resources/widget/content_model.dart';
import 'package:hotnchill/utils/routes/route_names.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var content in contents) {
      precacheImage(AssetImage(content.image), context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final double titleFontSize = screenWidth > 600 ? 24 : 22;
    final double descriptionFontSize = screenWidth > 600 ? 18 : 16;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              allowImplicitScrolling: true, // Preload next page
              onPageChanged: (int index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.03,
                          right: screenWidth * 0.03,
                          top: screenHeight * 0.08,
                        ),
                        child: Image.asset(
                          contents[i].image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                      child: Text(
                        contents[i].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.16),
                      child: Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Page Indicator (optimized)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index == currentIndex),
              ),
            ),
          ),

          // Navigation Button
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: GestureDetector(
              onTap: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushNamed(context, RouteNames.signUp);
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    currentIndex == contents.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "poppins",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 10,
      width: isActive ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
