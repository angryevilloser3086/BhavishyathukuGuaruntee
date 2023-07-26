import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String? id;
  const DetailsScreen({super.key,  this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.black,
        child: Center(child: Text("$id"),),),
    );
  }
}