import 'package:flutter/material.dart';

class NumberButton extends StatefulWidget {
  final int keypadNumber;
  final bool isClicked;
  final VoidCallback onPressed;
  const NumberButton({
    super.key,
    required this.keypadNumber,
    required this.isClicked,
    required this.onPressed,
  });
  @override
  State<NumberButton> createState() => _NumberButtonState();
}

class _NumberButtonState extends State<NumberButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: widget.isClicked ? Colors.green : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: widget.isClicked ? const Color(0xFFae27f2) : Colors.white,
              width: 2.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            '${widget.keypadNumber}',
            style: TextStyle(
              color: widget.isClicked ? Colors.white : Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
