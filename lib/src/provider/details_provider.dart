import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vregistration/src/model/reg_model.dart';
import 'package:vregistration/src/utils/app_utils.dart';
import 'package:vregistration/src/view/home_screen.dart';

class DetailsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RegistrationModel? userDetails;
  RegistrationModel? get userD => userDetails;

  set userD(RegistrationModel? registrationModel) {
    userDetails = registrationModel;
  }

  getDetails(BuildContext context,String id) {
    print("called this method:$id");
    _db.collection('users').where("id", isEqualTo: id).get().then((value) {
      QuerySnapshot data = value;
      log("enter firestore db: ${data.docs.first.get("id")}");
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
            totalWomen: data.docs.first.get('total_women'));
        log("${userDetails!.toJSON()}");
        notifyListeners();
      }
    }).catchError((err) {
      AppConstants.moveNextClearAll(context, const HomeScreen());
      throw Exception(err);
    });
  }

}
