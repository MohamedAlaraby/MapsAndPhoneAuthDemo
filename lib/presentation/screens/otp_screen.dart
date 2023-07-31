import 'package:first_project/constants/my_color.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  String? phoneNumber;
  OtpScreen({super.key});

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
                buildVerifyButton(),
              ],
            ),
          ),
        ),
      ),
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
      onCompleted: (v) {
        print("Completed");
      },
      onChanged: (value) {
        print(value);
      },
      appContext: context,
    );
  }

  Widget buildVerifyButton() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ElevatedButton(
        onPressed: () {},
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
}
