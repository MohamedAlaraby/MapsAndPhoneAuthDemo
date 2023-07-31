import 'package:first_project/constants/my_color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  late String phoneNumber;
  String? Function(String?)? validator;
  void Function(String?)? onSaved;
  TextEditingController controller;
  CustomFormField(
      {super.key,
      required this.validator,
      required this.onSaved,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.lightGrey, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: Text(
              '${_getCountryFlag()} +20',
              style: const TextStyle(letterSpacing: 2, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.blue, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                letterSpacing: 2.0,
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: validator,
              onSaved: onSaved,
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }

  String _getCountryFlag() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
        );

    return flag;
  }
}
