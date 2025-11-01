import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const TopBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1.35,
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w700,
              height: 1.56,
            ),
          ),
        ],
      ),
    );
  }
}
