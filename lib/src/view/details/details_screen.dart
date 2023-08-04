import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vregistration/src/provider/details_provider.dart';
import 'package:vregistration/src/utils/app_utils.dart';

class DetailsScreen extends StatefulWidget {
  final String? id;
  const DetailsScreen({super.key, this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    //Provider.of<DetailsProvider>(context,listen: false).getDetails(widget.id!);
    log("${widget.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailsProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<DetailsProvider>(
                  builder: (context, value, child) {
                    if ((widget.id!.isNotEmpty || widget.id != null) &&
                        value.userDetails == null) {
                      value.getDetails(context,widget.id!);
                    }
                    return Padding(
                      padding: AppConstants.all_20,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          chilDView("ID", value.userDetails?.id ?? ""),
                          chilDView("Name", value.userDetails?.name ?? ""),
                          chilDView("Gender", value.userDetails?.gender ?? ""),
                          chilDView("Age", value.userDetails?.age ?? ""),
                          chilDView("Number", value.userDetails?.number ?? ""),
                          chilDView("Address", value.userDetails?.address ?? ""),
                          chilDView("constituency",
                              value.userDetails?.constituency ?? ""),
                          chilDView(
                              "District", value.userDetails?.district ?? ""),
                          chilDView("pincode", value.userDetails?.pincode ?? ""),
                          chilDView("Date Of Registered",
                              value.userDetails?.date ?? ""),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
          width: 150,
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
