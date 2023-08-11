import 'package:first_project/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:first_project/business_logic/phone_auth/phone_auth_states.dart';
import 'package:first_project/constants/my_colors.dart';
import 'package:first_project/constants/my_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  late String otpCode;
  OtpScreen({required this.phoneNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                _buildWelcomeTexts(),
                const SizedBox(height: 40),
                _buildPinCodeFields(context),
                buildVerifyButton(context),
                _buildPhoneNumberVerificationBloc(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberVerificationBloc() {
    //like the BlocConsumer
    return BlocListener<PhoneAuthCubit, PhoneAuthStates>(
      child: Container(),
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is PhoneAuthLoadingState) {
          _showProgressIndicator(context);
        }
        if (state is PhoneAuthOtpVerifiedSuccessState) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(
            context,
            mapScreen,
          );
        }
        if (state is PhoneAuthErrorState) {
          Navigator.pop(context);
          String error = state.error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error,
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.black,
            ),
          );
        }
      },
    );
  }

  //just to customize the circluler progress indicator.
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

  Widget _buildPinCodeFields(context) {
    return PinCodeTextField(
      length: 6,
      autoFocus: true,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeColor: MyColors.blue,
        inactiveColor: MyColors.blue,
        activeFillColor: MyColors.lightBlue,
        inactiveFillColor: Colors.white,
        selectedColor: MyColors.blue,
        selectedFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      enableActiveFill: true,
      onCompleted: (code) {
        print("Completed");
        otpCode = code;
      },
      onChanged: (value) {
        print(value);
      },
      appContext: context,
    );
  }

  Widget buildVerifyButton(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ElevatedButton(
        onPressed: () {
          _showProgressIndicator(context);

          _login(context);
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
          'Verify',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        const Text(
          'Verify your Phone number.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
                text: "Enter your 6 digits that sent to ",
                style: const TextStyle(
                    color: Colors.black, fontSize: 18, height: 1.4),
                children: <TextSpan>[
                  TextSpan(
                    text: "$phoneNumber",
                    style: const TextStyle(color: MyColors.blue, fontSize: 18),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  void _login(BuildContext context) {
    BlocProvider.of<PhoneAuthCubit>(context).submitOtp(otpCode: otpCode);
  }
}
