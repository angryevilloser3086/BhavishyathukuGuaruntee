// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '/src/view/registration/registration.dart';
import '../../model/reg_model.dart';
import '../../utils/app_utils.dart';

class MyPDF extends StatefulWidget {
  const MyPDF({super.key, required this.rModel});
  final RegistrationModel rModel;

  @override
  State<MyPDF> createState() => _MyPDFState();
}

class _MyPDFState extends State<MyPDF> {
  Uint8List? pdfvalue;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final value = await makePDF(context);
    setState(() {
      pdfvalue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: AppConstants.all_10,
          child: Center(
            child: Column(
              children: [
                if (pdfvalue != null)
                  Row(
                    children: [
                      if (!kIsWeb)
                        InkWell(
                          onTap: () async => saveFile(pdfvalue!),
                          child: startBtn(size, "Donwload"),
                        ),
                      InkWell(
                        onTap: () async => downloadFile(pdfvalue!),
                        child: startBtn(size, kIsWeb ? "Download" : "Share"),
                      ),
                    ],
                  ),
                AppConstants.h_10,
                if (pdfvalue != null)
                  SizedBox(
                    // width: 1970,
                    width: 595,
                    height: 842,
                    child: PdfPreview(
                        pdfFileName: "${widget.rModel.number}",
                        allowPrinting: false,
                        allowSharing: true,
                        canDebug: false,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        build: (_) => pdfvalue!),
                  ),
                if (pdfvalue == null) const CircularProgressIndicator(),

                // Image.asset("assets/images/ic_background.png"),
              ],
            ),
          ),
        ),
      )),
    );
  }

  downloadFile(Uint8List files) async {
    Printing.sharePdf(bytes: files, filename: '${widget.rModel.number}.pdf')
        .then((value) {
      AppConstants.showSnackBar(context, "Certificate downloaded Successfully");
      AppConstants.moveNextClearAll(context, const RegistratioScreen());
    });
  }

  Future<void> saveFile(Uint8List files) async {
    var file = File('');
    
    // Platform.isIOS comes from dart:io
    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/${widget.rModel.number}.pdf');
      file
          .writeAsBytes(files)
          .then((value) => {
                AppConstants.showSnackBar(context,
                    "Your Certificate is saved successfully to ${value.path}")
              })
          .catchError((err) {
        AppConstants.showSnackBar(context, "$err");
      });
    }
    if (Platform.isAndroid) {
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      file = File('${dir.path}/${widget.rModel.number}.pdf');
      file
          .writeAsBytes(files)
          .then((value) => {
                AppConstants.showSnackBar(context,
                    "Your Certificate is saved successfully to ${value.path}"),
                AppConstants.moveNextClearAll(
                    context, const RegistratioScreen())
              })
          .catchError((err) {
        AppConstants.showSnackBar(context, "$err");
        return null;
      });
    }
  }

  // saveAndroid() async {
  //   final Directory? downloadsDir = await getExternalStorageDirectory();

  //   final file = File("${downloadsDir!.path}/qr_code.pdf");
  //   await file.writeAsBytes(await pdf.save()).then((value) {
  //     final snackBar = SnackBar(
  //       content: Text('PDF saved to Dir: ${value.path}'),
  //       backgroundColor: (Colors.black12),
  //       action: SnackBarAction(
  //         label: 'dismiss',
  //         onPressed: () {},
  //       ),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   });
  // }

  startBtn(Size size, String title) {
    return Container(
      width: size.width * 0.17,
      height: size.height * 0.04,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: AppConstants.appredColor),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
              color: AppConstants.appYellowBG,
              fontSize: size.width < 450 ? 15 : 16,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<Uint8List> makePDF(BuildContext context) async {
    final pdf = pw.Document();
    print(widget.rModel.toJSON());
    pdf.addPage(await createPageOne());
    pdf.addPage(await createPageTwo());
    return pdf.save();
  }

  createPageOne() async {
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
        await rootBundle.load('assets/images/BG-Logo-small 1.png');
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
                                                "${(widget.rModel.totalWomen * 18000 + widget.rModel.totalFarmers * 20000 + widget.rModel.totalStudents * 15000 + widget.rModel.totalUnEmployedYouth * 36000) * 5}",
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

  createPageTwo() async {
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
                                    child: detailText(
                                        "${widget.rModel.totalFam}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.totalFarmers}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.totalWomen}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.totalStudents}",
                                        fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.totalUnEmployedYouth}",
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
                                        detailText2(
                                            "${widget.rModel.totalWomen}"),
                                        pw.SizedBox(width: 10),
                                        detailText2(""),
                                        pw.SizedBox(width: 10),
                                        detailText2(
                                            "${widget.rModel.totalWomen * 18000}"),
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
                                        detailText2(
                                            "${widget.rModel.totalStudents}"),
                                        pw.SizedBox(width: 10),
                                        detailText2(""),
                                        pw.SizedBox(width: 10),
                                        detailText2(
                                            "${widget.rModel.totalStudents * 15000}"),
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
                                          detailText2(
                                              "${widget.rModel.totalFarmers}"),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${widget.rModel.totalFarmers * 20000}"),
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
                                              "${widget.rModel.totalUnEmployedYouth}"),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${widget.rModel.totalUnEmployedYouth * 36000}"),
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
                                              "${widget.rModel.totalWomen * 18000 + widget.rModel.totalFarmers * 20000 + widget.rModel.totalStudents * 15000 + widget.rModel.totalUnEmployedYouth * 36000}"),
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
                                              "${(widget.rModel.totalWomen * 18000 + widget.rModel.totalFarmers * 20000 + widget.rModel.totalStudents * 15000 + widget.rModel.totalUnEmployedYouth * 36000) * 5}"),
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
                                          "${widget.rModel.id!.isEmpty ? 12345678 : widget.rModel.id}",
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
                                    child: detailText(
                                        "${widget.rModel.pincode}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.constituency}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.number}", fontG),
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
                                    child: detailText(
                                        "${widget.rModel.name}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.fatherNamefield}",
                                        fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.age}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.address}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${widget.rModel.district}", fontG),
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
}


//eb08146..96e771f