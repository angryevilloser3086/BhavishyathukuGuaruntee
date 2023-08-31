
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/details_provider.dart';
import '../../utils/app_localization.dart';
import '../../utils/app_utils.dart';

class ValidationScreen extends StatelessWidget {
  const ValidationScreen({super.key});
   static const String route = '/validate';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>DetailsProvider(),
      child: Scaffold(
        backgroundColor: AppConstants.appYellowBG,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppConstants.h_10,
              Align(
                alignment: Alignment.center,
                child: mobNumCard(context),
              )
            ],
          ),
        )),
      ),
    );
  }

  mobNumCard(BuildContext context) {
    return Container(
      width: 350,
      height: 550,
      decoration:const BoxDecoration(
          color: AppConstants.appBgColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: AppConstants.all_20,
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/BG-Logo-small 1.png"),
               Text(
              Strings.of(context).mNumberReq,
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            ),
            AppConstants.h_5,
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: AppConstants.all_5,
              child: Consumer<DetailsProvider>(
                  builder: (context, loginProvider, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: InkWell(
                        onTap: () async {
                          loginProvider.showCCPicker(context);
                        },
                        child: Consumer<DetailsProvider>(
                          builder: (context, value, Widget? child) {
                            return Text(Strings.of(context).cc(value.cc),
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black));
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          controller: loginProvider.phoneTextController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: AppConstants.toAppInputDecoration2(
                              context, "Enter number", ''),
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          // onFieldSubmitted: (value) =>
                          //     registrationProvider.verifyPhone(context, value),
                          // onEditingComplete: () {
                          //   registrationProvider.verifyPhone(context,
                          //       registrationProvider.phoneTextController.text);
                          // },
                          maxLength: 10,
                          validator: (value) =>
                              value!.trim().isEmpty ? 'phone number required' : null,
                        ),
                      ),
                    ),
                  
                  ],
                );
              }),
            ),
            AppConstants.h_5,
             Consumer<DetailsProvider>(
               builder: (context,provider,child) {
                 return InkWell(
                      onTap: () {
                       provider.getDetails(context, provider.phoneTextController.text);
                      },
                      child: btn());
               }
             ),
            ],
          ),
        ),
      ),
    );
  }
   btn() {
    return Container(
      width: 150,
      height: 50,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: const Center(child: Text("validate")),
    );
  }

}
