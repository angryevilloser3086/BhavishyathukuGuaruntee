import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../model/reg_model.dart';
import '../../utils/app_utils.dart';

class MyPDF extends StatelessWidget {
  const MyPDF({super.key, required this.rModel});
  final RegistrationModel rModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: AppConstants.all_10,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  // width: 1970,
                  width: 595,
                  height: 842,
                  child: PdfPreview(
                      canChangePageFormat: false,
                      build: (_) => makePDF(context)),
                )

                // Image.asset("assets/images/ic_background.png"),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<Uint8List> makePDF(BuildContext context) async {
    final pdf = pw.Document();
    print(rModel.toJSON());
    pdf.addPage(await createPageOne());
    pdf.addPage(await createPageTwo());
    return pdf.save();
  }

  createPageOne() async {
    final ByteData bytes = await rootBundle.load('assets/images/ic_bg_1.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final ByteData headerbB =
        await rootBundle.load('assets/images/ic_pdf_header.png');
    final Uint8List hByteList = headerbB.buffer.asUint8List();
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
                    pw.Align(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            left: 35.0, right: 35, top: 25),
                        child: pw.Image(pw.MemoryImage(hByteList)),
                      ),
                    ),

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
                              pw.SizedBox(width: 10),
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
        await rootBundle.load('assets/images/ic_pdf_header.png');
    final Uint8List hByteList = headerbB.buffer.asUint8List();
    final ByteData subHead =
        await rootBundle.load('assets/images/ic_subhead_secondCard.png');
    final Uint8List subHeadList = subHead.buffer.asUint8List();
    final ByteData grp = await rootBundle.load('assets/images/table.png');
    final Uint8List grp343 = grp.buffer.asUint8List();

    // final font = await rootBundle
    //     .load('assets/fonts/Tiro_Telugu/TiroTelugu-Regular.ttf');

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
                                    child: detailText("${rModel.totalFam}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.totalFarmers}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.totalWomen}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.totalStudents}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalUnEmployedYouth}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                ]),
                              ),
                              pw.Positioned(
                                left: 500,
                                bottom: 40,
                                child: pw.Column(children: [
                                  pw.SizedBox(height: 50),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceEvenly,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2("${rModel.totalWomen}"),
                                          pw.SizedBox(width: 10),
                                          detailText2("="),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalWomen * 18000}"),
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
                                              "${rModel.totalStudents}"),
                                          pw.SizedBox(width: 10),
                                          detailText2("="),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalStudents * 15000}"),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.SizedBox(height: 20),
                                  pw.Positioned(
                                    left: 80,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceEvenly,
                                        children: [
                                          pw.SizedBox(width: 10),
                                          detailText2("${rModel.totalFarmers}"),
                                          pw.SizedBox(width: 10),
                                          detailText2("="),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalFarmers * 20000}"),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.SizedBox(height: 20),
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
                                          detailText2("="),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalUnEmployedYouth * 36000}"),
                                          pw.SizedBox(width: 10),
                                        ]),
                                  ),
                                  pw.SizedBox(height: 10),
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
                                left: 300,
                                top: 5,
                                child: pw.Container(
                                    height: 20,
                                    
                                    color: PdfColors.amberAccent,
                                    child: pw.Row(children: [
                                      pw.Text("UNIQUE CODE:",
                                          style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                              color: PdfColors.black)),
                                      detailText(
                                          "${rModel.id!.isEmpty ? 12345678 : rModel.id}")
                                    ])),
                              ),
                              pw.Positioned(
                                left: 350,
                                child: pw.Column(children: [
                                  pw.SizedBox(height: 55),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.pincode}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.constituency}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.number}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                ]),
                              ),
                              pw.Positioned(
                                left: 100,
                                child: pw.Column(children: [
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.name}"),
                                  ),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.fatherNamefield}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.age}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.address}"),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.district}"),
                                  ),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("#######"),
                                  ),
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

  detailText(String value) {
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
                      style: const pw.TextStyle(
                          fontSize: 10, color: PdfColors.black))))
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
