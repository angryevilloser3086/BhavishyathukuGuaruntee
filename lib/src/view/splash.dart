import 'package:flutter/material.dart';
import 'package:vregistration/src/view/home_screen.dart';
import 'package:vregistration/src/view/welcomescreen.dart';

import '../utils/app_utils.dart';
import '../utils/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   bool showLoader = false;
  SharedPref sharedPref = SharedPref();
  @override
  void initState() {
    showLoader = true;
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => checkEmp());
  }
  void checkEmp() {
   //var body = FirebaseAuth.instance.currentUser;
    sharedPref.readBool('details').then((value) {
      if (value) {
        setState(() {
          showLoader = false;
          AppConstants.moveNextClearAll(
              context,const HomeScreen());
        });
      } else {
        setState(() {
          showLoader = false;
          AppConstants.moveNextstl(context,const VolunteerDetails());
        });
      }
    });
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: AppConstants.appYellowBG,
      body: SafeArea(
          child: Column(
        children: [
          AppConstants.h_40,
          Padding(
            padding: AppConstants.all_10,
            child: Image.asset("assets/images/BG-Logo-small 1.png"),
          ),
          AppConstants.h_20,
          if (showLoader)
              const Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                  color: AppConstants.appredColor,
                ),
              )
        ],
      )),
    );
  }
}
