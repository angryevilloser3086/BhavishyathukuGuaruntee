import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_utils.dart';
import 'answer.dart';
import 'result_screen.dart';

class Questions extends StatefulWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;
  final int totalScore;
  final Function(bool) resetQuiz;
  final Size size;
   Questions(
      {super.key,
      required this.questions,
      required this.questionIndex,
      required this.answerQuestion,
      required this.size,
      required this.totalScore,
      required this.resetQuiz});
    
  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  int selectedOptionIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    print("called");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.questionIndex);
    return widget.questionIndex < widget.questions.length
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // questionTag("1", quest[0], size)
              questionTag("${widget.questionIndex + 1}",
                  widget.questions[widget.questionIndex]['question'].toString(), widget.size),

              // Align(
              //     alignment: Alignment.topLeft,
              //     child: Answer((score) {
              //       answerQuestion(score);
              //     },
              //         questions[questionIndex]['options']
              //             as List<Map<String, Object>>))
              optionsSelection(widget.questions[widget.questionIndex]['options']
                           as List<Map<String, Object>>)
            ],
          )
        : Result(widget.totalScore, widget.resetQuiz);
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
        if (size.width > 550) AppConstants.w_10,
        if (size.width < 550) Spacer(),
        SizedBox(
            width: size.width * 0.45,
            //height: size.height*0.35,
            child: Text(
              quest,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: size.width < 450 ? 10 : 12,
                  fontWeight: FontWeight.w500),
              maxLines: 10,
            )),
        Spacer()
      ],
    );
  }

  optionsSelection( List<Map<String, dynamic>> options){
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                widget.answerQuestion(int.parse(options[index]['score']));
                // print("Cliked Button");
                selectedOptionIndex = index;
              },
              child: Padding(
                padding: AppConstants.all_5,
                child: Container(
                  padding: AppConstants.all_10,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration:  BoxDecoration(
                      color: AppConstants.appYellowBG,
                      borderRadius:const BorderRadius.all(Radius.circular(15))),
                  child: Text(
                    options[index]['text'],
                    style:
                        GoogleFonts.poppins(fontSize: 13, color: Colors.black),
                  ),
                ),
              ),
            ); //Container
          }),
    );
  
  }




}
