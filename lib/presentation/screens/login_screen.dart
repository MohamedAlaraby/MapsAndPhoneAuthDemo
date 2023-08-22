import '../../constants/my_strings.dart';
import '../widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/phone_auth/phone_auth_cubit.dart';
import '../../business_logic/phone_auth/phone_auth_states.dart';

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
                  _buildPhoneNumberSubmitedBloc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSubmitedBloc() {
    //like the BlocConsumer
    //since i will only naviagte so i don't need to rebuild anything ,
    //so i should use bloc listener not the bloc builder,
    return BlocListener<PhoneAuthCubit, PhoneAuthStates>(
      child: Container(),
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is PhoneAuthLoadingState) {
          _showProgressIndicator(context);
        }
        if (state is PhoneAuthSubmitedSuccessState) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            otpScreen,
            arguments: phoneNumber,
          );
        }
        if (state is PhoneAuthErrorState) {
          Navigator.pop(context);
          String error = state.error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error, style: const TextStyle(color: Colors.white)),
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
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) => alertDialog,
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ElevatedButton(
        onPressed: () {
          _showProgressIndicator(context);
          _register(context);
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

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      //the fields not valdate.
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState!.save(); //to save the phone number.
      BlocProvider.of<PhoneAuthCubit>(context)
          .submitPhoneNumber(phoneNumber: phoneNumber!);
    }
  }
}
