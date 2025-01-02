import 'package:flutter/material.dart';

import 'vertical_rotated.dart';

class Tategaki extends StatelessWidget {
  const Tategaki(
    this.text, {super.key, 
    this.style,
    this.space = 5,
  });

  final String text;
  final TextStyle? style;
  final double space;

  @override
  Widget build(BuildContext context) {
    final splitText = text.split("\n");
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        for (var s in splitText) _textBox(s.runes),
      ],
    );
  }

  Widget _textBox(Runes runes) {
    return Wrap(
      textDirection: TextDirection.rtl,
      direction: Axis.vertical,
      children: [
        for (var rune in runes)
          Row(
            children: [
              SizedBox(
                width: space,
              ),
              _character(String.fromCharCode(rune)),
              SizedBox(
                width: space,
              ),
            ],
          ),
      ],
    );
  }

  Widget _character(String char) {
    if (VerticalRotated.map[char] != null) {
      return Text(VerticalRotated.map[char]!, style: style);
    } else {
      return Text(char, style: style);
    }
  }
}