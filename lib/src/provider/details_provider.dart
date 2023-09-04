
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
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
  bool enableSelector = false;
  String cc = "91";
  Uint8List? dataPdf;

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

  getDetails(BuildContext context, String phone,bool isPDF) {
    DialogBuilder(context)
        .showLoadingIndicator("Please wait while we are updating details ");
    _db
        .collection('users')
        .where("phone", isEqualTo: "91$phone")
        .get()
        .then((value) async{
      QuerySnapshot data = value;
      Navigator.of(context, rootNavigator: true).pop();
      showAlert(context, "Error",
          "User is already registered \n with this UID: ${value.docs.first.get("id")} ");
     // print("entered success block");
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
            pc: data.docs.first.get('pc') ?? "",
            zone: data.docs.first.get('zone') ?? "");
        enableSelector = true;
        if(isPDF){
          dataPdf = await makePDF(context, userDetails!);
        }
      //  log("${userDetails!.toJSON()}");
        notifyListeners();
      }
    }).catchError((err) {
      enableSelector = false;
      //print("error block: $err");
      checkMasterDb(context);
      //throw Exception(err);
    });
  }


  downloadFile(BuildContext context,Uint8List files,RegistrationModel rModel) async {
    Printing.sharePdf(bytes: files, filename: '${rModel.number}.pdf')
        .then((value) {
      AppConstants.showSnackBar(context, "Certificate downloaded Successfully");
      AppConstants.moveNextClearAll(context, const HomeScreen());
      notifyListeners();
    }).catchError((err){
      AppConstants.showSnackBar(context, "Certificate downloading failed due to $err");
      notifyListeners();
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

  Future<Uint8List> makePDF(
      BuildContext context, RegistrationModel rModel) async {
    final pdf = pw.Document();

    pdf.addPage(await createPageOne(rModel));
    pdf.addPage(await createPageTwo(rModel));
    return pdf.save();
  }

  createPageOne(RegistrationModel rModel) async {
    final ByteData bytes = await rootBundle.load('assets/images/ic_bg_1.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final ByteData header2 =
        await rootBundle.load('assets/images/ic_headline.png');
    final Uint8List header2List = header2.buffer.asUint8List();
    // final ByteData headerbB =
    //     await rootBundle.load('assets/images/ic_pdf_header.png');
    // final Uint8List hByteList = headerbB.buffer.asUint8List();
    final ByteData mahashakti =
        await rootBundle.load('assets/images/mahashakti.png');
    final Uint8List mahashaktiList = mahashakti.buffer.asUint8List();
    final ByteData i1 = await rootBundle.load('assets/images/Annadatha.png');
    final Uint8List i1List = i1.buffer.asUint8List();
    final ByteData i2 = await rootBundle.load('assets/images/Yuvagalam.png');
    final Uint8List i2List = i2.buffer.asUint8List();
    final ByteData i3 = await rootBundle.load('assets/images/BC.png');
    final Uint8List i3List = i3.buffer.asUint8List();
    final ByteData i4 = await rootBundle.load('assets/images/Water.png');
    final Uint8List i4List = i4.buffer.asUint8List();
    final ByteData i5 = await rootBundle.load('assets/images/Poor.png');
    final Uint8List i5List = i5.buffer.asUint8List();
    final ByteData i6 =
        await rootBundle.load('assets/images/ic_new_logo.png');
    final Uint8List i6List = i6.buffer.asUint8List();
    List<Uint8List> list1 = [i1List, i2List, i3List];
    List<Uint8List> list2 = [i4List, i5List, i6List];
    // print(list2[2]);
    return pw.Page(
        pageFormat: PdfPageFormat.standard.landscape,
        build: (context) {
          return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                  child: pw.Container(
                      child: pw.Column(children: [
                    pw.SizedBox(height: 10),
                    pw.Stack(children: [
                      pw.Align(
                        alignment: pw.Alignment.topCenter,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              left: 35.0, right: 35, top: 25),
                          child: pw.Image(pw.MemoryImage(header2List)),
                        ),
                      ),
                      pw.Positioned(
                        left: 320,
                        top: 90,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.SizedBox(width: 10),
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(width: 1),
                                    pw.SizedBox(
                                        width: 50,
                                        child: pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Text(
                                                "${(rModel.totalWomen * 18000 + rModel.totalFarmers * 20000 + rModel.totalStudents * 15000 + rModel.totalUnEmployedYouth * 36000) * 5}",
                                                style: const pw.TextStyle(
                                                    fontSize: 10,
                                                    color: PdfColors.black))))
                                  ]),
                              pw.SizedBox(width: 10),
                            ]),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(width: 30),
                      pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.only(
                            left: 35.0,
                          ),
                          child: pw.Image(pw.MemoryImage(mahashaktiList),
                              width: 300, height: 400),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Row(
                            children: [
                              pw.Image(pw.MemoryImage(list1[0]),
                                  width: 160, height: 200),
                              pw.SizedBox(width: 10),
                              pw.Image(pw.MemoryImage(list1[1]),
                                  width: 160, height: 200),
                              pw.SizedBox(width: 10),
                              pw.Image(pw.MemoryImage(list1[2]),
                                  width: 160, height: 200),
                              pw.SizedBox(width: 10),
                            ],
                          ),
                          pw.SizedBox(height: 10),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            mainAxisSize: pw.MainAxisSize.max,
                            children: [
                              pw.Image(pw.MemoryImage(list2[0]),
                                  width: 150, height: 200),
                              pw.SizedBox(width: 10),
                              pw.Image(pw.MemoryImage(list2[1]),
                                  width: 150, height: 200),
                              pw.SizedBox(width: 10),
                              pw.Image(pw.MemoryImage(list2[2]),
                                  width: 150, height: 200),
                              // pw.SizedBox(width: 10),
                            ],
                          )
                          // pw.SizedBox(height: 20),
                          // rowPDF2(row2)
                        ],
                      )
                    ])

                    //pw.SizedBox(height: 40)
                  ])),
                  decoration: pw.BoxDecoration(
                    image: pw.DecorationImage(
                        image: pw.MemoryImage(byteList), fit: pw.BoxFit.fill),
                    color: PdfColor.fromHex("FFFFFF"),
                  )));
        });
  }

  createPageTwo(RegistrationModel rModel) async {
    final ByteData bytes = await rootBundle.load('assets/images/ic_bg_1.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final ByteData headerbB =
        await rootBundle.load('assets/images/ic_header_2.png');
    final Uint8List hByteList = headerbB.buffer.asUint8List();
    final ByteData subHead =
        await rootBundle.load('assets/images/ic_subhead_secondCard.png');
    final Uint8List subHeadList = subHead.buffer.asUint8List();
    final ByteData grp = await rootBundle.load('assets/images/table.png');
    final Uint8List grp343 = grp.buffer.asUint8List();
    //final font = await rootBundle.load("assets/open-sans.ttf");
    final fontG = await PdfGoogleFonts.anekTeluguRegular();

    return pw.Page(
        pageFormat: PdfPageFormat.standard.landscape,
        build: (context) {
          return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                  child: pw.Container(
                      child: pw.Column(children: [
                    pw.SizedBox(height: 10),

                    pw.Align(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            left: 35.0, right: 35, top: 25),
                        child: pw.Image(pw.MemoryImage(hByteList)),
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            left: 55.0, right: 55, top: 5),
                        child: pw.Image(pw.MemoryImage(subHeadList)),
                      ),
                    ),
                    pw.Align(
                        alignment: pw.Alignment.bottomCenter,
                        child: pw.Padding(
                            padding: const pw.EdgeInsets.only(
                                left: 5.0, right: 5, top: 0, bottom: 5),
                            child: pw.Stack(children: [
                              pw.Positioned(
                                left: 590,
                                child: pw.Column(children: [
                                  pw.SizedBox(height: 20),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.totalFam}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalFarmers}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalWomen}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalStudents}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalUnEmployedYouth}",
                                        fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                ]),
                              ),
                              pw.Positioned(
                                left: 500,
                                bottom: 40,
                                child: pw.Column(children: [
                                  pw.SizedBox(height: 120),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceEvenly,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceEvenly,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2(" "),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(" "),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.SizedBox(height: 15),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceEvenly,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2(" "),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(" "),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.SizedBox(height: 25),
                                  pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      children: [
                                        pw.SizedBox(width: 10),
                                        detailText2("${rModel.totalWomen}"),
                                        pw.SizedBox(width: 10),
                                        detailText2(""),
                                        pw.SizedBox(width: 10),
                                        detailText2(
                                            "${rModel.totalWomen * 18000}"),
                                        pw.SizedBox(width: 10),
                                      ]),
                                  // pw.SizedBox(height: 15),

                                  pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      children: [
                                        pw.SizedBox(width: 10),
                                        detailText2("${rModel.totalStudents}"),
                                        pw.SizedBox(width: 10),
                                        detailText2(""),
                                        pw.SizedBox(width: 10),
                                        detailText2(
                                            "${rModel.totalStudents * 15000}"),
                                        pw.SizedBox(width: 10),
                                      ]),
                                  pw.SizedBox(height: 15),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceEvenly,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2("${rModel.totalFarmers}"),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalFarmers * 20000}"),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.SizedBox(height: 15),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalUnEmployedYouth}"),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalUnEmployedYouth * 36000}"),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.SizedBox(height: 15),
                                ]),
                              ),

                              pw.Positioned(
                                left: 600,
                                bottom: 30,
                                child: pw.Column(children: [
                                  pw.SizedBox(height: 30),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceEvenly,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalWomen * 18000 + rModel.totalFarmers * 20000 + rModel.totalStudents * 15000 + rModel.totalUnEmployedYouth * 36000}"),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceEvenly,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${(rModel.totalWomen * 18000 + rModel.totalFarmers * 20000 + rModel.totalStudents * 15000 + rModel.totalUnEmployedYouth * 36000) * 5}"),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                ]),
                              ),

                              //id
                              pw.Positioned(
                                left: 290,
                                top: 5,
                                child: pw.Container(
                                    height: 20,
                                    color: PdfColor.fromHex("FFD011"),
                                    child: pw.Row(children: [
                                      pw.Text("UNIQUE CODE:",
                                          style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColors.black)),
                                      pw.Text(
                                          "${rModel.id!.isEmpty ? 12345678 : rModel.id}",
                                          style: pw.TextStyle(
                                              fontSize: 12,
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColors.black)),
                                    ])),
                              ),
                              pw.Positioned(
                                left: 350,
                                child: pw.Column(children: [
                                  pw.SizedBox(height: 55),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.pincode}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.constituency}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.number}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                ]),
                              ),
                              pw.Positioned(
                                left: 100,
                                child: pw.Column(children: [
                                  pw.SizedBox(height: 20),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.name}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.fatherNamefield}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.age}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.address}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.district}", fontG),
                                  ),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("#######", fontG),
                                  ),
                                  pw.SizedBox(height: 20),
                                ]),
                              ),

                              pw.Align(
                                  alignment: pw.Alignment.topCenter,
                                  child: pw.Container(
                                      width: 770,
                                      height: 280,
                                      decoration: pw.BoxDecoration(
                                        image: pw.DecorationImage(
                                            image: pw.MemoryImage(grp343),
                                            fit: pw.BoxFit.contain),
                                      )))
                            ])))
                    //pw.SizedBox(height: 40)
                  ])),
                  decoration: pw.BoxDecoration(
                    image: pw.DecorationImage(
                        image: pw.MemoryImage(byteList), fit: pw.BoxFit.fill),
                    color: PdfColor.fromHex("FFFFFF"),
                  )));
        });
  }

  detailText(String value, pw.Font ttf) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 1),
          pw.SizedBox(
              width: 150,
              child: pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(value,
                      style: pw.TextStyle(
                          font: (ttf), fontSize: 10, color: PdfColors.black))))
        ]);
  }

  detailText2(String value) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 1),
          pw.SizedBox(
              width: 50,
              child: pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(value,
                      style: const pw.TextStyle(
                          fontSize: 10, color: PdfColors.black))))
        ]);
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
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
