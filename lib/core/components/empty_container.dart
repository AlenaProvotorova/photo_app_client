import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  final String text;
  const EmptyContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
