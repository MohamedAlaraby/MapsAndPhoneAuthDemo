import 'business_logic/maps/maps_cubit.dart';
import 'business_logic/phone_auth/phone_auth_cubit.dart';
import 'data/repository/maps_repository.dart';
import 'data/web_services/maps_webservices.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/otp_screen.dart';
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
          builder: (context) => BlocProvider<MapsCubit>(
            create: (context) => MapsCubit(
                repository: SuggestionsRepository(
              suggestionsWebService: PlaceSuggestionWebServices(),
            )),
            child: MapScreen(),
          ),
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
