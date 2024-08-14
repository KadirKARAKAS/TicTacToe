import 'package:flutter/material.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _colorOption(Colors.red),
        const SizedBox(width: 10),
        _colorOption(Colors.blue),
        const SizedBox(width: 10),
        _colorOption(Colors.green),
      ],
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1)),
        child: selectedColor == color
            ? const Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }
}
