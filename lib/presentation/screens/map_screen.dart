import 'package:first_project/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:first_project/constants/my_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? phoneNumber;

  var cubit = PhoneAuthCubit();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildNextButton() {
    return BlocProvider<PhoneAuthCubit>(
      create: (context) => cubit,
      child: ElevatedButton(
        onPressed: () async {
          await cubit.signOut();
          Navigator.of(context).pushReplacementNamed(loginScreen);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(110, 50),
          // ignore: deprecated_member_use
          primary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text(
          'Sign out',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showProgressIndicator(context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      ),
    );
    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) => alertDialog,
    );
  }
}
