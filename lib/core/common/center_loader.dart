import 'package:flutter/material.dart';

class CenterLoader extends StatelessWidget {
  final Color? bgColor;
  const CenterLoader({super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: bgColor,
      ),
    );
  }
}
