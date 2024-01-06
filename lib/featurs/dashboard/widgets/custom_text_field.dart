import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.initialvalue,
    required this.fieldName,
    this.onChanged,
    required this.isNumber,
    required this.enable,
  });
  final String initialvalue;
  final String fieldName;
  final void Function(String)? onChanged;
  final bool isNumber;
  final bool enable;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> numberList = [
      FilteringTextInputFormatter.digitsOnly
    ];
    List<TextInputFormatter> stringList = [
      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\W]")),
    ];
    List<TextInputFormatter> inputFormat(bool x) {
      if (x == true) {
        return numberList;
      } else {
        return stringList;
      }
    }

    setState(() {
      widget.initialvalue;
    });

    return Column(
      children: [
        SizedBox(
          width: 250,
          child: TextFormField(
            enabled: widget.enable,
            inputFormatters: inputFormat(widget.isNumber),
            initialValue: widget.initialvalue,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.fieldName,
            ),
            onChanged: widget.onChanged,
          ),
        ),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }
}
