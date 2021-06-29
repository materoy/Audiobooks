import 'package:flutter/material.dart';

class Coverage extends StatefulWidget {
  const Coverage({Key? key}) : super(key: key);

  @override
  _CoverageState createState() => _CoverageState();
}

class _CoverageState extends State<Coverage> {
  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 18.0,
      child: CircleAvatar(
        backgroundColor: Colors.grey,
      ),
    );
  }
}
