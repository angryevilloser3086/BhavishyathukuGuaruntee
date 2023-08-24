import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../src/utils/app_utils.dart';
import '../../src/utils/shared_pref.dart';

import '../provider/welcome_details.dart';
import '../utils/app_localization.dart';

class VolunteerDetails extends StatefulWidget {
  const VolunteerDetails({super.key});

  @override
  State<VolunteerDetails> createState() => _VolunteerDetailsState();
}

class _VolunteerDetailsState extends State<VolunteerDetails> {
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WelcomeDetailsProvider(),
      child: Scaffold(
        backgroundColor: AppConstants.appYellowBG,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: AppConstants.all_10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Spacer(),

                AppConstants.h_40,

                Padding(
                  padding: AppConstants.all_10,
                  child: Image.asset("assets/images/BG-Logo-small 1.png"),
                ),
                Consumer<WelcomeDetailsProvider>(builder: (_, provider, child) {
                  return fNamefield1(context, provider);
                }),
                AppConstants.h_10,
                verifyNumber(
                  context,
                ),
                //Spacer()
              ],
            ),
          ),
        )),
      ),
    );
  }

  fNamefield1(BuildContext context, WelcomeDetailsProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).name,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: provider.name,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the Name';
              }
              return null;
            },
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
              //addNewPeople.formKey.currentState!.validate();
            },
            textAlign: TextAlign.justify,
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            decoration: InputDecoration(
                // contentPadding: AppConstants.all_5,
                fillColor: Colors.white,
                filled: true,
                counterStyle: Theme.of(context).textTheme.bodySmall,
                counterText: "",
                hintText: "First Name",
                errorStyle: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
                hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Colors.black),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppConstants.appBgLite),
                    borderRadius: AppConstants.boxRadius8),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppConstants.appBgLite),
                    borderRadius: AppConstants.boxRadius8),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppConstants.appBgLite),
                    borderRadius: AppConstants.boxRadius8)),

            keyboardType: TextInputType.name,
            maxLength: 25,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            //controller: addNewPeople.fnameController,
          ),
        ),
      ],
    );
  }

  verifyNumber(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: Consumer<WelcomeDetailsProvider>(
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
                    child: Consumer<WelcomeDetailsProvider>(
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
                Consumer<WelcomeDetailsProvider>(
                    builder: (context, provider, child) {
                  return Expanded(
                    child: TextFormField(
                      controller: provider.number,
                      keyboardType: TextInputType.number,
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
                      validator: (value) => value!.trim().isEmpty
                          ? 'phone number required'
                          : null,
                    ),
                  );
                }),
              ],
            );
          }),
        ),
        AppConstants.h_5,
        AppConstants.h_10,
        Consumer<WelcomeDetailsProvider>(builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    provider.saveDetails(context);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Center(
                          child: Text(
                        Strings.of(context).submit,
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )))),
            ),
          );
        })
      ],
    );
  }
}
