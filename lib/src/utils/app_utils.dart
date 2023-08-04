import 'package:flutter/material.dart';

import 'dart:typed_data';

import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  static const appPrimaryColor = Color(0xff0c54be);
  static const appBgColor = Color(0xFFF5F9FD);
  static const appBgLite = Colors.blueGrey;
  static const appFontcolor = Color(0xFFCED3DC);
  static const appHeadcolor = Color(0xFFF2FF00);
  static const appYellowBG = Color(0xFFFEE806);
  static const appredColor = Color(0xFFE10707);  
  static const appredQColor = Color(0xFFE31F25);  
  static const appPurpleColor = Color(0xFF641258);  
  static const appPurplelit2Color = Color(0x60641258);  
  static const appPurplelit1Color = Color(0x40641258);  

  


  static const h_5 = SizedBox(height: 5);
  static const h_10 = SizedBox(height: 10);
  static const h_20 = SizedBox(height: 20);
  static const h_24 = SizedBox(height: 24);
  static const h_30 = SizedBox(height: 30);
  static const h_40 = SizedBox(height: 40);
  static const h_50 = SizedBox(height: 50);
  static const h_60 = SizedBox(height: 60);

  static const w_5 = SizedBox(width: 5);
  static const w_10 = SizedBox(width: 10);
  static const w_15 = SizedBox(width: 15);
  static const w_20 = SizedBox(width: 20);
  static const w_22 = SizedBox(width: 22);
  static const w_25 = SizedBox(width: 25);
  static const w_30 = SizedBox(width: 30);
  static const w_40 = SizedBox(width: 40);

  static const all_5 = EdgeInsets.all(5);
  static const all_10 = EdgeInsets.all(10);
  static const all_15 = EdgeInsets.all(15);
  static const all_20 = EdgeInsets.all(20);
  static const all_100 = EdgeInsets.all(100);

  static const leftRight_5 = EdgeInsets.only(left: 5, right: 5);
  static const leftRight_10 = EdgeInsets.only(left: 10, right: 10);
  static const leftRight_20 = EdgeInsets.only(left: 20, right: 20);

  static const left10 = EdgeInsets.only(left: 10);
  static const left20 = EdgeInsets.only(left: 20);
  static const left100 = EdgeInsets.only(left: 100);

  static const boxRadius8 = BorderRadius.all(Radius.circular(8));
  static const boxRadiusAll12 = BorderRadius.all(Radius.circular(12));
  static const boxRadius12 = BorderRadius.only(
      bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12));
  static const boxRadius15 = BorderRadius.all(Radius.circular(15));

  static const outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), borderRadius: boxRadius15);
  static var boxBorderDecorationPrimary = BoxDecoration(
      border: Border.all(color: appPrimaryColor),
      borderRadius: boxRadius8,
      color: appPrimaryColor);
  static const textStyleCC = TextStyle(fontSize: 16, color: Colors.blueGrey);
  static BorderRadius toBorderRadiusTLR() {
    return const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    );
  }
  static var boxBorderDecoration = BoxDecoration(
      border: Border.all(color: Colors.amber), borderRadius: boxRadius8);

  static var boxBorderDecoration2 = BoxDecoration(
    color: Colors.white,
      border: Border.all(color:AppConstants.appBgLite), borderRadius: boxRadius8);


  static InputDecoration toAppInputDecoration2(
      BuildContext context, String hint, String counterText) {
    return InputDecoration(
        fillColor: Colors.white,
        filled: true,
        counterStyle: Theme.of(context).textTheme.bodySmall,
        counterText: counterText,
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyLarge,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder);
  }

  static void showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
        content: Text(msg, style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        backgroundColor: appPrimaryColor,
        duration: const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static InputDecoration toInputDecorationSearch() {
    return InputDecoration(
        labelText: 'Search by name',
        hintText: 'Start typing to search',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF8C98A8).withOpacity(0.2),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF8C98A8).withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF8C98A8).withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF8C98A8).withOpacity(0.2),
          ),
        ));
  }
  static const boxDecoration = BoxDecoration(
      image: DecorationImage(
    image: AssetImage("assets/images/maha_bg.png"),
    fit: BoxFit.cover,
  ));
  static void moveNextstl(BuildContext context, dynamic widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static void moveNextClearAll(BuildContext context, dynamic widget) {
    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => widget,
        ),
        ModalRoute.withName(
            "/") //(route) => false, //if you want to disable back feature set to false
        );
  }
}

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);
