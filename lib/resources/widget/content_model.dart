class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent({
    required this.description,
    required this.image,
    required this.title,
  });
}
  List<UnboardingContent> contents = [
    UnboardingContent(
      title: "Hot Meals. Chill Vibes.",
      description: "Enjoy HotnChill’s best dishes    hot, delicious, and   deeply\n                   satisfying.",
      image: "assets/images/screen1.jpg",
    ),
    UnboardingContent(
      title: "Easy & Secure Payments",
      description: "Pay your way with cash, card, or wallet. Smooth, fast,    and worry\n                free every time.",
      image: "assets/images/screen2.jpg",
    ),
    UnboardingContent(
      title: "Delivered in No Time",
      description: "Fast delivery of your meals, hot \n                     and fresh.",
      image: "assets/images/screen3.jpg",
    ),
  ];

