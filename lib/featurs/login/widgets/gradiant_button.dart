import 'package:flutter/material.dart';

class GradiantButton extends StatelessWidget {
  const GradiantButton({
    Key? key,
    required this.screenWidth,
    required this.buttonLabel,
    required this.onPressed,
    required this.fontSize,
  }) : super(key: key);

  final double screenWidth;
  final String buttonLabel;
  final double fontSize;

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 149, 243, 255),
            Color.fromARGB(255, 0, 234, 234),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius:
            BorderRadius.circular(10.0), // Adjust the border radius as needed
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            buttonLabel,
            style: TextStyle(
              fontFamily: "Hayah",
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}






// class GradiantButton extends StatelessWidget {
//   const GradiantButton({
//     super.key,
//     required this.screenWidth,
//     required this.buttonLabel,
//   });

//   final double screenWidth;
//   final String buttonLabel;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         style: ButtonStyle(
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(
//                   20.0), // Adjust the border radius as needed
//             ),
//           ),
//         ),
//         onPressed: () {},
//         child: Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 5),
//           child: Text(
//             buttonLabel,
//             style: TextStyle(fontFamily: "Hayah", fontSize: screenWidth * 0.08),
//           ),
//         ));
//   }
// }
