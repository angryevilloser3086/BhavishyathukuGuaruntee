

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Result extends StatelessWidget {
  final int resultScore;
  final Function(bool) resetHandler;

  const Result(this.resultScore, this.resetHandler, {Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         const Text(
            "Thanks for taking the Quiz",
            style:  TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          Text(
            'Score ' '$resultScore',
            style: GoogleFonts.poppins(
                fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ), //Text

          // FlatButton is deprecated and should not be used
          // Use TextButton instead

          // FlatButton(
          // child: Text(
          //	 'Restart Quiz!',
          // ), //Text
          // textColor: Colors.blue,
          // onPressed: resetHandler(),
          // ), //FlatButton
        ], //<Widget>[]
      ), //Column
    ); //Center
  }
}
