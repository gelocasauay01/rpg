import 'package:flutter/material.dart';

class EmptyListDisplay extends StatelessWidget {

  final String assetFilePath;
  final String text;

  const EmptyListDisplay({
    required this.assetFilePath,
    required this.text,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          child: Image.asset(assetFilePath)
        ),
        const SizedBox(height: 20),
        Text(
          text,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}