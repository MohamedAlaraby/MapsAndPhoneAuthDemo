abstract class PhoneAuthStates {}

class PhoneAuthCubitInitial extends PhoneAuthStates {}

class PhoneAuthLoadingState extends PhoneAuthStates {}

class PhoneAuthErrorState extends PhoneAuthStates {
  String error;
  PhoneAuthErrorState({required this.error});
}

class PhoneAuthSubmitedSuccessState extends PhoneAuthStates {}

class PhoneAuthOtpVerifiedSuccessState extends PhoneAuthStates {}
