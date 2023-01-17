// ignore_for_file: public_member_api_docs, sort_ructors_first, prefer_const_constructors, unnecessary_this
import 'package:flutter/material.dart';

import 'package:todo_list_provider/app/core/ui/todo_list_icons.dart';

class TodoListFild extends StatelessWidget {
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? type;
  final bool autoCorret;
  final FocusNode? focusNode;

  TodoListFild({
    Key? key,
    required this.label,
    this.suffixIconButton,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.autoCorret = false,
    this.type,
    this.focusNode,
  })  : assert(obscureText == true ? suffixIconButton == null : true,
            "Obscure text não pode ser enviado em conjunto com sufizIcon"),
        obscureTextVN = ValueNotifier(obscureText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextVN,
      builder: (_, obscureTextValue, child) {
        return TextFormField(
          focusNode: focusNode,
          autocorrect: autoCorret,
          keyboardType: type,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            labelText: label,
            labelStyle: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red),
            ),
            isDense: true,
            suffixIcon: this.suffixIconButton ??
                (obscureText == true
                    ? IconButton(
                        icon: Icon(!obscureTextValue
                            ? TodoListIcons.eye_off
                            : TodoListIcons.eye),
                        onPressed: () {
                          obscureTextVN.value = !obscureTextValue;
                        },
                        iconSize: 15,
                      )
                    : null),
          ),
          obscureText: obscureTextValue,
        );
      },
    );
  }
}
