import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/app_localization.dart';
import '../../utils/app_utils.dart';
import '../provider/registration_provider.dart';

class RegistratioScreen extends StatelessWidget {
  const RegistratioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegistrationProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.amber[50],
        body: SafeArea(
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<RegistrationProvider>(
                builder: (context, registrationProvider, child) {
             
              return Form(
                key:registrationProvider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Strings.of(context).registration,
                        style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                        textAlign: TextAlign.right),
                    AppConstants.h_20,
                    fNamefield1(context, registrationProvider),
                    genderSet(context, registrationProvider),
                    ageField(context, registrationProvider),
                    selectDistrict(context, registrationProvider),
                    selectConstituency(context, registrationProvider),

                    selectMandal(context, registrationProvider),
                    addrfield1(context, registrationProvider),
                    pinfield1(context, registrationProvider),
                    // demands(context, registrationProvider),
                    // vNum(context, registrationProvider),
                    AppConstants.h_10,
                    didTDPContact(context, registrationProvider),
                    verifyNumber(context, registrationProvider),
                  ],
                ),
              );
            }),
          ),
        ),
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Column(
            children: [
              ListTileTheme(
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
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListTileTheme(
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
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Column(
            children: [
              ListTileTheme(
                minVerticalPadding: 0,
                horizontalTitleGap: 5,
                child: RadioListTile<int>(
                  contentPadding: AppConstants.leftRight_5,
                  value: 1,
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
              ListTileTheme(
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
            ],
          ),
        ),
        if (registrationProvider.selectedRadio == 1)
          ifYesMent(context, registrationProvider)
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

  demands(BuildContext context, RegistrationProvider registrationProvider) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.of(context).demands,
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: registrationProvider.options.map((e) {
                return CheckboxListTile(
                  checkColor: Colors.black,
                  value: e.checked,
                  onChanged: (value) =>
                      registrationProvider.setValueChecked(value, e),
                  title: Text(e.title!,
                      style: Theme.of(context).textTheme.headlineLarge),
                );
              }).toList())
        ]);
  }

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
                  child: TextFormField(
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
              ],
            );
          }),
        ),

        AppConstants.h_5,
          if(!registrationProvider.enableOTPtext)
          getOtpBtn(context, registrationProvider),
          AppConstants.h_5,
        if (registrationProvider.enableOTPtext &&
            !registrationProvider.showSubmit)
          TextFormField(
            controller: registrationProvider.otpTextController,
            keyboardType: TextInputType.emailAddress,
            decoration:
                AppConstants.toAppInputDecoration2(context, "Enter OTP", ''),
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
            maxLength: 6,
            validator: (value) =>
                value!.trim().isEmpty ? 'phone number required' : null,
          ),
        AppConstants.h_10,
        if (registrationProvider.enableOTPtext &&
            !registrationProvider.showSubmit)
        InkWell(
            onTap: () {
              registrationProvider.otpVerify(
                  context); //AppConstants.moveNextClearAll(context, const HomeScreen());
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
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
        
        if (registrationProvider.showSubmit)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    registrationProvider.registerUser(context);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(35))),
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

  getOtpBtn(BuildContext context,RegistrationProvider registrationProvider ){
    print("${registrationProvider.phoneTextController.text.length}");
    return InkWell(
            onTap: () {
             if(registrationProvider.phoneTextController.text.length==10){
               registrationProvider.verifyPhone(context,
                          registrationProvider.phoneTextController.text);
             }else{
              AppConstants.showSnackBar(context, "please enter valid Number");
             }
               //AppConstants.moveNextClearAll(context, const HomeScreen());
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: 60,
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
                          ))));
        
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
                hintText: "Number",
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
                items:registrationProvider.sendList(registrationProvider.sDistrcts).isEmpty?['please Select the District'].map<DropdownMenuItem<String>>((String value) {
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
                }).toList() : registrationProvider
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
                    ? registrationProvider.sendMandalList(registrationProvider.selectedConstituency)
                        .first
                    : registrationProvider.sMandals,
                items:registrationProvider.sendMandalList(registrationProvider.selectedConstituency).isEmpty?['please Select the Assembly Constituency'].map<DropdownMenuItem<String>>((String value) {
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
                }).toList() :registrationProvider.sendMandalList(registrationProvider.selectedConstituency)
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
}
