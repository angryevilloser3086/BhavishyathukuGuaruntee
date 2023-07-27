

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vregistration/src/provider/details_provider.dart';
import 'package:vregistration/src/view/details/details_screen.dart';
import 'package:vregistration/src/view/home_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vregistration/src/view/qr.dart';

import 'firebase_options.dart';
import 'src/provider/registration_provider.dart';
import 'utils/app_utils.dart';

bool shouldUseFirestoreEmulator = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => DetailsProvider()),
      ],
      child: MaterialApp(
        // Providing a restorationScopeId allows the Navigator built by the
        // MaterialApp to restore the navigation stack when a user leaves and
        // returns to the app after it has been killed while running in the
        // background.
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'app',
        
        // Provide the generated AppLocalizations to the MaterialApp. This
        // allows descendant Widgets to display the correct translations
        // depending on the user's locale.
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],

        // Use AppLocalizations to configure the correct application title
        // depending on the user's locale.
        //
        // The appTitle is defined in .arb files found in the localization
        // directory.
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,

        // Define a light and dark color theme. Then, read the user's
        // preferred ThemeMode (light, dark, or system default) from the
        // SettingsController to display the correct theme.
        theme: ThemeData(
          primaryColor: AppConstants.appBgColor,
          unselectedWidgetColor: Colors.white,
          //textButtonTheme: TextButtonThemeData(style: flatButtonStyle),

          textTheme: GoogleFonts.interTextTheme().copyWith(
              displayLarge: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              displayMedium: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              displaySmall: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
                  headlineLarge: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              headlineMedium: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              headlineSmall: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              titleLarge: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              bodySmall: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
              bodyMedium: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              labelLarge: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1E1868)),
              titleMedium: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.appPrimaryColor)),
          buttonTheme: const ButtonThemeData(
              shape: RoundedRectangleBorder(),
              buttonColor: AppConstants.appPrimaryColor),
          colorScheme: const ColorScheme(
              background: AppConstants.appBgColor,
              brightness: Brightness.dark,
              error: AppConstants.appBgColor,
              onBackground: Colors.black,
              onError: AppConstants.appBgColor,
              onPrimary: Colors.black,
              onSecondary: AppConstants.appPrimaryColor,
              onSurface: AppConstants.appBgColor,
              primary: Colors.blueGrey,
              secondary: Colors.white,
              surface: Colors.white),
          // outlinedButtonTheme: OutlinedButtonThemeData(
          //     style: OutlinedButton.styleFrom(
          //       shape: const RoundedRectangleBorder(),
          //       primary: const Color(0xFFF7BB0E),
          //     ),
          //   ),
        ),
        darkTheme: ThemeData.dark(),
        onGenerateRoute: (settings){
             List<String> pathComponents = settings.name!.split('/');
            // List<String> pathComponents = settings.name.split('/');
          if (pathComponents[1] == 'details-screen' ) {
            print(pathComponents.toList());
            return MaterialPageRoute(
              builder: (context) {
                return DetailsScreen(id: pathComponents.last);
              },
            );
          }else if(pathComponents[1]=='QRSCREEN'){
            return MaterialPageRoute(
              builder: (context) {
                return const QRViewExample();
              },
            );
          } else {
            print("else block:${pathComponents.toList()}");
            return MaterialPageRoute(
              builder: (context) {
                return const HomeScreen();
              },
            );
          }
        
            // switch (settings.name) {
            //   case '/':
            //     return MaterialPageRoute(
            //     builder: (context) =>const HomeScreen(),
            //   );
            //   case '/QRSCREEN':
            //     return MaterialPageRoute(
            //     builder: (context) =>const QRViewExample(),
            //   );
            //   case '/details-screen':
            //     return MaterialPageRoute(
            //     builder: (context) =>const DetailsScreen(),
            //   );
            //   //case '/details-screen/':

            //   default:
            //     return MaterialPageRoute(
            //     builder: (context) => DetailsScreen(id: pathComponents.last,),
            //   );
            // }
           
        },
        
        routes: {
          // '/':(context)=>const HomeScreen(),
          // '/QRSCREEN':(context)=>const QRViewExample()
        },
        // Define a function to handle named routes in order to support
        // Flutter web url navigation and deep linking.
       // home: const HomeScreen(),
      ),
    );
  }
}
