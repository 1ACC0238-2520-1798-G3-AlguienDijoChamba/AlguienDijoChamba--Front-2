import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  final int maxRating;
  final Function(int) onRatingChanged;
  final int initialRating;

  const StarRatingWidget({
    Key? key,
    this.maxRating = 5,
    required this.onRatingChanged,
    this.initialRating = 0,
  }) : super(key: key);

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.maxRating, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingChanged(_currentRating);
          },
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: index < _currentRating
                ? const Color(0xFFFFD700)
                : const Color(0xFFBDBDBD),
            size: 40,
          ),
        );
      }),
    );
  }
}
