import 'package:flutter/material.dart';

class StatisticsItem extends StatelessWidget {
  final String title;
  final String content;

  const StatisticsItem({
    required this.title,
    required this.content,
    super.key
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(8.0),
    child: Column(
      children: [
      Text(title),
      FittedBox(
        fit: BoxFit.contain,
        child: Text(
          content,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),
      ],
    ),
  );
}