import 'package:first_project/constants/my_strings.dart';
import 'package:first_project/presentation/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _phoneFormKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  String? phoneNumber;
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
            child: Form(
              key: _phoneFormKey,
              child: Column(
                children: [
                  _buildWelcomeTexts(),
                  const SizedBox(
                    height: 100,
                  ),
                  CustomFormField(
                    controller: controller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number!';
                      } else if (value.length < 11) {
                        return 'Too short to be a phone number!';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      phoneNumber = newValue!;
                    },
                  ),
                  const SizedBox(height: 70),
                  _buildNextButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, otpScreen);
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
          'Next',
          style: TextStyle(fontSize: 18, color: Colors.white),
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
          'What is your phone number?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: const Text(
            'Please enter your phone number to verify your account.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
