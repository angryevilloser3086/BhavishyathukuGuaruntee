import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import '/src/utils/app_utils.dart';

import '../model/reg_model.dart';
import 'quiz/quiz_screen.dart';
import 'registration/validation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);
  ScrollController scrollController = ScrollController();
  int activePage = 0;
  List<String> images = [
    "assets/images/Frame_30_1.png",
    "assets/images/Desktop - 14.png",
    "assets/images/Desktop - 15.png",
    "assets/images/Desktop - 16.png",
    "assets/images/Desktop - 17.png",
    "assets/images/Desktop - 18.png"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height >
                      MediaQuery.of(context).size.height * 0.25
                  ? (MediaQuery.of(context).size.height * 0.25)
                  : MediaQuery.of(context).size.height * 0.45,
              color: Colors.redAccent[700],
              child: Center(
                child: Text(
                  ('Bhavishyathuku Guarantee').toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: (MediaQuery.of(context).size.width < 800 ||
                              MediaQuery.of(context).size.height < 400)
                          ? 30
                          : 70,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            AppConstants.h_5,

            InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ValidationScreen.route);
                },
                child: btn()),

            CarouselSlider(
              items: [
                SizedBox(
                    width: w,
                    child: Image.asset(
                      images[0],
                      fit: BoxFit.contain,
                    )),
                Image.asset(
                  images[1],
                  fit: BoxFit.contain,
                ),
                Image.asset(
                  images[2],
                  fit: BoxFit.contain,
                ),
                Image.asset(
                  images[3],
                  fit: BoxFit.contain,
                ),
                Image.asset(
                  images[4],
                  fit: BoxFit.contain,
                ),
                Image.asset(
                  images[5],
                  fit: BoxFit.contain,
                ),
              ],
              options: CarouselOptions(
                height: w < 750 ? 200 : h,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: w,
                autoPlayCurve: Curves.bounceOut,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 250),
                //viewportFraction: 0.8,
              ),
            ),

            // const SizedBox.expand(child: TestimonialVideo(),),
            // SizedBox(
            //   width: w,
            //   height: h,
            //   child: TestimonialVideo(
            //     height:  h,
            //   ),
            // ),
            SizedBox(
                width: w,
                child: Image.asset(
                  "assets/images/header-website.png1_.png",
                  fit: BoxFit.contain,
                )),

            SizedBox(
                width: w,
                height: h < 450 ? h * 2 : h,
                child: QuizScreen(
                  height: h < 450 ? h * 2 : h,
                )),
            InkWell(
              onTap: () {
                setState(() {
                  downloadData();
                });
              },
              child: btnDownload(),
            ),
          ],
        ),
      )),
    );
  }


  btn() {
    return Container(
      width: 150,
      height: 50,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: const Center(child: Text("Register")),
    );
  }

  btnDownload() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 50,
        decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: const Center(child: Text("Download")),
      ),
    );
  }

  downloadData() {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    List<RegistrationModel> users = [];

    _db.collection('users').get().then((value) {
      QuerySnapshot data = value;
      // print(data.docs.first);
      for (QueryDocumentSnapshot snapshot in data.docs) {
        RegistrationModel user = RegistrationModel(
            name: snapshot.get('name'),
            age: snapshot.get('age'),
            constituency: snapshot.get('constituency'),
            district: snapshot.get('district'),
            mandal: snapshot.get('mandal'),
            address: snapshot.get('address'),
            gender: snapshot.get('gender'),
            pincode: snapshot.get('pincode'),
            number: snapshot.get('phone'),
            vName: snapshot.get('volunteer_name'),
            vNum: snapshot.get('volunteer_number'),
            isVerified: snapshot.get('isVerified'),
            date: snapshot.get('date') ?? "",
            id: snapshot.get("id"),
            scheme: snapshot.get('scheme'),
            totalFam: snapshot.get('total_fam'),
            totalFarmers: snapshot.get('total_farmers'),
            totalStudents: snapshot.get('total_students'),
            totalUnEmployedYouth: snapshot.get('total_unempyouth'),
            totalWomen: snapshot.get('total_women'),
            fatherNamefield: snapshot.get('fatherName'),
            pc: "",
            zone:""
            );

        setState(() {
          users.add(user);
        });
      }
      convertJSONToExcel(users);
    }).catchError((err) {
      print(err);
    });
  }

  void convertJSONToExcel(List<dynamic> jsonData) {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    // Write headers (optional) - Assuming jsonData is a list of Maps with identical keys
    // var headers = jsonData[0].toList();
    List<String> headers = [
      'UID',
      'name',
      'age',
      'gender',
      "phone",
      'district',
      "constituency",
      'mandal',
      'address',
      'pincode',
      'volunteer_number',
      'volunteer_name',
      'date',
      "isVerified",
      "total family members",
      "total farmers",
      "total students",
      "total women",
      "total Unemployed youth",
      "schemes",
      "pc",
      "zone"
    ];
    for (var i = 0; i < headers.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i))
          .value = headers[i];
    }

    // Write data
    for (var i = 0; i < jsonData.length; i++) {
      RegistrationModel row = jsonData[i];
      //var values = row;
      List<String> val = [];
      val.add(row.id!);
      val.add(row.name!);
      val.add(row.age!);
      val.add(row.gender!);
      val.add(row.number!);
      val.add(row.district!);
      val.add(row.constituency!);
      val.add(row.mandal!);
      val.add(row.address!);
      val.add(row.pincode!);
      val.add(row.vName!);
      val.add(row.vNum!);
      val.add(row.date!);
      val.add(row.isVerified.toString());
      val.add(row.totalFam.toString());
      val.add(row.totalFarmers.toString());
      val.add(row.totalStudents.toString());
      val.add(row.totalWomen.toString());
      val.add(row.totalUnEmployedYouth.toString());
      val.add(row.scheme.toString());
      val.add(row.pc.toString());
      val.add(row.zone.toString());
      log("${val.toList()}");

      for (var j = 0; j < val.length; j++) {
        log("calledhere");
        setState(() {
          sheet
              .cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: j))
              .value = val[j];
        });
      }
    }
    DateTime dt = DateTime.now();
    setState(() {
      var fileBytes = excel.save(fileName: 'details$dt.xlsx');
      log("${fileBytes!.toList()}");
    });

  }
}
