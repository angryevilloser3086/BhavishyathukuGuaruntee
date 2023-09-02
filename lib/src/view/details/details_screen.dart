import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vregistration/src/model/reg_model.dart';
import '../../utils/app_localization.dart';
import '../registration/registration.dart';
import '/src/provider/details_provider.dart';
import '/src/utils/app_utils.dart';

class DetailsScreen extends StatefulWidget {
  static const String route = '/get-details';
  final String? id;
  const DetailsScreen({super.key, this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   //Provider.of<DetailsProvider>(context,listen: false).getDetails(widget.id!);
  //   log("${widget.id}:::");
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailsProvider(),
      child: Scaffold(
        backgroundColor: AppConstants.appYellowBG,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: mobNumCard(context),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Selector<DetailsProvider, bool>(
                      builder: (context, p, _) {
                        if (p) {
                          print("p:$p");
                          return Consumer<DetailsProvider>(
                            builder: (context, value, child) {
                              print(value.userDetails?.id);
                              return Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: AppConstants.all_10,
                                  child: Container(
                                    padding: AppConstants.all_10,
                                    decoration: const BoxDecoration(
                                        color: AppConstants.appBgColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    width: 350,
                                    height: 460,
                                    child: Column(
                                      children: [
                                        chilDView(
                                            "ID", value.userDetails?.id ?? ""),
                                        chilDView("Name",
                                            value.userDetails?.name ?? ""),
                                        chilDView("Gender",
                                            value.userDetails?.gender ?? ""),
                                        chilDView("Age",
                                            value.userDetails?.age ?? ""),
                                        chilDView("Number",
                                            value.userDetails?.number ?? ""),
                                        chilDView("Address",
                                            value.userDetails?.address ?? ""),
                                        chilDView(
                                            "constituency",
                                            value.userDetails?.constituency ??
                                                ""),
                                        chilDView("District",
                                            value.userDetails?.district ?? ""),
                                        chilDView("pincode",
                                            value.userDetails?.pincode ?? ""),
                                        chilDView("Date Of Registered",
                                            value.userDetails?.date ?? ""),
                                        if(value.dataPdf!=null)
                                        InkWell(
                                          onTap: ()async=>value.downloadFile(context, value.dataPdf!, value.userDetails!),
                                          child: Container(
                                            width: 150,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))),
                                            child: const Center(
                                                child: Text("మీ సర్టిఫికేట్ డౌన్‌లోడ్ చేసుకోండి")),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Container(
                            // child: Column(
                            //   children: [
                            //     Text(
                            //       "వినియోగదారు భవిష్యతుకు హామీతో నమోదు చేసుకోలేదు",
                            //       style: GoogleFonts.poppins(
                            //           fontSize: 14,
                            //           color: Colors.black,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //     InkWell(
                            //       onTap: () => AppConstants.moveNextClearAll(
                            //           context, RegistratioScreen()),
                            //       child: Text("Click here to register",
                            //           style: GoogleFonts.poppins(
                            //               fontSize: 14,
                            //               color: Colors.black,
                            //               fontWeight: FontWeight.bold)),
                            //     )
                            //   ],
                            // ),
                          );
                        }
                      },
                      selector: (p0, p1) => p1.enableSelector),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  mobNumCard(BuildContext context) {
    return Container(
      width: 350,
      height: 550,
      decoration: const BoxDecoration(
          color: AppConstants.appBgColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: AppConstants.all_20,
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/ic_new_logo.png"),
              Text(
                Strings.of(context).validateText,
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
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
                child: Consumer<DetailsProvider>(
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
                          child: Consumer<DetailsProvider>(
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
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            controller: loginProvider.phoneTextController,
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
                            validator: (value) => value!.trim().isEmpty
                                ? 'phone number required'
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              AppConstants.h_5,
              Consumer<DetailsProvider>(builder: (context, provider, child) {
                return InkWell(
                    onTap: () {
                      if (provider.phoneTextController.text.isNotEmpty) {
                        provider.getDetails(
                            context, provider.phoneTextController.text, true);
                      }
                    },
                    child: btn());
              }),
            ],
          ),
        ),
      ),
    );
  }

  btn() {
    return Container(
      width: 150,
      height: 50,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: const Center(child: Text("Get Details")),
    );
  }

  chilDView(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(
          width: 120,
          child: Text(
            ": $value",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        )
      ],
    );
  }
}
