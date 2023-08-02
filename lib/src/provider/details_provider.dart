import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vregistration/src/model/reg_model.dart';

class DetailsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RegistrationModel? userDetails;
  RegistrationModel? get userD => userDetails;

  set userD(RegistrationModel? registrationModel) {
    userDetails = registrationModel;
  }

  getDetails(String id) {
    print("called this method:$id");
    _db.collection('users').where("id", isEqualTo: id).get().then((value) {
      QuerySnapshot data = value;
      log("enter firestore db: ${data.docs.first.get("id")}");
      log("enter firestore db: ${data.docs.first.get("name")}");
      log("enter firestore db: ${data.docs.first.get("age")}");
      log("enter firestore db: ${data.docs.first.get("constituency")}");
      log("enter firestore db: ${data.docs.first.get("district")}");
      log("enter firestore db: ${data.docs.first.get("mandal")}");
      log("enter firestore db: ${data.docs.first.get("address")}");
      log("enter firestore db: ${data.docs.first.get("gender")}");
      log("enter firestore db: ${data.docs.first.get("pincode")}");
      log("enter firestore db: ${data.docs.first.get("date")}");
      log("enter firestore db: ${data.docs.first.get("phone")}");
      log("enter firestore db: ${data.docs.first.get("isVerified")}");
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
      throw Exception(err);
    });
  }
}
