import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vregistration/src/view/registration/registration.dart';
import '../network/api_request.dart';
import '../utils/loading_indicator.dart';
import '/src/model/reg_model.dart';
import '/src/utils/app_utils.dart';
import '/src/view/home_screen.dart';

class DetailsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RegistrationModel? userDetails;
  RegistrationModel? get userD => userDetails;
  ApiRequest apiRequest = ApiRequest();
  TextEditingController phoneTextController = TextEditingController();

  String cc = "91";

  set userD(RegistrationModel? registrationModel) {
    userDetails = registrationModel;
  }

  showCCPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: AppConstants.textStyleCC,
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: AppConstants.toBorderRadiusTLR(),
        //Optional. Styles the search field.
        inputDecoration: AppConstants.toInputDecorationSearch(),
      ),
      // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        //print('Select country: ${country.displayName}');
        // print(country.countryCode);
        // print(country.phoneCode);
        setCC(country.phoneCode);
      },
    );
  }

  setCC(String c) {
    cc = c;
    notifyListeners();
  }

  getDetails(BuildContext context, String phone) {
    DialogBuilder(context)
        .showLoadingIndicator("Please wait while we are updating details ");
    _db
        .collection('users')
        .where("phone", isEqualTo: "91$phone")
        .get()
        .then((value) {
      QuerySnapshot data = value;
      Navigator.of(context, rootNavigator: true).pop();
      showAlert(context, "Error",
          "User is already registered \n with this UID: ${value.docs.first.get("id")} ");
      print("entered success block");
      if (data.size != 0) {
        userDetails = RegistrationModel(
            name: data.docs.first.get('name'),
            age: data.docs.first.get('age'),
            id: data.docs.first.get('id'),
            constituency: data.docs.first.get('constituency'),
            district: data.docs.first.get('district'),
            mandal: data.docs.first.get('mandal'),
            address: data.docs.first.get('address'),
            gender: data.docs.first.get('gender'),
            pincode: data.docs.first.get('pincode'),
            number: data.docs.first.get('phone'),
            date: data.docs.first.get('date'),
            isVerified: data.docs.first.get('isVerified'),
            scheme: data.docs.first.get('scheme'),
            totalFam: data.docs.first.get('total_fam'),
            totalFarmers: data.docs.first.get('total_farmers'),
            totalStudents: data.docs.first.get('total_students'),
            totalUnEmployedYouth: data.docs.first.get('total_unempyouth'),
            totalWomen: data.docs.first.get('total_women'),
            fatherNamefield: data.docs.first.get('fatherName'),
            pc: data.docs.first.get('pc')??"",
            zone: data.docs.first.get('zone')??"");
        log("${userDetails!.toJSON()}");
        notifyListeners();
      }
    }).catchError((err) {
      print("error block: $err");
      checkMasterDb(context);
      //throw Exception(err);
    });
  }

  checkMasterDb(BuildContext context) {
    apiRequest.validateNumMaster(phoneTextController.text).then((value) {
      Navigator.of(context, rootNavigator: true).pop();
      if (value) {
        showAlert(context, "Error",
            "User is already registered \n with this mobile number please try again with another number ");
      } else {
        AppConstants.moveNextstl(
            context,
            RegistratioScreen(
              mob: phoneTextController.text,
            ));
      }
    }).catchError((err) {
      Navigator.of(context, rootNavigator: true).pop();
      showAlert(context, "Error", "$err");
    });
  }

  showAlert(BuildContext context, String title, String msg) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.start,
            alignment: AlignmentDirectional.center,
            backgroundColor: AppConstants.appYellowBG,
            title: Text(
              title,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            content: Text(
              msg,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
                actions: [
                  Align(
                    alignment: Alignment.topRight,
                    child:  InkWell(
                    onTap: () => Navigator.pop(context),
                    child:const Icon(Icons.close,color: Colors.black,),
                  ),
                  ),
                  
                ],
          );
        });
  }
}
