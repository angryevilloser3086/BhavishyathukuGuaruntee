import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_utils.dart';
import 'answer.dart';
import 'result_screen.dart';

class Questions extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;
  final int totalScore;
  final Function(bool) resetQuiz;
  final Size size;
  const Questions({super.key, required this.questions, required this.questionIndex, required this.answerQuestion, required this.size, required this.totalScore, required this.resetQuiz});

  @override
  Widget build(BuildContext context) {
    print(questionIndex);
    return questionIndex < questions.length
          ?  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         // questionTag("1", quest[0], size)
        questionTag("${questionIndex+1}",questions[questionIndex]['question'].toString(), size),
        ...(questions[questionIndex]['options']as List<Map<String,Object>>).map((answer) {
          return Align(alignment: Alignment.topLeft,child: Answer((score){
            
            answerQuestion(score);}, answer['text'].toString(),answer['score'].toString().isNotEmpty?int.parse(answer['score'].toString()):0));
        }).toList(),
        
          ],
      ): Result(totalScore, resetQuiz);
  }


   questionTag(String qNo, String quest, Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppConstants.w_5,
        CircleAvatar(
          backgroundColor: AppConstants.appredQColor,
          child: Text(
            qNo,
            style: GoogleFonts.poppins(
                color: AppConstants.appYellowBG,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        if(size.width>550)
        AppConstants.w_10,
        if(size.width<550)
        Spacer(),
        SizedBox(
            width: size.width * 0.45,
            //height: size.height*0.35,
            child: Text(
              quest,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize:size.width<450?10: 12,
                  fontWeight: FontWeight.w500),
              maxLines: 10,
            )),
            Spacer()
      ],
    );
  }

 
}