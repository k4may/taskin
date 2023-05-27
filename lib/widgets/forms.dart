import 'package:flutter/material.dart';

class FormPad extends StatelessWidget {
  final TextEditingController nomeController;
  String labelText;
  String hintText;
  String validatorText;

  FormPad({Key? key, required this.nomeController, required this.labelText, required this.hintText, required this.validatorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nomeController,
      decoration:  InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
    );
  }
}
