import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hinttext;
  final RegExp validationReGEx;
final void Function(String?) onSaved;

  final obscureText;
   const CustomFormField({super.key, required this.hinttext,
   required this.validationReGEx,
   this.obscureText = false,
   required this.onSaved,
   
   }); 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureText,
        validator: (value) {
          if (value != null && validationReGEx.hasMatch(value)) {
            return null;
          }
          return "Enter a Valid ${hinttext.toLowerCase()}"; 
        },
        decoration:  InputDecoration(
          border: const OutlineInputBorder(),
          hintText:hinttext,
        ),
      autofillHints: const [AutofillHints.email],
      ),
    );
  }
}