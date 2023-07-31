import 'package:first_project/presentation/screens/login_screen.dart';
import 'package:first_project/presentation/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'constants/my_strings.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) {
            return LoginScreen();
          },
        );

      case otpScreen:
        return MaterialPageRoute(
          builder: (_) {
            return OtpScreen();
          },
        );
    }
    return null;
  }
}
