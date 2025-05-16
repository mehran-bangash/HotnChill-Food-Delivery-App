import 'package:flutter/material.dart';
import 'package:hotnchill/utils/routes/route_names.dart';
import 'package:hotnchill/view/Admin/admin_add_item.dart';
import 'package:hotnchill/view/Admin/admin_login.dart';
import 'package:hotnchill/view/bottom_nav.dart';
import 'package:hotnchill/view/forgot_password.dart';
import 'package:hotnchill/view/item_detail.dart';
import 'package:hotnchill/view/login.dart';
import 'package:hotnchill/view/order.dart';
import 'package:hotnchill/view/sign_up.dart';
import 'package:hotnchill/view/wallet.dart';

import '../../view/home.dart';
import '../../view/onboard.dart';
import '../../view/profile.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (context) => Login());
      case RouteNames.signUp:
        return MaterialPageRoute(builder: (context) => SignUp());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (context) => ForgotPassword());
      case RouteNames.home:
        return MaterialPageRoute(builder: (context) => Home());
      case RouteNames.itemDetail:
        return MaterialPageRoute(builder: (context) => ItemDetail());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (context) => Profile());
      case RouteNames.wallet:
        return MaterialPageRoute(builder: (context) => Wallet());
      case RouteNames.order:
        return MaterialPageRoute(builder: (context) => Order());
      case RouteNames.adminLogin:
        return MaterialPageRoute(builder: (context) => AdminLogin());
      case RouteNames.adminAddItem:
        return MaterialPageRoute(builder: (context) => AdminAddItem());
      case RouteNames.bottomNav:
        return MaterialPageRoute(builder: (context) => BottomNav());
      case RouteNames.onboard:
        return MaterialPageRoute(builder: (context) => Onboard());
      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(body: Text("No page Route"));
          },
        );
    }
  }
}
