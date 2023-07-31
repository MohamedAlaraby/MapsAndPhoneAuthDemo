import 'package:bloc/bloc.dart';
import 'package:first_project/business_logic/phone_auth/phone_auth_cubit.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  PhoneAuthCubit() : super(PhoneAuthCubitInitial());
}
