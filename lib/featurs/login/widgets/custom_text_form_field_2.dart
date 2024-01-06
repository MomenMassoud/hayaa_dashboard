import 'package:flutter/material.dart';

class CustomTextFormFieldTwo extends StatefulWidget {
  CustomTextFormFieldTwo({
    super.key,
    required this.screenWidth,
    required this.fielldRatio,
    required this.hintText,
    required this.fieldIcon,
    required this.autovalidateMode,
    this.onSaved,
    required this.hideText,
  });

  final double screenWidth;
  final double fielldRatio;

  final String hintText;
  final Icon fieldIcon;

  final AutovalidateMode autovalidateMode;
  final void Function(String?)? onSaved;
  bool hideText;
  @override
  State<CustomTextFormFieldTwo> createState() => _CustomTextFormFieldTwoState();
}

class _CustomTextFormFieldTwoState extends State<CustomTextFormFieldTwo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        obscureText: widget.hideText,
        onChanged: widget.onSaved,
        autovalidateMode: widget.autovalidateMode,
        decoration: InputDecoration(
          prefix: IconButton(
              onPressed: () {
                setState(() {
                  widget.hideText = !widget.hideText;
                });
              },
              icon: const Icon(Icons.visibility_off_outlined)),
          border: const OutlineInputBorder(),
          suffixIcon: widget.fieldIcon,
          suffixIconColor: Colors.black87,
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
              color: Colors.grey, fontSize: 16.0, fontFamily: "Questv1"),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
