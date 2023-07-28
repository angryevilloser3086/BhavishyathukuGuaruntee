import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vregistration/utils/app_utils.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [quizQuestions(size), logoCard(context, size)],
                ),
                copyRight(size)
              ],
            ),
          ),
        ),
      ),
    );
  }

  copyRight(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.10,
      color: AppConstants.appredColor,
      child: cpyRytTxt(size),
    );
  }

  cpyRytTxt(Size size) {
    return Padding(
      padding: AppConstants.leftRight_20,
      child: Row(
        children: [
          Text(
            "Copyright © 2023",
            style: GoogleFonts.poppins(
                fontSize:size.width<450?12: 18, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Spacer(),
          Text(
            "Follow us on:",
            style: GoogleFonts.poppins(
                fontSize:size.width<450?12: 18, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          socialMediaBtn(size)
        ],
      ),
    );
  }

  socialMediaBtn(Size size) {
    return Container(
      height:size.width<450?25: 35,
      child: Row(children: [
        AppConstants.w_5,
        InkWell(child: Image.asset("assets/images/ic_fb_box.png")),
        AppConstants.w_5,
        InkWell(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5)),
              padding: AppConstants.all_5,
              child: Image.asset("assets/images/twitter_ic.png")),
        ),
        AppConstants.w_5,
        InkWell(child: Image.asset("assets/images/ic_insta+box.png")),
        AppConstants.w_5,
        InkWell(child: Image.asset("assets/images/ic_yt_box.png"))
      ]),
    );
  }

  quizQuestions(Size size) {
    return Container(
        height: size.height * 0.90,
        width: size.width * 0.65,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.h_10,
            Image.asset("assets/images/Logo 1.png"),
            AppConstants.h_24,
            Container(
              height: 11,
              color: AppConstants.appredColor,
            ),
            AppConstants.h_5,
            Container(
              height: 11,
              color: AppConstants.appYellowBG,
            ),
            AppConstants.h_24,
            questionnaireInstruction(size)
          ],
        ));
  }

  questionnaireInstruction(Size size) {
    return Container(
      padding: AppConstants.leftRight_20,
      color: Colors.white,
      width:size.width<450? size.width * 0.55:size.width*0.35,
      height:size.width<450?size.height*0.7: size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instructions",
            style: GoogleFonts.poppins(
                color: AppConstants.appredColor,
                fontWeight: FontWeight.w700,
                fontSize:size.width<450?14:40),
          ),
          Container(
            color: AppConstants.appYellowBG,
            height: 3,
            width: size.width * 0.45,
          ),
          AppConstants.h_5,
          Text(
            "This quiz consists of eight multiple-choice questions. Read each question carefully and select the option you believe is the correct answer.",
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize:size.width<450?12:16),
          ),
          Text(
            '''Click on the "Next" button to move to the next question. Once you have completed all the questions, click on the "Submit" button to view your score.''',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: size.width<450?12:16),
          ),

          AppConstants.h_20,
          InkWell(
            onTap: (){
              log("message");
            },
            child: startBtn(size),
          )

        ],
      ),
    );
  }

  startBtn(Size size){
    return Container(
      width: size.width*0.17,
      height: size.height*0.04,
      decoration:const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: AppConstants.appredColor
      ),
      child: Center(
        child: Text("Start",style: GoogleFonts.poppins(color: AppConstants.appYellowBG,
        fontSize: size.width<450?15:16,fontWeight: FontWeight.w500),),
      ),
    );
  }

  logoCard(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.35,
      height: size.height * 0.90,
      color: AppConstants.appYellowBG,
      padding: AppConstants.all_20,
      child: Image.asset(
        "assets/images/quiz_logo.png",
      ),
    );
  }
}
