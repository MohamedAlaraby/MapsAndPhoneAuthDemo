import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'phone_auth_states.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  PhoneAuthCubit() : super(PhoneAuthCubitInitial());
}
