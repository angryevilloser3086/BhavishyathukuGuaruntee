import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/app_localization.dart';
import '../../utils/app_utils.dart';
import '../../provider/registration_provider.dart';

class RegistratioScreen extends StatelessWidget {
  static const String route = '/register';
  final String? mob;
  const RegistratioScreen({super.key,this.mob});

  @override
  Widget build(BuildContext context) {
    //print("Come Back::Register Page");
    return ChangeNotifierProvider(
      create: (context) => RegistrationProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.yellow[700],
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: AppConstants.all_10,
            child: Consumer<RegistrationProvider>(
                builder: (context, registrationProvider, child) {
                  
              return Form(
                key: registrationProvider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          "assets/images/header-website.png1_.png",
                          fit: BoxFit.contain,
                        )),
                    Text(Strings.of(context).registration,
                        style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                        textAlign: TextAlign.right),
                    AppConstants.h_20,
                    fNamefield1(context, registrationProvider),
                    AppConstants.h_5,
                    fatherNamefield(context, registrationProvider),
                    AppConstants.h_5,
                    genderSet(context, registrationProvider),
                    AppConstants.h_5,
                    ageField(context, registrationProvider),
                    AppConstants.h_5,
                    selectDistrict(context, registrationProvider),
                    AppConstants.h_5,
                    selectConstituency(context, registrationProvider),
                    AppConstants.h_5,

                    selectMandal(context, registrationProvider),
                    AppConstants.h_5,
                    addrfield1(context, registrationProvider),
                    AppConstants.h_5,
                    pinfield1(context, registrationProvider),
                    AppConstants.h_5,
                    // demands(context, registrationProvider),
                    // vNum(context, registrationProvider),
                    selectTotFam(context, registrationProvider),
                    AppConstants.h_5,
                    selectTotFarmers(context, registrationProvider),
                    AppConstants.h_5,
                    selectLadiesAbv18(context, registrationProvider),
                    AppConstants.h_5,
                    selectStudents(context, registrationProvider),
                    AppConstants.h_5,
                    selectUnEmployedYouth(context, registrationProvider),
                    AppConstants.h_5,

                    AppConstants.h_10,
                    didTDPContact(context, registrationProvider),
                    if (registrationProvider.selectedRadio == 2)
                      regisertForSelf(context, registrationProvider),
                    // if (registrationProvider.selectedURadio == 2 ||
                    //     registrationProvider.selectedRadio == 1)
                    //   uniqueID(context, registrationProvider),
                    verifyNumber(context, registrationProvider),
                  ],
                ),
              );
            }),
          ),
        )),
      ),
    );
  }

  genderSet(BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).gender,
          style: GoogleFonts.inter(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 150,
              child: ListTileTheme(
                minLeadingWidth: 0,
                minVerticalPadding: 0,
                horizontalTitleGap: 5,
                child: RadioListTile<int>(
                  contentPadding: AppConstants.leftRight_5,
                  value: 1,
                  groupValue: registrationProvider.selectedGRadio,
                  activeColor: Colors.black,
                  onChanged: (int? val) {
                    registrationProvider.setGender(val!);
                  },
                  title: Text(
                    Strings.of(context).male,
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ListTileTheme(
                minLeadingWidth: 0,
                horizontalTitleGap: 5,
                child: RadioListTile<int>(
                  contentPadding: AppConstants.leftRight_5,
                  value: 2,
                  groupValue: registrationProvider.selectedGRadio,
                  activeColor: Colors.black,
                  onChanged: (int? val) {
                    registrationProvider.setGender(val!);
                  },
                  title: Text(Strings.of(context).female,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ListTileTheme(
                minLeadingWidth: 0,
                horizontalTitleGap: 5,
                child: RadioListTile<int>(
                  contentPadding: AppConstants.leftRight_5,
                  value: 3,
                  groupValue: registrationProvider.selectedGRadio,
                  activeColor: Colors.black,
                  onChanged: (int? val) {
                    registrationProvider.setGender(val!);
                  },
                  title: Text(Strings.of(context).others,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  didTDPContact(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(Strings.of(context).tdpReachOut,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
        ),
        Row(
          children: [
            SizedBox(
              width: 150,
              child: ListTileTheme(
                minVerticalPadding: 0,
                horizontalTitleGap: 5,
                child: RadioListTile<int>(
                  contentPadding: AppConstants.leftRight_5,
                  value: 1,

                  //overlayColor: MaterialStateProperty.resolveWith(getColor),
                  groupValue: registrationProvider.selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (int? val) {
                    registrationProvider.setSelectedRadio(val);
                  },
                  title: Text(
                    Strings.of(context).yes,
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 5,
                child: RadioListTile<int>(
                  contentPadding: AppConstants.leftRight_5,
                  value: 2,
                  groupValue: registrationProvider.selectedRadio,
                  activeColor: Colors.black,
                  onChanged: (int? val) {
                    registrationProvider.setSelectedRadio(val);
                  },
                  title: Text(Strings.of(context).no,
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
        if (registrationProvider.selectedRadio == 1)
          ifYesMent(context, registrationProvider)
      ],
    );
  }

  regisertForSelf(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(Strings.of(context).registerForSelf,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
        ),
        Row(
          children: [
            SizedBox(
              width: 150,
              child: ListTileTheme(
                minVerticalPadding: 0,
                horizontalTitleGap: 5,
                child: RadioListTile<int>(
                  contentPadding: AppConstants.leftRight_5,
                  value: 1,

                  //overlayColor: MaterialStateProperty.resolveWith(getColor),
                  groupValue: registrationProvider.selectedURadio,
                  activeColor: Colors.black,
                  onChanged: (int? val) {
                    registrationProvider.setSelectedUniqueRadio(val);
                  },
                  title: Text(
                    Strings.of(context).yes,
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ListTileTheme(
                horizontalTitleGap: 5,
                child: RadioListTile<int>(
                  contentPadding: AppConstants.leftRight_5,
                  value: 2,
                  groupValue: registrationProvider.selectedURadio,
                  activeColor: Colors.black,
                  onChanged: (int? val) {
                    registrationProvider.setSelectedUniqueRadio(val);
                  },
                  title: Text(Strings.of(context).no,
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ifYesMent(BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            Strings.of(context).ifYes,
            style: GoogleFonts.inter(color: Colors.black, fontSize: 16),
          ),
        ),
        vNameField(context, registrationProvider),
        vNumberField(context, registrationProvider)
      ],
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.disabled,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.black;
    }
    return const Color.fromRGBO(0, 0, 0, 0);
  }

  // demands(BuildContext context, RegistrationProvider registrationProvider) {
  //   return Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           Strings.of(context).demands,
  //           textAlign: TextAlign.start,
  //           style: GoogleFonts.inter(
  //               fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
  //         ),
  //         ListView(
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             children: registrationProvider.options.map((e) {
  //               return CheckboxListTile(
  //                 checkColor: Colors.black,
  //                 value: e.checked,
  //                 onChanged: (value) =>
  //                     registrationProvider.setValueChecked(value, e),
  //                 title: Text(e.title!,
  //                     style: Theme.of(context).textTheme.headlineLarge),
  //               );
  //             }).toList())
  //       ]);
  // }

  vNum(BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).mobileNum,
          textAlign: TextAlign.start,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_5,
        TextFormField(
          controller: registrationProvider.vNumController,
          keyboardType: TextInputType.emailAddress,
          decoration: AppConstants.toAppInputDecoration2(
              context, "Enter volunteer number", ''),
          style: GoogleFonts.exo2(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          validator: (value) =>
              value!.trim().isEmpty ? 'phone number required' : null,
        ),
      ],
    );
  }

  verifyNumber(
      BuildContext context, RegistrationProvider registrationProvider) {
        if(mob!=null&&mob!.isNotEmpty){
                    if(registrationProvider.phoneTextController.text.isEmpty){
                    registrationProvider.setmobNum(mob!);
                  }
                  }
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
          child: Consumer<RegistrationProvider>(
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
                    child: Consumer<RegistrationProvider>(
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
                      controller: registrationProvider.phoneTextController,
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
        
        
        if (!registrationProvider.enableOTPtext)
          getOtpBtn(context, registrationProvider),
        AppConstants.h_5,
        if (registrationProvider.enableOTPtext &&
            !registrationProvider.showSubmit)
          TextFormField(
            controller: registrationProvider.otpTextController,
            keyboardType: TextInputType.number,
            decoration:
                AppConstants.toAppInputDecoration2(context, "Enter UID", ''),
            style: GoogleFonts.exo2(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            // onFieldSubmitted: (value) =>
            //     registrationProvider.verifyPhone(context, value),
            // onEditingComplete: () {
            //   registrationProvider.verifyPhone(
            //       context, registrationProvider.otpTextController.text);
            // },
            maxLength: 8,
            validator: (value) =>
                value!.trim().isEmpty ? 'Please Enter valid UID' : null,
          ),
        
        if (registrationProvider.enableOTPtext &&
            !registrationProvider.showSubmit)
            resendOption(),
          AppConstants.h_10,
        if (registrationProvider.enableOTPtext &&
            !registrationProvider.showSubmit)
          Align(
            alignment: Alignment.center,
            child: InkWell(
                onTap: () {
                 if(registrationProvider.otpTextController.text.isNotEmpty){
                   registrationProvider.otpVerify(
                      context);
                 }else{
                  AppConstants.showSnackBar(context, "Please enter the UID");
                 }
                 
                  //AppConstants.moveNextClearAll(context, const HomeScreen());
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Center(
                        child: registrationProvider.showLoader
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Text(
                                Strings.of(context).verifyCode.substring(0, 11),
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )))),
          ),
        if (registrationProvider.showSubmit)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    registrationProvider.registerUser(context);
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
          )
      ],
    );
  }

  resendOption() {
    return Consumer<RegistrationProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppConstants.w_40,
          Text(
            "${provider.minutes}:${provider.seconds}",
            style: GoogleFonts.poppins(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          if (provider.second == 0)
           InkWell(onTap: (){
            provider.verifyPhone(context,
                  "${provider.cc}${provider.phoneTextController.text}");
           },child:  resendButton(MediaQuery.of(context).size, "Regenerate UID"),),
            
        ],
      );
    });
  }

  resendButton(Size size, String title) {
    return Container(
        width: 100,
        height: 50,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: AppConstants.appredColor),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
                color: AppConstants.appYellowBG,
                fontSize: size.width < 450 ? 12 : 16,
                fontWeight: FontWeight.w500),
          ),
        ),
      );
  }

  getOtpBtn(BuildContext context, RegistrationProvider registrationProvider) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
          onTap: () {
            //registrationProvider.registerUser(context);
            //registrationProvider.sendToPdf(context);
            if (registrationProvider.phoneTextController.text.length == 10) {
              registrationProvider.verifyPhone(context,
                  "${registrationProvider.cc}${registrationProvider.phoneTextController.text}");
            } else {
              AppConstants.showSnackBar(context, "please enter valid Number");
            }
          },
          child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Center(
                  child: registrationProvider.showLoaderOTP
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : Text(
                          Strings.of(context).getOtp,
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )))),
    );
  }

  fNamefield1(BuildContext context, RegistrationProvider registrationProvider) {
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
            controller: registrationProvider.name,
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

  fatherNamefield(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).father,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: registrationProvider.fatherNamefield,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the Father/ husband Name';
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
                hintText: "Father/ husband Name",
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
            maxLength: 50,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            //controller: addNewPeople.fnameController,
          ),
        ),
      ],
    );
  }

  vNumberField(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).mobileNum,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: registrationProvider.vNumController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the number';
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
                hintText: "Volunteer number",
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

            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //controller: addNewPeople.fnameController,
          ),
        ),
      ],
    );
  }

  vNameField(BuildContext context, RegistrationProvider registrationProvider) {
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
            controller: registrationProvider.vName,
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
                hintText: "Volunteer name",
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
            maxLength: 100,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            //controller: addNewPeople.fnameController,
          ),
        ),
      ],
    );
  }

  ageField(BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).age,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: registrationProvider.age,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the Age';
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
                hintText: "Age",
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
            keyboardType: TextInputType.number,
            maxLength: 3,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //controller: addNewPeople.fnameController,
          ),
        ),
      ],
    );
  }

  selectConstituency(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).constitution,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_10,
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: AppConstants.boxBorderDecoration2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Colors.white,
                borderRadius: AppConstants.boxRadius8,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                value: registrationProvider.selectedConstituency.isEmpty
                    ? registrationProvider
                        .sendList(registrationProvider.sDistrcts)
                        .first
                    : registrationProvider.selectedConstituency,
                items: registrationProvider
                        .sendList(registrationProvider.sDistrcts)
                        .isEmpty
                    ? ['Please select your District']
                        .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: AppConstants.all_10,
                            child: Text(value,
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)),
                          ),
                        );
                      }).toList()
                    : registrationProvider
                        .sendList(registrationProvider.sDistrcts)
                        .map<DropdownMenuItem<String>>((String constituency) {
                        return DropdownMenuItem<String>(
                          value: constituency,
                          child: Padding(
                            padding: AppConstants.all_10,
                            child: Text(constituency,
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)),
                          ),
                        );
                      }).toList(),
                onChanged: (value) =>
                    registrationProvider.setRoles(value.toString())),
          ),
        ),
      ],
    );
  }

  selectDistrict(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).district,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_10,
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: AppConstants.boxBorderDecoration2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Colors.white,
                borderRadius: AppConstants.boxRadius8,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                value: registrationProvider.sDistrcts.isEmpty
                    ? registrationProvider.districts.first
                    : registrationProvider.sDistrcts,
                items: registrationProvider.districts
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: AppConstants.all_10,
                      child: Text(value,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    registrationProvider.setdistritcs(value.toString())),
          ),
        ),
      ],
    );
  }

  selectMandal(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).mandal,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_10,
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: AppConstants.boxBorderDecoration2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Colors.white,
                borderRadius: AppConstants.boxRadius8,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                value: registrationProvider.sMandals.isEmpty
                    ? registrationProvider
                        .sendMandalList(
                            registrationProvider.selectedConstituency)
                        .first
                    : registrationProvider.sMandals,
                items: registrationProvider
                        .sendMandalList(
                            registrationProvider.selectedConstituency)
                        .isEmpty
                    ? ['Please select your Assembly Constituency']
                        .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: AppConstants.all_10,
                            child: Text(value,
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)),
                          ),
                        );
                      }).toList()
                    : registrationProvider
                        .sendMandalList(
                            registrationProvider.selectedConstituency)
                        .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: AppConstants.all_10,
                            child: Text(value,
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)),
                          ),
                        );
                      }).toList(),
                onChanged: (value) =>
                    registrationProvider.setMandals(value.toString())),
          ),
        ),
      ],
    );
  }

  selectTotFam(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).totalFam,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_10,
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: AppConstants.boxBorderDecoration2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Colors.white,
                borderRadius: AppConstants.boxRadius8,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                value: registrationProvider.famMembers == 0
                    ? registrationProvider.famMem.first
                    : registrationProvider.famMembers,
                items: registrationProvider.famMem
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Padding(
                      padding: AppConstants.all_10,
                      child: Text("$value",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    registrationProvider.setFamMembers(value!)),
          ),
        ),
      ],
    );
  }

  selectTotFarmers(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).framers,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_10,
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: AppConstants.boxBorderDecoration2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Colors.white,
                borderRadius: AppConstants.boxRadius8,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                value: registrationProvider.farmers == 0
                    ? registrationProvider.farmersNum(registrationProvider.famMembers).first
                    : registrationProvider.farmers,
                items: registrationProvider.farmersNum(registrationProvider.famMembers)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Padding(
                      padding: AppConstants.all_10,
                      child: Text("$value",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    registrationProvider.setFarmers(context, value!)),
          ),
        ),
        if (registrationProvider.farmers > 0)
          ...registrationProvider.farmersFields
      ],
    );
  }

  selectLadiesAbv18(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).womenAbv,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_10,
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: AppConstants.boxBorderDecoration2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Colors.white,
                borderRadius: AppConstants.boxRadius8,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                value: registrationProvider.womenAbv == 0
                    ? registrationProvider.famMem.first
                    : registrationProvider.womenAbv,
                items: registrationProvider.famMem
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Padding(
                      padding: AppConstants.all_10,
                      child: Text("$value",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    registrationProvider.setNoOFWomen(context, value!)),
          ),
        ),
        if (registrationProvider.womenAbv > 0)
          ...registrationProvider.womenFields
      ],
    );
  }

  selectStudents(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).students,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_10,
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: AppConstants.boxBorderDecoration2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Colors.white,
                borderRadius: AppConstants.boxRadius8,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                value: registrationProvider.students == 0
                    ? registrationProvider.famMem.first
                    : registrationProvider.students,
                items: registrationProvider.famMem
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Padding(
                      padding: AppConstants.all_10,
                      child: Text("$value",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    registrationProvider.setStudents(context, value!)),
          ),
        ),
        if (registrationProvider.students > 0)
          ...registrationProvider.studentFields
      ],
    );
  }

  selectUnEmployedYouth(
      BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).unEmployeed,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_10,
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: AppConstants.boxBorderDecoration2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Colors.white,
                borderRadius: AppConstants.boxRadius8,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                value: registrationProvider.unEMployedYouth == 0
                    ? registrationProvider.famMem.first
                    : registrationProvider.unEMployedYouth,
                items: registrationProvider.famMem
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Padding(
                      padding: AppConstants.all_10,
                      child: Text("$value",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    registrationProvider.setunEMployed(context, value!)),
          ),
        ),
        if (registrationProvider.unEMployedYouth > 0)
          ...registrationProvider.uEmpYouthFields
      ],
    );
  }

  addrfield1(BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).address,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: registrationProvider.address,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the Address';
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
                hintText: "Address",
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

            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            //controller: addNewPeople.fnameController,
          ),
        ),
      ],
    );
  }

  pinfield1(BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.of(context).pinCode,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: registrationProvider.pincode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the PinCode';
              } else if (value.trim().length < 6) {
                return 'Please enter the valid PinCode';
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
                hintText: "Pin Code",
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

            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            //controller: addNewPeople.fnameController,
          ),
        ),
      ],
    );
  }

  uniqueID(BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scan QR for Unique ID",
          textAlign: TextAlign.start,
          style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        AppConstants.h_5,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                  controller: registrationProvider.uniqueCode,
                  keyboardType: TextInputType.number,
                  decoration: AppConstants.toAppInputDecoration2(
                      context, "Scan For Unique ID", ''),
                  style: GoogleFonts.exo2(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLength: 12,
                  validator: (value) {
                    if (value!.trim().isEmpty || value.trim().length < 6) {
                      return 'Unique number required';
                    } else {
                      return null;
                    }
                  }),
            ),
            AppConstants.w_10,
            InkWell(
              //onTap: () => registrationProvider.setQRValues(context),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width < 510 ? 50 : 100,
                  height: MediaQuery.of(context).size.width < 510 ? 120 : 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset("assets/images/ic_qr.png")),
                      Text(
                        "Click Here to Scan!!",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                      AppConstants.h_10
                    ],
                  )),
            ),
            const Spacer()
          ],
        ),
      ],
    );
  }
}
