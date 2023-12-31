import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_utils.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.height});
  final double height;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  int selectedIndex=-1;

  final questions = const [
    {
      "question":
          "How much financial assistance is going to be provided for children's education through the 'Thalli ki Vandhanam' in the ‘Bhavishyathu ki Guarantee' announced by TDP?",
      "options": [
        {"text": "Rs.5,000  per child", "score": "0"},
        {"text": "Rs.7,000 per child", "score": "0"},
        {"text": "Rs.15,000 per child", "score": "1"},
        {"text": "Rs.10,000 per child", "score": "0"}
      ]
    },
    {
      "question":
          "How much allowance is going to be given to the unemployed youth through the 'Yuvagalam Nidhi' in the 'Bhavishyathu ki Guarantee' announced by the TDP?",
      "options": [
        {"text": "Rs.1,000 per month", "score": "1"},
        {"text": "Rs.2,000 per month", "score": "0"},
        {"text": "Rs.3,000 per month", "score": "0"},
        {"text": "Rs.1500 per month", "score": "0"}
      ]
    },
    {
      "question":
          "What is the name of the special scheme announced for BCs as a part of 'Bhavishyathu ki Guarantee' announced by TDP?",
      "options": [
        {"text": "BC's Assurance Act", "score": "0"},
        {
          "text": "Protection of BCs Act (A new law for the protection of BCs)",
          "score": "1"
        },
        {"text": "For BCs", "score": "0"},
        {"text": "Assistance to BCs", "score": "0"}
      ]
    },
    {
      "question":
          "How many jobs did TDP promise to create in five years through 'Yuvagalam' in 'Bhavishyathu ki Guarantee' ?",
      "options": [
        {"text": "5 lakh jobs", "score": "0"},
        {"text": "7 lakh jobs", "score": "0"},
        {"text": "15 lakh jobs", "score": "0"},
        {"text": "20 lakh jobs", "score": "1"}
      ]
    },
    {
      "question":
          "How much financial assistance is going to be given to the farmers every year through the ‘Annadhatha’ scheme in the 'Bhavishyathu ki Guarantee' announced by the TDP?",
      "options": [
        {"text": "Rs.10,000", "score": "0"},
        {"text": "Rs.7,000", "score": "0"},
        {"text": "Rs.3,000", "score": "0"},
        {"text": "Rs.20,000", "score": "1"}
      ]
    },
    {
      "question":
          "How many gas cylinders are going to be given free per year through the 'Deepam' scheme of 'Bhavishyathu ki Guarantee'' announced by TDP?",
      "options": [
        {"text": "2", "score": "0"},
        {"text": "1", "score": "0"},
        {"text": "0", "score": "0"},
        {"text": "3", "score": "1"}
      ]
    },
    {
      "question":
          "How much financial assistance is going to be given to women per month through the 'Aada-Bidda Nidhi' scheme in the 'Bhavishyathu ki Guarantee'' announced by TDP?",
      "options": [
        {"text": " Rs.1,000", "score": "0"},
        {"text": "Rs.800", "score": "0"},
        {"text": "Rs.1,500", "score": "1"},
        {"text": "Rs.900", "score": "0"}
      ]
    },
    {
      "question":
          "What is the name of the scheme to provide drinking water to every house in the Bhavishyathu ki Guarantee'announced by TDP?",
      "options": [
        {"text": "Drinking water scheme", "score": "0"},
        {"text": "Drinking Water for every Household", "score": "1"},
        {"text": "Water for every Village", "score": "0"},
        {"text": "Our house.. our water", "score": "0"}
      ]
    }
  ];
  bool showQuestions = false;
  bool changeQuestion = false;
  var _questionIndex = -1;
  var _totalScore = 0;

  void resetQuiz(bool val) {
    if (true) {
      setState(() {
        _questionIndex = -1;
        showQuestions = true;
        changeQuestion =true;
        _totalScore = 0;
      });
    }
  }

  void _answerQuestion(int score) {
    if (score != null) {
      setState(() {
        changeQuestion = true;

        _totalScore += score;
      });
    } else {
      setState(() {
        changeQuestion = false;
      });
    }
  }

  nxtFun() {
  //  print("object0$changeQuestion$_questionIndex");
    if(changeQuestion){
    if (_questionIndex < questions.length) {
      
     // print("object$changeQuestion");
      setState(() {
        _questionIndex = _questionIndex + 1;
        selectedIndex=-1;
        changeQuestion =false;
      });
    } else if (_questionIndex == questions.length) {
      // ignore: avoid_print
     // print("object$changeQuestion");
      setState(() {
        selectedIndex =-1;
        _questionIndex = -1;
        changeQuestion =true;
        showQuestions = false;
      });
      AppConstants.showSnackBar(context, "Thanks For taking the Quiz!!");
    } else {
      setState(() {
     //   print("object2$changeQuestion");
     selectedIndex =-1;
        _questionIndex = -1;
      });
    }
    }else{
      if(_questionIndex==8){
        
          setState(() {
            _questionIndex=-1;
            selectedIndex =-1;
            showQuestions=false;
          });
         AppConstants.showSnackBar(context, "Thanks For taking the Quiz!!");
      }else {
        AppConstants.showSnackBar(context, "Please select your answer");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height < 500 ? widget.height : size.height,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: quizQuestions(size)),
                    logoCard(context, size)
                  ],
                ),
                copyRight(size),
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
      height: size.height * 0.1,
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
                fontSize: size.width < 450 ? 12 : 18,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          const Spacer(),
          Text(
            "Follow us on:",
            style: GoogleFonts.poppins(
                fontSize: size.width < 450 ? 12 : 18,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          socialMediaBtn(size)
        ],
      ),
    );
  }


  questionsList(Size size){
    return _questionIndex < questions.length
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // questionTag("1", quest[0], size)
              questionTags("${_questionIndex + 1}",
                  questions[_questionIndex]['question'].toString(), size),

              // Align(
              //     alignment: Alignment.topLeft,
              //     child: Answer((score) {
              //       answerQuestion(score);
              //     },
              //         questions[_questionIndex]['options']
              //             as List<Map<String, Object>>))
              optionsSelection(questions[_questionIndex]['options']
                           as List<Map<String, Object>>)
            ],
          )
        : Result(_totalScore, resetQuiz);
  }


  questionTags(String qNo, String quest, Size size) {
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
        if (size.width < 550) const Spacer(),
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
        const Spacer()
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
               setState(() {
                  _answerQuestion(int.parse(options[index]['score']));
                // print("Cliked Button");
                selectedIndex = index;
               });
              },
              child: Padding(
                padding: AppConstants.all_5,
                child: Container(
                  padding: AppConstants.all_10,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration:  BoxDecoration(
                      color:selectedIndex ==index?Colors.lightGreenAccent[700]:AppConstants.appYellowBG,
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




  addQuestions(Size size) {
    return Padding(
      padding: AppConstants.leftRight_10,
      child: Column(
        children: [
          questionsList(size),
          if (_questionIndex != 8)
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: nxtFun,
                child: startBtn(size, "Next"),
              ),
            ),
          if (_questionIndex == 8)
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: nxtFun,
                child: startBtn(size, "Reset Quiz"),
              ),
            )
        ],
      ),
    );
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
        if (size.width < 550) const Spacer(),
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
        const Spacer()
      ],
    );
  }

  socialMediaBtn(Size size) {
    return SizedBox(
      height: size.width < 450 ? 25 : 35,
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
        height: widget.height * 0.90,
        width: size.width,
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
            if (!showQuestions && _questionIndex == -1)
              questionnaireInstruction(size),
            if (showQuestions && _questionIndex != -1) addQuestions(size),
            AppConstants.h_10
          ],
        ));
  }

  questionnaireInstruction(Size size) {
    return Container(
      padding: AppConstants.leftRight_20,
      color: Colors.white,
      width: size.width,
      height: size.height > 446 ? size.height * 0.55 : size.height * 0.42,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instructions",
            style: GoogleFonts.poppins(
                color: AppConstants.appredColor,
                fontWeight: FontWeight.w700,
                fontSize: size.width < 830 ? 14 : 40),
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
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: size.width < 830 ? 12 : 16),
          ),
          Text(
            '''Click on the "Next" button to move to the next question. Once you have completed all the questions, click on the "Submit" button to view your score.''',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: size.width < 830 ? 12 : 16),
          ),
          AppConstants.h_20,
          InkWell(
            onTap: () {
              setState(() {
                //  print(questions.length);
                _questionIndex = 0;
                //  print(_questionIndex);
                showQuestions = true;
              });
            },
            child: startBtn(size, "Start"),
          )
        ],
      ),
    );
  }

  startBtn(Size size, String title) {
    return Container(
      width: size.width * 0.17,
      height: widget.height * 0.04,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: AppConstants.appredColor),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
              color: AppConstants.appYellowBG,
              fontSize: size.width < 450 ? 15 : 16,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  logoCard(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.35,
      height: widget.height * 0.90,
      color: AppConstants.appYellowBG,
      padding: AppConstants.all_20,
      child: Image.asset(
        "assets/images/ic_new_logo.png",
      ),
    );
  }
}
