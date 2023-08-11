import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/business_logic/phone_auth/phone_auth_states.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  String? verificationId;
  PhoneAuthCubit() : super(PhoneAuthCubitInitial());

  Future<void>? submitPhoneNumber({required String phoneNumber}) async {
    emit(PhoneAuthLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 30),
      phoneNumber: '+2$phoneNumber',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  //we will call this function ,when the code autofilled.
  void verificationCompleted(PhoneAuthCredential credential) async {
    print("###verification completed");
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException exception) {
    print("###${exception.message.toString()}");

    emit(PhoneAuthErrorState(error: exception.message.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    print("###codeSent()");
    this.verificationId = verificationId;
    emit(PhoneAuthSubmitedSuccessState());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print("###codeAutoRetrievalTimeout()");
  }

  //we will call this function ,when the code haven't autofilled.
  void submitOtp({required String otpCode}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otpCode,
    );
    await signIn(credential);
  }

  Future<void>? signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneAuthOtpVerifiedSuccessState());
    } catch (e) {
      emit(PhoneAuthErrorState(error: e.toString()));
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    return FirebaseAuth.instance.currentUser!;
  }
} //end of the cubit class
