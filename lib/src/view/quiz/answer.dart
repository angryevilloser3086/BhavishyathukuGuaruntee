import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/src/utils/app_utils.dart';

class Answer extends StatelessWidget {
  final Function(int) selectHandler;
  final List<Map<String, dynamic>> options;

  const Answer(this.selectHandler, this.options, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // use SizedBox for white space instead of Container
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                selectHandler(int.parse(options[index]['score']));
                // print("Cliked Button");
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
