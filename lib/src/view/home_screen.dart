import 'package:flutter/material.dart';

import 'registration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);
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
      backgroundColor: Colors.yellowAccent,
      body: SafeArea(
          child: SingleChildScrollView(
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
           
            InkWell(
                onTap: () {
                  //Navigator.
                },
                child: btn()),
           
            Image.asset(images[0]),
            Image.asset(images[1]),
            Image.asset(images[2]),
            Image.asset(images[3]),
            Image.asset(images[4]),
            Image.asset(images[5]),
            Image.asset("assets/images/header-website.png1_.png"),
            // if (w < 580)
            //   Container(
            //     height: h * 0.6,
            //     color: Colors.white,
            //   )
            SizedBox(
              height: h*1.4,
              width: w/1.5,
              child:const RegistratioScreen(),
            ),
            //RegistratioScreen()
            Container(color: Colors.white,
            height: 50,)
          ],
        ),
      )),
    );
  }

  // getWidthHeight() {
  //   final height = MediaQuery.of(context).size.height;
  // }

  btn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 50,
        decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: const Center(child: Text("Register")),
      ),
    );
  }
}
