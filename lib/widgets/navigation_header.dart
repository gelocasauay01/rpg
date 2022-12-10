import 'package:flutter/material.dart';

class NavigationHeader extends StatelessWidget {

  final String title;
  final Function onNext;
  final Function onPrev;

  const NavigationHeader({
    required this.title,
    required this.onNext,
    required this.onPrev,
    super.key
  });

  @override 
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        onPressed: () => onPrev(), 
        icon: const Icon(Icons.navigate_before)
      ),
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17
        ),
      ),
      IconButton(
        onPressed: () => onNext(), 
        icon: const Icon(Icons.navigate_next)
      ),
    ],
  );
}