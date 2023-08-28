import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import '/src/utils/shared_pref.dart';
import '/src/view/home_screen.dart';

import '../utils/app_utils.dart';

class WelcomeDetailsProvider extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  String cc = "91";
  SharedPref sharedPref = SharedPref();

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

  saveDetails(BuildContext context) {
    sharedPref.save("vname", name.text);
    sharedPref.save("vnum", number.text);
    sharedPref.saveBool("details", true);
    // print(await sharedPref.read("vname"));

    AppConstants.moveNextClearAll(context, const HomeScreen());
    notifyListeners();
  }
}
