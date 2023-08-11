import 'package:first_project/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:first_project/presentation/screens/login_screen.dart';
import 'package:first_project/presentation/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/my_strings.dart';
import 'presentation/screens/map_screen.dart';

class AppRouter {
  PhoneAuthCubit? cubit;

  AppRouter() {
    cubit = PhoneAuthCubit();
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(
          builder: (context) => MapScreen(),
        );

      case loginScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return BlocProvider<PhoneAuthCubit>.value(
              value: cubit!,
              child: LoginScreen(),
            );
          },
        );

      case otpScreen:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider<PhoneAuthCubit>.value(
              value: cubit!,
              child: OtpScreen(
                phoneNumber: phoneNumber,
              ),
            );
          },
        );
    }
    return null;
  }
}
