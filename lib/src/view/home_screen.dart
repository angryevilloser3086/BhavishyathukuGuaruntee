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
      ScrollController scrollController =ScrollController();
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
           
            InkWell(
                onTap: () {
                  //Navigator.
                  if(w<450){
                    setState(() {
                    scrollController.animateTo(MediaQuery.of(context).size.height*0.5, duration: Duration(seconds: 2), curve: Curves.bounceOut);
                  });
                  }else{

                  setState(() {
                    scrollController.animateTo(MediaQuery.of(context).size.height*1.6, duration: Duration(seconds: 2), curve: Curves.bounceOut);
                  });
                  }
                },
                child: btn()),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.asset(images[activePage]),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: InkWell(
                    onTap: (){
                      if(activePage>=0&&activePage<images.length-1) {
                        setState(() {
                        setState(() {
                          activePage--;
                        });
                      });
                      }else{
                        activePage=images.length-1;
                      }
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: InkWell(
                    onTap: (){
                      if(activePage>=0&&activePage<images.length-1) {
                        setState(() {
                        activePage++;
                      });
                      }else{
                        setState(() {
                          activePage=0;
                        });
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                )
              ],
            ),
            Image.asset("assets/images/header-website.png1_.png"),
           
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
