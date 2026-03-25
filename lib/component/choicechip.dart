import 'package:flutter/material.dart';

class MyChoiceChip extends StatelessWidget {
  final String selectedValue;
  final Function(String) onSelected;

  const MyChoiceChip({super.key, required this.selectedValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final methods = ["All Employess", "Design", "Engineering", "Operations", " Marketing" ];
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Wrap(
        spacing: 12,
        children: methods.map((method) {
          final isSelected = selectedValue == method;
          return ChoiceChip(
            label: Text(method, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
            checkmarkColor: Colors.black,
            selected: isSelected,
            selectedColor: const Color.fromARGB(255, 147, 157, 245),
            backgroundColor: const Color.fromARGB(255, 27, 24, 39),
            onSelected: (_) => onSelected(method),
          );
        }).toList(),
      ),
    );
  }
}