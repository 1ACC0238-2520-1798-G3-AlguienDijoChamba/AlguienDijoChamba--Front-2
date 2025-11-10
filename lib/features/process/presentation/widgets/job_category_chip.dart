import 'package:flutter/material.dart';

class JobCategoryChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final bool isSelected;
  final VoidCallback? onTap;

  const JobCategoryChip({
    Key? key,
    required this.label,
    required this.backgroundColor,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor.withOpacity(0.8) : backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFF4169E1), width: 2)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? const Color(0xFF212121) : const Color(0xFF424242),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
