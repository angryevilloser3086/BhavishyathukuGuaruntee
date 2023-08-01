import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vregistration/utils/app_utils.dart';

class Answer extends StatelessWidget {
  final Function(int) selectHandler;
  final String answerText;
  final int value;

  const Answer(this.selectHandler, this.answerText, this.value, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // use SizedBox for white space instead of Container
    return InkWell(
      onTap: () {
        selectHandler(value);
        print("Cliked Button");
      },
      child: Padding(
        padding: AppConstants.all_5,
        child: Container(
          padding: AppConstants.all_10,
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: const BoxDecoration(
              color: AppConstants.appYellowBG,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Text(
            answerText,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black),
          ),

          // RaisedButton is deprecated and should not be used
          // Use ElevatedButton instead

          // child: RaisedButton(
          // color: const Color(0xFF00E676),
          // textColor: Colors.white,
          // onPressed: selectHandler(),
          // child: Text(answerText),
          // ), //RaisedButton
        ),
      ),
    ); //Container
  }
}
