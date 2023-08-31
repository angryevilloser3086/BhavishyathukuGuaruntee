// ignore_for_file: use_build_context_synchronously

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:vregistration/src/view/registration/validation.dart';
import '../utils/svg_Image.dart';
import '../utils/svg_pg2.dart';
import '/src/utils/shared_pref.dart';
import '../../src/network/api_request.dart';
import '../../src/utils/loading_indicator.dart';
import '../model/checkbox.dart';
import '../model/reg_model.dart';
import '../model/v_reg_model.dart';
import '../utils/app_utils.dart';
import '../view/details/pdf_screen.dart';

class RegistrationProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  String selectedConstituency = '';
  bool showSubmit = false;
  int selectedRadio = 0;
  int selectedURadio = 0;
  int selectedGRadio = 0;
  String hours = "00", minutes = "00", seconds = "00";
  int hour = 0, minute = 0, second = 59;
  Timer? timer;
  ApiRequest apiRequest = ApiRequest();
  bool isVerified = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  TextEditingController name = TextEditingController();
  TextEditingController gpController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();
  TextEditingController vNumController = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController vName = TextEditingController();
  TextEditingController fatherNamefield = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController uniqueCode = TextEditingController();
  bool showLoader = false;
  String gender = '';
  SharedPref sharedPref = SharedPref();
  String cc = "91";
  String sDistrcts = '';
  String sMandals = '';
  int famMembers = 0;
  int farmers = 0;
  int womenAbv = 0;
  int unEMployedYouth = 0;
  int students = 0;
  bool showLoaderOTP = false;

  List<TextEditingController> farmersController = [];
  List<TextEditingController> farmersAgeController = [];
  List<Widget> farmersFields = [];

  List<TextEditingController> womenController = [];
  List<TextEditingController> womenAgeController = [];
  List<Widget> womenFields = [];
  List<TextEditingController> studentsController = [];
  List<TextEditingController> studentsAgeController = [];
  List<Widget> studentFields = [];
  List<TextEditingController> uEmpYouthController = [];
  List<TextEditingController> uEmpYouthAgeController = [];
  List<Widget> uEmpYouthFields = [];
  String pc = '';
  String zone = '';

  List<int> famMem = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  List<int> farmersNum(int framers) {
    List<int> lNum = [];
    for (int i = 0; i <= framers; i++) {
      lNum.add(i);
    }

    return lNum;
  }

  setmobNum(String value) {
    phoneTextController = TextEditingController(text: value);
    notifyListeners();
  }

  setFamMembers(int value) {
    famMembers = value;
    notifyListeners();
  }

  void processTimer() {
    if (second > 0) {
      second--;
    } else if (second == 59) {
      second = 0;
      if (minute == 59) {
        hour++;
        minute = 0;
      } else {
        minute--;
      }
    }

    hours = hour.toString().padLeft(2, '0');
    minutes = (minute).toString().padLeft(2, '0');
    seconds = second.toString().padLeft(2, '0');
    if (second == 0) timer?.cancel();
    notifyListeners();
  }

  setVDetails() async {
    String name = '';
    String number = '';
    if (Platform.isAndroid || Platform.isIOS) {
      name = await sharedPref.read("vname");
      number = await sharedPref.read("vnum");
    }
    vName = TextEditingController(text: name);
    vNumController = TextEditingController(text: number);
    notifyListeners();
  }

  setFarmers(BuildContext context, int value) {
    farmers = value;
    updatePersonDetails(context, farmers, farmersController,
        farmersAgeController, farmersFields);
    notifyListeners();
  }

  updatePersonDetails(
      BuildContext context,
      int length,
      List<TextEditingController> controllers,
      List<TextEditingController> ageControllers,
      List<Widget> fields) {
    // print(length);
    controllers.clear();
    ageControllers.clear();
    fields.clear();
    for (int i = 0; i < length; i++) {
      // print("int$i");

      controllers.add(TextEditingController());
      ageControllers.add(TextEditingController());
      fields.add(
        Container(
          alignment: Alignment.centerRight,
          width: 272,
          padding: AppConstants.all_10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please enter the person details below :",
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              AppConstants.h_5,
              TextFormField(
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                cursorColor: Colors.grey,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter the name ";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Enter Name",
                    counterText: "",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: AppConstants.boxRadius8),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: AppConstants.boxRadius8)),
                keyboardType: TextInputType.text,
                maxLength: 50,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                controller: controllers[fields.length],
              ),
              AppConstants.h_5,
              TextFormField(
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                cursorColor: Colors.grey,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter the Age";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Enter Age",
                    counterText: "",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: AppConstants.boxRadius8),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: AppConstants.boxRadius8)),
                keyboardType: TextInputType.number,
                maxLength: 3,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: ageControllers[fields.length],
              ),
            ],
          ),
        ),
      );
    }
  }

  setunEMployed(BuildContext context, int value) {
    unEMployedYouth = value;
    updatePersonDetails(context, unEMployedYouth, uEmpYouthController,
        uEmpYouthAgeController, uEmpYouthFields);
    notifyListeners();
  }

  setStudents(BuildContext context, int value) {
    students = value;
    updatePersonDetails(context, students, studentsController,
        studentsAgeController, studentFields);

    notifyListeners();
  }

  setNoOFWomen(BuildContext context, int value) {
    womenAbv = value;
    updatePersonDetails(
        context, womenAbv, womenController, womenAgeController, womenFields);

    notifyListeners();
  }

  List<String> sendList(String value) {
    if (value.isNotEmpty && value != 'Please Select your District') {
      if (value == 'Alluri Sitharama Raju/అల్లూరి సీతారామ రాజు') {
        return asRaju;
      } else if (value == 'Anakapalli/అనకాపల్లి') {
        // print(value);
        return anakapalli;
      } else if (value == 'Anantapuramu/అనంతపురము') {
        return anatapur;
      } else if (value == 'Annamayya/అన్నమయ్య') {
        return annamayya;
      } else if (value == 'Bapatla/బాపట్ల') {
        return bapatla;
      } else if (value == 'Chittoor/చిత్తూరు') {
        return chittoor;
      } else if (value ==
          'Dr. B. R. Ambedkar Konaseema/డా.బి.ఆర్.అంబేద్కర్ కోనసీమ') {
        return konaseema;
      } else if (value == 'East Godavari/తూర్పు గోదావరి') {
        return eastGodavari;
      } else if (value == 'Eluru/ఏలూరు') {
        return eluru;
      } else if (value == 'Guntur/గుంటూరు') {
        return guntur;
      } else if (value == 'Kadapa/కడప') {
        return kadapa;
      } else if (value == 'Kakinada/కాకినాడ') {
        return kakinada;
      } else if (value == 'Krishna/కృష్ణ') {
        return krishna;
      } else if (value == 'Kurnool/కర్నూలు') {
        return kurnool;
      } else if (value == 'Nandyal/నంద్యాల') {
        return nandyal;
      } else if (value == 'Nellore/నెల్లూరు') {
        return nellore;
      } else if (value == 'NTR/ఎన్టీఆర్') {
        return ntr;
      } else if (value == 'Palnadu/పల్నాడు') {
        return palnadu;
      } else if (value == 'Parvathipuram Manyam/పార్వతీపురం మన్యం') {
        return manyam;
      } else if (value == 'Prakasam/ప్రకాశం') {
        return prakasam;
      } else if (value == 'Sri Sathya Sai/శ్రీ సత్యసాయి') {
        return sssai;
      } else if (value == 'Srikakulam/శ్రీకాకుళం') {
        return srikakulam;
      } else if (value == 'Tirupati/తిరుపతి') {
        return tirupati;
      } else if (value == 'Visakhapatnam/విశాఖపట్నం') {
        return vishakapatnam;
      } else if (value == 'Vizianagaram/విజయనగరం') {
        return vizianagaram;
      } else if (value == 'West Godavari/పశ్చిమ గోదావరి') {
        return westGodavari;
      } else {
        return ['Please select your District'];
      }
    } else {
      return ['Please select your District'];
    }
  }

  List<String> sendMandalList(String value) {
    if (value.isNotEmpty && value != 'Please select your District' ||
        value != 'Please select your Assembly Constituency') {
      if (value == 'Araku Valley/అరకు లోయ') {
        return arakuMandals;
      } else if (value == 'Paderu/పాడేరు') {
        return paderuMandals;
      } else if (value == 'Rampachodavaram/రంపచోడవరం') {
        return rampochodavaramMandals;
      } else if (value == 'Chodavaram/చోడవరం') {
        return chodavaramMandals;
      } else if (value == 'Madugula/మాడుగుల') {
        return madugulaMandals;
      } else if (value == 'Anakapalle/అనకాపల్లి') {
        return anakapalliMandals;
      } else if (value == 'Pendurthi/పెందుర్తి') {
        return pendurthiMandals;
      } else if (value == 'Elamanchili/ఎలమంచిలి') {
        return elamanchiliMandals;
      } else if (value == 'Payakaraopet/పాయకరావుపేట') {
        return payakaroapetMandals;
      } else if (value == 'Narsipatnam/నర్సీపట్నం') {
        return narsipatnamMandals;
      } else if (value == 'Rayadurg/రాయదుర్గ్') {
        return rayadurgMandals;
      } else if (value == 'Uravakonda/ఉరవకొండ') {
        return uravakondaMandals;
      } else if (value == 'Guntakal/గుంతకల్') {
        return guntakalMandals;
      } else if (value == 'Tadipatri/తాడిపత్రి') {
        return tadipatriMandals;
      } else if (value == 'Singanamala/సింగనమల') {
        return singanamalaMandals;
      } else if (value == 'Anantapur Urban/అనంతపూర్ అర్బన్') {
        return anatapurUrbanMandals;
      } else if (value == 'Kalyandurg/కళ్యాణదుర్గ్') {
        return kalyandurgMandals;
      } else if (value == 'Raptadu/రాప్తాడు') {
        return raptaduMandals;
      } else if (value == 'Vemuru/వేమూరు') {
        return vemuruMandals;
      } else if (value == 'Repalle/రేపల్లె') {
        return repalleMandals;
      } else if (value == 'Bapatla/బాపట్ల') {
        return baptlaMandals;
      } else if (value == 'Parchur/పర్చూరు') {
        return parchurMandals;
      } else if (value == 'Addanki/అద్దంకి') {
        return addankiMandals;
      } else if (value == 'Chirala/చీరాల') {
        return chiralaMandals;
      } else if (value == 'Rajampeta/రాజంపేట') {
        return rajampetMandals;
      } else if (value == 'Kodur/కోడూరు') {
        return kodurMandals;
      } else if (value == 'Rayachoti/రాయచోటి') {
        return rayachotiMandals;
      } else if (value == 'Thamballapalle/తంబళ్లపల్లె') {
        return thamballapalleMandals;
      } else if (value == 'Pileru/పీలేరు') {
        return pileruMandals;
      } else if (value == 'Madanapalle/మదనపల్లె') {
        return madanepalleMandals;
      } else if (value == 'Punganur/పుంగనూరు') {
        return punganurMandals;
      } else if (value == 'Nagari/నగరి') {
        return nagariMandals;
      } else if (value == 'Gangadhara Nellore/గంగాధర  నెల్లూరు') {
        return gangadharaNelloreMandals;
      } else if (value == 'Chittoor/చిత్తూర్') {
        return chittoorMandals;
      } else if (value == 'Puthalapattu/పూతలపట్టు') {
        return puthalapattuMandals;
      } else if (value == 'palamaner/పలమనేరు') {
        return palamanerMandals;
      } else if (value == 'Kuppam/కుప్పం') {
        return kuppamMandals;
      } else if (value == 'Anaparthy/అనపర్తి') {
        return anaparthyMandals;
      } else if (value == 'Rajanagaram/రాజానగరం') {
        return rajanagaramMandals;
      } else if (value == 'Rajamundry City/రాజమండ్రి సిటీ') {
        return rjyCityMandals;
      } else if (value == 'Rajahmundry Rural/రాజమండ్రి గ్రామీణ') {
        return rjyRuralMandals;
      } else if (value == 'Kovvur/కొవ్వూరు') {
        return kovvurMandals;
      } else if (value == 'Nidadavole/నిడదవోలే') {
        return nidadavoleMandals;
      } else if (value == 'Gopalapuram/గోపాలపురం') {
        return gopalapuramMandals;
      } else if (value == 'Unguturu/ఉంగుటూరు') {
        return unguturuMandals;
      } else if (value == 'Denduluru/దెందులూరు') {
        return dendulurMandals;
      } else if (value == 'Eluru/ఏలూరు') {
        return eluruMandals;
      } else if (value == 'Polavaram/పోలవరం') {
        return polavaramMandals;
      } else if (value == 'Chintalapudi/చింతలపూడి') {
        return chintalapudiMandals;
      } else if (value == 'Nuzvid/నూజివీడు') {
        return nuzvidMandals;
      } else if (value == 'Kaikalur/కైకలూరు') {
        return kaikaluruMandals;
      } else if (value == 'Tadikonda/తాడికొండ') {
        return tadikondaMandals;
      } else if (value == 'Mangalagiri/మంగళగిరి') {
        return mangalagiriMandals;
      } else if (value == 'Ponnuru/పొన్నూరు') {
        return ponnurMandals;
      } else if (value == 'Tenali/తెనాలి') {
        return tenaliMandals;
      } else if (value == 'Prathipadu/ప్రత్తిపాడు') {
        return prathipaduGMandals;
      } else if (value == 'Guntur West/గుంటూరు పశ్చిమ') {
        return gunturWestMandals;
      } else if (value == 'Guntur East/గుంటూరు తూర్పు') {
        return gunturEastMandals;
      } else if (value == 'Achanta/ఆచంట') {
        return achantaMandals;
      } else if (value == 'Palakollu/పాలకొల్లు') {
        return palakolluMandals;
      } else if (value == 'Narasapuram/నరసాపురం') {
        return narsapurMandals;
      } else if (value == 'Bhimavaram/భీమవరం') {
        return bhimavaramMandals;
      } else if (value == 'Undi/ఉండీ') {
        return undiMandals;
      } else if (value == 'Tanuku/తణుకు') {
        return tanukuMandals;
      } else if (value == 'Tadepalligudem/తాడేపల్లిగూడెం') {
        return tadepalligudemMandals;
      } else if (value == 'Rajam/రాజం') {
        return rajamMandals;
      } else if (value == 'Bobbili/బొబ్బిలి') {
        return bobbiliMandals;
      } else if (value == 'Cheepurupalli/చీపురుపల్లి') {
        return chepurupalliMandals;
      } else if (value == 'Gajapathinagaram/గజపతినగరం') {
        return gajapathinagaramMandals;
      } else if (value == 'Nellimarla/నెల్లిమర్ల') {
        return nellimarlaMandals;
      } else if (value == 'Vizianagaram/విజయనగరం') {
        return vizianagaramMandals;
      } else if (value == 'Srungavarapukota/శృంగవరపుకోట') {
        return srungavarapukotaMandals;
      } else if (value == 'Bhimili/భీమిలి') {
        return bhimiliMandals;
      } else if (value == 'Vishakapatnam East/విశాఖపట్నం తూర్పు') {
        return vizagEastMandals;
      } else if (value == 'Vishakapatnam West/విశాఖపట్నం పడమర') {
        return vizagWestMandals;
      } else if (value == 'Vishakapatnam South/విశాఖపట్నం దక్షిణ') {
        return vizagSouthMandals;
      } else if (value == 'Vishakapatnam North/విశాఖపట్నం ఉత్తరం') {
        return vizagNorthMandals;
      } else if (value == 'Gajuwaka/గాజువాక') {
        return gajuwakaMandals;
      } else if (value == 'Gudur/గూడూరు') {
        return guduruMandals;
      } else if (value == 'Sullurupeta/సూళ్లూరుపేట') {
        return sullurpetMandals;
      } else if (value == 'Venkatagiri/వెంకటగిరి') {
        return venkatagiriMandals;
      } else if (value == 'Chandragiri/చంద్రగిరి') {
        return chandragiriMandals;
      } else if (value == 'Tirupati/తిరుపతి') {
        return tirupatiMandals;
      } else if (value == 'Srikalahasti/శ్రీకాళహస్తి') {
        return srikalahasthiMandals;
      } else if (value == 'Sathyavedu/సత్యవేడు') {
        return satyaveduMandals;
      } else if (value == 'Ichchapuram/ఇచ్ఛాపురం') {
        return icchapuramMandals;
      } else if (value == 'Palasa/పలాస') {
        return palasaMandals;
      } else if (value == 'Tekkali/టెక్కలి') {
        return tekkaliMandals;
      } else if (value == 'Pathapatnam/పాతపట్నం') {
        return pathapatnamMandals;
      } else if (value == 'Srikakulam/శ్రీకాకుళం') {
        return srikakulamMandals;
      } else if (value == 'Amadalavalasa/ఆమదాలవలస') {
        return amadalavalsaMandals;
      } else if (value == 'Etcherla/ఎచ్చెర్ల') {
        return etcherlaMandals;
      } else if (value == 'Narasannapeta/నరసన్నపేట') {
        return narasannapetaMandals;
      } else if (value == 'Madakasira/మడకశిర') {
        return madakasiraMandals;
      } else if (value == 'Hindupur/హిందూపూర్') {
        return hindupurMandals;
      } else if (value == 'Penukonda/పెనుకొండ') {
        return penukondaMandals;
      } else if (value == 'Puttaparthi/పుట్టపర్తి') {
        return puttaparthiMandals;
      } else if (value == 'Dharmavaram/ధర్మవరం') {
        return dharmavaramMandals;
      } else if (value == 'Kadiri/కదిరి') {
        return kadiriMandals;
      } else if (value == 'Yerragondapalem/యర్రగొండపాలెం') {
        return yerragondapalemMandals;
      } else if (value == 'Darsi/దర్శి') {
        return darsiMandals;
      } else if (value == 'Santhanuthalapadu/సంతనూతలపాడు') {
        return snathanuthalapaduMandals;
      } else if (value == 'Ongole/ఒంగోలు') {
        return ongoleMandals;
      } else if (value == 'Kondapi/కొండపి') {
        return kondepiMandals;
      } else if (value == 'Markapuram/మార్కాపురం') {
        return markapurMandals;
      } else if (value == 'Giddalur/గిద్దలూరు') {
        return giddaluruMandals;
      } else if (value == 'Kanigiri/కనిగిరి') {
        return kanigiriMandals;
      } else if (value == 'Pedakurapadu/పెదకూరపాడు') {
        return pedakurapaduMandals;
      } else if (value == 'Chilakaluripeta/చిలకలూరిపేట') {
        return chilakaluripetaMandals;
      } else if (value == 'Narasaraopet/నరసరావుపేట') {
        return narasaraopetMandals;
      } else if (value == 'Sattenapalle/సత్తెనపల్లె') {
        return sattenapalliMandals;
      } else if (value == 'Vinukonda/వినుకొండ') {
        return vinkuondaMandals;
      } else if (value == 'Gurajala/గురజాల') {
        return gurajalaMandals;
      } else if (value == 'Macherla/మాచర్ల') {
        return macherlaMandals;
      } else if (value == 'Tiruvuru/తిరువూరు') {
        return tiruvuruMandals;
      } else if (value == 'Vijayawada West/విజయవాడ పడమర') {
        return vjyWestMandals;
      } else if (value == 'Vijayawada Central/విజయవాడ సెంట్రల్') {
        return vjyCentralMandals;
      } else if (value == 'Vijayawada East/విజయవాడ తూర్పు') {
        return vjyEastMandals;
      } else if (value == 'Mylavaram/మైలవరం') {
        return mylavaramMandals;
      } else if (value == 'Nandigama/నందిగామ') {
        return nandigamaMandals;
      } else if (value == 'Jaggayyapeta/జగ్గయ్యపేట') {
        return jaggayyapetMandals;
      } else if (value == 'Kandukur/కందుకూరు') {
        return kandukurMandals;
      } else if (value == 'Kavali/కావలి') {
        return kavaliMandals;
      } else if (value == 'Atmakur/ఆత్మకూర్') {
        return atmakurMandals;
      } else if (value == 'Kovur/కోవూరు') {
        return kovurMandals;
      } else if (value == 'Nellore City/నెల్లూరు సిటీ') {
        return nelloreCityMandals;
      } else if (value == 'Nellore Rural/నెల్లూరు రూరల్') {
        return nelloreRuralMandals;
      } else if (value == 'Sarvepalli/సర్వేపల్లి') {
        return sarvepalliMandals;
      } else if (value == 'Udayagiri/ఉదయగిరి') {
        return udayagiriMandals;
      } else if (value == 'Allagadda/ఆళ్లగడ్డ') {
        return allagaddaMandals;
      } else if (value == 'Srisailam/శ్రీశైలం') {
        return srisailamMandals;
      } else if (value == 'Nandikotkur/నందికొట్కూరు') {
        return nandikotkuruMandals;
      } else if (value == 'Panyam/పాణ్యం') {
        return panyamMandals;
      } else if (value == 'Nandyal/నంద్యాల') {
        return nandyalMandals;
      } else if (value == 'Banaganapalle/బనగానపల్లె') {
        return banaganapalleMandals;
      } else if (value == 'Dhone/ధోన్') {
        return dhoneMandals;
      } else if (value == 'Badvel/బద్వేల్') {
        return badvelMandals;
      } else if (value == 'Kadapa/కడప') {
        return kadapaMandals;
      } else if (value == 'Pulivendla/పులివెందుల') {
        return pulivendulaMandals;
      } else if (value == 'Kamalapuram/కమలాపురం') {
        return kamalapuramMandals;
      } else if (value == 'Jammalamadugu/జమ్మలమడుగు') {
        return jammalamaduguMadals;
      } else if (value == 'Mydukur/మైదుకూరు') {
        return mydukurMandals;
      } else if (value == 'Proddatur/ప్రొద్దుటూరు') {
        return proddaturMandals;
      } else if (value == 'Tuni/తుని') {
        return tuniMandals;
      } else if (value == 'Prathipadu/ప్రత్తిపాడు') {
        return prathipaduMandals;
      } else if (value == 'Pithapuram/పిఠాపురం') {
        return pithapuramMandals;
      } else if (value == 'Kakinada Rural/కాకినాడ గ్రామీణ') {
        return kkdRuralMandals;
      } else if (value == 'Peddapuram/పెద్దాపురం') {
        return peddapuramMandals;
      } else if (value == 'Kakinada City/కాకినాడ నగరం') {
        return kkdCityMandals;
      } else if (value == 'Jaggampeta/జగ్గంపేట') {
        return jaggampetaMandals;
      } else if (value == 'Ramachandrapuram/రామచంద్రపురం') {
        return rcpmMandals;
      } else if (value == 'Mummidivaram/ముమ్మిడివరం') {
        return mummidivaramMandals;
      } else if (value == 'Amalapuram/అమలాపురం') {
        return amalapuramMandals;
      } else if (value == 'Razole/రజోల్') {
        return razoleMandals;
      } else if (value == 'Gannavaram (konaseema)/గన్నవరం') {
        return gannavaramKSMandals;
      } else if (value == 'Kothapeta/కొత్తపేట') {
        return kothapetaMandals;
      } else if (value == 'Mandapeta/మండపేట') {
        return mandapetaMandals;
      } else if (value == 'Gannavaram/గన్నవరం') {
        return gannavaramMandals;
      } else if (value == 'Gudivada/గుడివాడ') {
        return gudivadaMandals;
      } else if (value == 'Pedana/పెడన') {
        return pedanaMandals;
      } else if (value == 'Machilipatnam/మచిలీపట్నం') {
        return machilipatnamMandals;
      } else if (value == 'Avanigadda/అవనిగడ్డ') {
        return avanigaddaMandals;
      } else if (value == 'Pamarru/పామర్రు') {
        return pamarruMandals;
      } else if (value == 'Penamaluru/పెనమలూరు') {
        return penamaluruMandals;
      } else if (value == 'Kurnool/కర్నూలు') {
        return kurnoolMandals;
      } else if (value == 'Pattikonda/పత్తికొండ') {
        return pattikondaMandals;
      } else if (value == 'Kodumur/కోడుమూరు') {
        return kodumurMandals;
      } else if (value == 'Yemmiganur/యెమ్మిగనూరు') {
        return yemmiagnurMandals;
      } else if (value == 'Mantralayam/మంత్రాలయం') {
        return matralayamMandals;
      } else if (value == 'Adoni/ఆదోని') {
        return adoniMandals;
      } else if (value == 'Alur/ఆలూర్') {
        return alurMandals;
      } else if (value == 'Palakonda/పాలకొండ') {
        return palakondaMandals;
      } else if (value == 'Kurupam/కురుపాం') {
        return kurupamMandals;
      } else if (value == 'Parvathipuram/పార్వతీపురం') {
        return parvathipuramMandals;
      } else if (value == 'Salur/సాలూరు') {
        return salurMandals;
      } else {
        return ['Please select your Assembly Constituency'];
      }
    } else {
      return ['Please select your Assembly Constituency'];
    }
  }

  String setAcID(String value) {
    if (value.isNotEmpty && value != 'Please select your District' ||
        value != 'Please select your Assembly Constituency') {
      if (value == 'Araku Valley/అరకు లోయ') {
        return "359";
      } else if (value == 'Paderu/పాడేరు') {
        return "139";
      } else if (value == 'Rampachodavaram/రంపచోడవరం') {
        return "306";
      } else if (value == 'Chodavaram/చోడవరం') {
        return "134";
      } else if (value == 'Madugula/మాడుగుల') {
        return "136";
      } else if (value == 'Anakapalle/అనకాపల్లి') {
        return "133";
      } else if (value == 'Pendurthi/పెందుర్తి') {
        return "141";
      } else if (value == 'Elamanchili/ఎలమంచిలి') {
        return "135";
      } else if (value == 'Payakaraopet/పాయకరావుపేట') {
        return "140";
      } else if (value == 'Narsipatnam/నర్సీపట్నం') {
        return "137";
      } else if (value == 'Rayadurg/రాయదుర్గ్') {
        return "276";
      } else if (value == 'Uravakonda/ఉరవకొండ') {
        return "279";
      } else if (value == 'Guntakal/గుంతకల్') {
        return "297";
      } else if (value == 'Tadipatri/తాడిపత్రి') {
        return "278";
      } else if (value == 'Singanamala/సింగనమల') {
        return "277";
      } else if (value == 'Anantapur Urban/అనంతపూర్ అర్బన్') {
        return "298";
      } else if (value == 'Kalyandurg/కళ్యాణదుర్గ్') {
        return "272";
      } else if (value == 'Raptadu/రాప్తాడు') {
        return "299";
      } else if (value == 'Vemuru/వేమూరు') {
        return "217";
      } else if (value == 'Repalle/రేపల్లె') {
        return "213";
      } else if (value == 'Bapatla/బాపట్ల') {
        return "209";
      } else if (value == 'Parchur/పర్చూరు') {
        return "228";
      } else if (value == 'Addanki/అద్దంకి') {
        return "218";
      } else if (value == 'Chirala/చీరాల') {
        return "219";
      } else if (value == 'Rajampeta/రాజంపేట') {
        return "252";
      } else if (value == 'Kodur/కోడూరు') {
        return "246";
      } else if (value == 'Rayachoti/రాయచోటి') {
        return "248";
      } else if (value == 'Thamballapalle/తంబళ్లపల్లె') {
        return "290";
      } else if (value == 'Pileru/పీలేరు') {
        return "285";
      } else if (value == 'Madanapalle/మదనపల్లె') {
        return "294";
      } else if (value == 'Punganur/పుంగనూరు') {
        return "286";
      } else if (value == 'Nagari/నగరి') {
        return "283";
      } else if (value == 'Gangadhara Nellore/గంగాధర  నెల్లూరు') {
        return "301";
      } else if (value == 'Chittoor/చిత్తూర్') {
        return "281";
      } else if (value == 'Puthalapattu/పూతలపట్టు') {
        return "302";
      } else if (value == 'palamaner/పలమనేరు') {
        return "284";
      } else if (value == 'Kuppam/కుప్పం') {
        return "284";
      } else if (value == 'Anaparthy/అనపర్తి') {
        return "147";
      } else if (value == 'Rajanagaram/రాజానగరం') {
        return "303";
      } else if (value == 'Rajamundry City/రాజమండ్రి సిటీ') {
        return "304";
      } else if (value == 'Rajahmundry Rural/రాజమండ్రి గ్రామీణ') {
        return "305";
      } else if (value == 'Kovvur/కొవ్వూరు') {
        return "172";
      } else if (value == 'Nidadavole/నిడదవోలే') {
        return "366";
      } else if (value == 'Gopalapuram/గోపాలపురం') {
        return "171";
      } else if (value == 'Unguturu/ఉంగుటూరు') {
        return "180";
      } else if (value == 'Denduluru/దెందులూరు') {
        return "169";
      } else if (value == 'Eluru/ఏలూరు') {
        return "170";
      } else if (value == 'Polavaram/పోలవరం') {
        return "176";
      } else if (value == 'Chintalapudi/చింతలపూడి') {
        return "168";
      } else if (value == 'Nuzvid/నూజివీడు') {
        return "193";
      } else if (value == 'Kaikalur/కైకలూరు') {
        return "187";
      } else if (value == 'Tadikonda/తాడికొండ') {
        return "215";
      } else if (value == 'Mangalagiri/మంగళగిరి') {
        return "206";
      } else if (value == 'Ponnuru/పొన్నూరు') {
        return "211";
      } else if (value == 'Tenali/తెనాలి') {
        return "216";
      } else if (value == 'Prathipadu/ప్రత్తిపాడు') {
        return "157";
      } else if (value == 'Guntur West/గుంటూరు పశ్చిమ') {
        return "312";
      } else if (value == 'Guntur East/గుంటూరు తూర్పు') {
        return "311";
      } else if (value == 'Achanta/ఆచంట') {
        return "181";
      } else if (value == 'Palakollu/పాలకొల్లు') {
        return "174";
      } else if (value == 'Narasapuram/నరసాపురం') {
        return "173";
      } else if (value == 'Bhimavaram/భీమవరం') {
        return "167";
      } else if (value == 'Undi/ఉండీ') {
        return "179";
      } else if (value == 'Tanuku/తణుకు') {
        return "178";
      } else if (value == 'Tadepalligudem/తాడేపల్లిగూడెం') {
        return "177";
      } else if (value == 'Rajam/రాజం') {
        return "353";
      } else if (value == 'Bobbili/బొబ్బిలి') {
        return "122";
      } else if (value == 'Cheepurupalli/చీపురుపల్లి') {
        return "120";
      } else if (value == 'Gajapathinagaram/గజపతినగరం') {
        return "121";
      } else if (value == 'Nellimarla/నెల్లిమర్ల') {
        return "361";
      } else if (value == 'Vizianagaram/విజయనగరం') {
        return "129";
      } else if (value == 'Srungavarapukota/శృంగవరపుకోట') {
        return "127";
      } else if (value == 'Bhimili/భీమిలి') {
        return "368";
      } else if (value == 'Vishakapatnam East/విశాఖపట్నం తూర్పు') {
        return "354";
      } else if (value == 'Vishakapatnam West/విశాఖపట్నం పడమర') {
        return "357";
      } else if (value == 'Vishakapatnam South/విశాఖపట్నం దక్షిణ') {
        return "355";
      } else if (value == 'Vishakapatnam North/విశాఖపట్నం ఉత్తరం') {
        return "356";
      } else if (value == 'Gajuwaka/గాజువాక') {
        return "358";
      } else if (value == 'Gudur/గూడూరు') {
        return "231";
      } else if (value == 'Sullurupeta/సూళ్లూరుపేట') {
        return "237";
      } else if (value == 'Venkatagiri/వెంకటగిరి') {
        return "239";
      } else if (value == 'Chandragiri/చంద్రగిరి') {
        return "280";
      } else if (value == 'Sullurpeta/సూళ్లూరుపేట') {
        return "291";
      } else if (value == 'Srikalahasti/శ్రీకాళహస్తి') {
        return "289";
      } else if (value == 'Sathyavedu/సత్యవేడు') {
        return "288";
      } else if (value == 'Ichchapuram/ఇచ్ఛాపురం') {
        return "111";
      } else if (value == 'Palasa/పలాస') {
        return "352";
      } else if (value == 'Tekkali/టెక్కలి') {
        return "117";
      } else if (value == 'Pathapatnam/పాతపట్నం') {
        return "114";
      } else if (value == 'Srikakulam/శ్రీకాకుళం') {
        return "116";
      } else if (value == 'Amadalavalasa/ఆమదాలవలస') {
        return "108";
      } else if (value == 'Etcherla/ఎచ్చెర్ల') {
        return "109";
      } else if (value == 'Narasannapeta/నరసన్నపేట') {
        return "112";
      } else if (value == 'Madakasira/మడకశిర') {
        return "273";
      } else if (value == 'Hindupur/హిందూపూర్') {
        return "270";
      } else if (value == 'Penukonda/పెనుకొండ') {
        return "275";
      } else if (value == 'Puttaparthi/పుట్టపర్తి') {
        return "300";
      } else if (value == 'Dharmavaram/ధర్మవరం') {
        return "267";
      } else if (value == 'Kadiri/కదిరి') {
        return "271";
      } else if (value == 'Yerragondapalem/యర్రగొండపాలెం') {
        return "344";
      } else if (value == 'Darsi/దర్శి') {
        return "221";
      } else if (value == 'Santhanuthalapadu/సంతనూతలపాడు') {
        return "229";
      } else if (value == 'Ongole/ఒంగోలు') {
        return "227";
      } else if (value == 'Kondapi/కొండపి') {
        return "225";
      } else if (value == 'Markapuram/మార్కాపురం') {
        return "226";
      } else if (value == 'Giddalur/గిద్దలూరు') {
        return "222";
      } else if (value == 'Kanigiri/కనిగిరి') {
        return "224";
      } else if (value == 'Pedakurapadu/పెదకూరపాడు') {
        return "210";
      } else if (value == 'Chilakaluripeta/చిలకలూరిపేట') {
        return "199";
      } else if (value == 'Narasaraopet/నరసరావుపేట') {
        return "208";
      } else if (value == 'Sattenapalle/సత్తెనపల్లె') {
        return "214";
      } else if (value == 'Vinukonda/వినుకొండ') {
        return "207";
      } else if (value == 'Gurajala/గురజాల') {
        return "203";
      } else if (value == 'Macherla/మాచర్ల') {
        return "205";
      } else if (value == 'Tiruvuru/తిరువూరు') {
        return "194";
      } else if (value == 'Vijayawada West/విజయవాడ పడమర') {
        return "196";
      } else if (value == 'Vijayawada Central/విజయవాడ సెంట్రల్') {
        return "331";
      } else if (value == 'Vijayawada East/విజయవాడ తూర్పు') {
        return "195";
      } else if (value == 'Mylavaram/మైలవరం') {
        return "191";
      } else if (value == 'Nandigama/నందిగామ') {
        return "192";
      } else if (value == 'Jaggayyapeta/జగ్గయ్యపేట') {
        return "186";
      } else if (value == 'Kandukur/కందుకూరు') {
        return "223";
      } else if (value == 'Kavali/కావలి') {
        return "232";
      } else if (value == 'Atmakur/ఆత్మకూర్') {
        return "241";
      } else if (value == 'Kovur/కోవూరు') {
        return "233";
      } else if (value == 'Nellore City/నెల్లూరు సిటీ') {
        return "340";
      } else if (value == 'Nellore Rural/నెల్లూరు రూరల్') {
        return "341";
      } else if (value == 'Sarvepalli/సర్వేపల్లి') {
        return "236";
      } else if (value == 'Udayagiri/ఉదయగిరి') {
        return "238";
      } else if (value == 'Allagadda/ఆళ్లగడ్డ') {
        return "254";
      } else if (value == 'Srisailam/శ్రీశైలం') {
        return "332";
      } else if (value == 'Nandikotkur/నందికొట్కూరు') {
        return "261";
      } else if (value == 'Panyam/పాణ్యం') {
        return "263";
      } else if (value == 'Nandyal/నంద్యాల') {
        return "262";
      } else if (value == 'Banaganapalle/బనగానపల్లె') {
        return "333";
      } else if (value == 'Dhone/ధోన్') {
        return "257";
      } else if (value == 'Badvel/బద్వేల్') {
        return "242";
      } else if (value == 'Kadapa/కడప') {
        return "243";
      } else if (value == 'Pulivendla/పులివెందుల') {
        return "251";
      } else if (value == 'Kamalapuram/కమలాపురం') {
        return "245";
      } else if (value == 'Jammalamadugu/జమ్మలమడుగు') {
        return "244";
      } else if (value == 'Mydukur/మైదుకూరు') {
        return "249";
      } else if (value == 'Proddatur/ప్రొద్దుటూరు') {
        return "250";
      } else if (value == 'Tuni/తుని') {
        return "163";
      } else if (value == 'Prathipadu/ప్రత్తిపాడు' &&
          sDistrcts == "Kakinada/కాకినాడ") {
        return "212";
      } else if (value == 'Pithapuram/పిఠాపురం') {
        return "156";
      } else if (value == 'Kakinada Rural/కాకినాడ గ్రామీణ') {
        return "307";
      } else if (value == 'Peddapuram/పెద్దాపురం') {
        return "155";
      } else if (value == 'Kakinada City/కాకినాడ నగరం') {
        return "308";
      } else if (value == 'Jaggampeta/జగ్గంపేట') {
        return "149";
      } else if (value == 'Ramachandrapuram/రామచంద్రపురం') {
        return "159";
      } else if (value == 'Mummidivaram/ముమ్మిడివరం') {
        return "153";
      } else if (value == 'Amalapuram/అమలాపురం') {
        return "146";
      } else if (value == 'Razole/రజోల్') {
        return "160";
      } else if (value == 'Gannavaram (konaseema)/గన్నవరం') {
        return "310";
      } else if (value == 'Kothapeta/కొత్తపేట') {
        return "152";
      } else if (value == 'Mandapeta/మండపేట') {
        return "309";
      } else if (value == 'Gannavaram/గన్నవరం') {
        return "185";
      } else if (value == 'Gudivada/గుడివాడ') {
        return "185";
      } else if (value == 'Pedana/పెడన') {
        return "327";
      } else if (value == 'Machilipatnam/మచిలీపట్నం') {
        return "328";
      } else if (value == 'Avanigadda/అవనిగడ్డ') {
        return "182";
      } else if (value == 'Pamarru/పామర్రు') {
        return "329";
      } else if (value == 'Penamaluru/పెనమలూరు') {
        return "330";
      } else if (value == 'Kurnool/కర్నూలు') {
        return "260";
      } else if (value == 'Pattikonda/పత్తికొండ') {
        return "264";
      } else if (value == 'Kodumur/కోడుమూరు') {
        return "258";
      } else if (value == 'Yemmiganur/యెమ్మిగనూరు') {
        return "265";
      } else if (value == 'Mantralayam/మంత్రాలయం') {
        return "334";
      } else if (value == 'Adoni/ఆదోని') {
        return "253";
      } else if (value == 'Alur/ఆలూర్') {
        return "255";
      } else if (value == 'Palakonda/పాలకొండ') {
        return "113";
      } else if (value == 'Kurupam/కురుపాం') {
        return "360";
      } else if (value == 'Parvathipuram/పార్వతీపురం') {
        return "125";
      } else if (value == 'Salur/సాలూరు') {
        return "125";
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  String setZone(String value) {
    if (value == "Anakapalli" ||
        value == 'Araku' ||
        value == 'Srikakulam' ||
        value == 'Vizianagaram' ||
        value == 'Visakhapatnam') {
      return "Zone 1";
    } else if (value == 'Rajahmundry' ||
        value == 'Narsapuram' ||
        value == 'Amalapuram' ||
        value == 'Kakinada' ||
        value == 'Eluru') {
      return "Zone 2";
    } else if (value == 'Vijayawada' ||
        value == 'Machilipatnam' ||
        value == 'Guntur' ||
        value == 'Narsaraopeta' ||
        value == 'Bapatla') {
      return "Zone 3";
    } else if (value == 'Ongole' ||
        value == 'Tirupathi' ||
        value == 'Rajampet' ||
        value == 'Nellore' ||
        value == 'Chittoor') {
      return "Zone 4";
    } else if (value == "Kurnool" ||
        value == 'Nandyal' ||
        value == 'Kadapa' ||
        value == 'Anantapur' ||
        value == 'Hindupur') {
      return "Zone 5";
    } else {
      return "";
    }
  }

  String setPC(String value) {
    if (value == "Anakapalli/అనకాపల్లి" ||
        value == "Chodavaram/చోడవరం" ||
        value == "Madugula/మాడుగుల" ||
        value == "Narsipatnam/నర్సీపట్నం" ||
        value == "Payakaraopeta/పాయకరావుపేట" ||
        value == "Pendurthi/పెందుర్తి" ||
        value == "Elamanchili/ఎలమంచిలి") {
      return "Anakapalli";
    } else if (value == "Araku/అరకు" ||
        value == "Araku Valley/అరకు లోయ" ||
        value == "vKurupam/కురుపాం" ||
        value == "Paderu/పాడేరు" ||
        value == "Palakonda/పాలకొండ" ||
        value == "Parvathipuram/పార్వతీపురం" ||
        value == "Rampachodavaram/రంపచోడవరం" ||
        value == "salur/సాలూరు") {
      return "Araku";
    } else if (value == "Srikakulam/శ్రీకాకుళం" ||
        value == "Amadalavalasa/ఆమదాలవలస" ||
        value == "Ichapuram/ఇచ్చాపురం" ||
        value == "Narasannapeta/నరసన్నపేట" ||
        value == "Palasa/పలాస" ||
        value == "Pathapatnam/పాతపట్నం" ||
        value == "Srikakulam/శ్రీకాకుళం" ||
        value == "Tekkali/టెక్కలి") {
      return "Srikakulam";
    } else if (value == "Vizianagaram/విజయనగరం" ||
        value == "Bobbili/బొబ్బిలి" ||
        value == "Cheepurupalli/చీపురుపల్లి" ||
        value == "Etcherla/ఎచ్చెర్ల" ||
        value == "Gajapathinagaram/గజపతినగరం" ||
        value == "Nellimarla/నెల్లిమర్ల" ||
        value == "Rajam/రాజం" ||
        value == "Vizianagaram/విజయనగరం") {
      return "Vizianagaram";
    } else if (value == "Visakhapatnam/విశాఖపట్నం" ||
        value == "Bhimili/భీమిలి" ||
        value == "Gajuwaka/గాజువాక" ||
        value == "Vishakapatnam East/విశాఖపట్నం తూర్పు" ||
        value == "Visakhapatnam North/విశాఖపట్నం ఉత్తరం " ||
        value == "Visakhapatnam South/విశాఖపట్నం దక్షిణ" ||
        value == "Visakhapatnam West/విశాఖపట్నం పడమర" ||
        value == 'Srungavarapukota/శృంగవరపుకోట') {
      return "Visakhapatnam";
    }
    else if (value == "Rajahmundry/రాజమండ్రి" ||
        value == "Rajamundry City/రాజమండ్రి సిటీ" ||
        value == "Rajahmundry Rural/రాజమండ్రి గ్రామీణ" ||
        value == "Rajanagaram/రాజానగరం" ||
        value == "Anaparthy/అనపర్తి" ||
        value == "Nidadavole/నిడదవోలే" ||
        value == "Gopalapuram/గోపాలపురం" ||
        value == "Kovvur/కొవ్వూరు") {
      return "Rajahmundry";
    } else if (value == "Narasapuram/నరసాపురం" ||
        value == "Narasapur/నరసపూర్" ||
        value == "Tadepalligudem/తాడేపల్లిగూడెం" ||
        value == "Achanta/ఆచంట" ||
        value == 'Tanuku/తణుకు' ||
        value == "Bhimavaram/భీమవరం" ||
        value == "Palakollu/పాలకొల్లు" ||
        value == "Undi/ఉండీ") {
      return "Narsapuram";
    } else if (value == "Amalapuram/అమలాపురం" ||
        value == "Ramachandrapuram/రామచంద్రపురం" ||
        value == "Amalapuram/అమలాపురం" ||
        value == "Mandapeta/మండపేట" ||
        value == "Kothapeta/కొత్తపేట" ||
        value == "Razole/రజోల్" ||
        value == "Mummidivaram/ముమ్మిడివరం" ||
        value == "Gannavaram (konaseema)/గన్నవరం") {
      return "Amalapuram";
    } else if (value == "Kakinada/కాకినాడ" ||
        value == "Kakinada City/కాకినాడ నగరం" ||
        value == "Kakinada Rural/కాకినాడ గ్రామీణ" ||
        value == "Prathipadu/ప్రత్తిపాడు" ||
        value == "Pithapuram/పిఠాపురం" ||
        value == "Jaggampeta/జగ్గంపేట" ||
        value == "Peddapuram/పెద్దాపురం" ||
        value == "Tuni/తుని") {
      return "Kakinada";
    } else if (value == "Eluru/ఏలూరు" ||
        value == "Unguturu/ఉంగుటూరు" ||
        value == "Polavaram/పోలవరం" ||
        value == "Nuzvid/నూజివీడు" ||
        value == "Chintalapudi/చింతలపూడి" ||
        value == "Kaikalur/కైకలూరు" ||
        value == "Dendulur/దెందులూరు" ||
        value == "Eluru/ఏలూరు") {
      return "Eluru";
    } else if (value == "Vijayawada/విజయవాడ" ||
        value == "Vijayawada East/విజయవాడ తూర్పు" ||
        value == "Vijayawada West/విజయవాడ పడమర" ||
        value == "Vijayawada Central/విజయవాడ సెంట్రల్" ||
        value == "Tiruvuru/తిరువూరు" ||
        value == "Jaggayyapeta/జగ్గయ్యపేట" ||
        value == "Nandigama/నందిగామ" ||
        value == "Mylavaram/మైలవరం") {
      return "Vijayawada";
    } else if (value == "Machilipatnam/మచిలీపట్నం" ||
        value == "Gudivada/గుడివాడ" ||
        value == "Penamaluru/పెనమలూరు" ||
        value == "Machilipatnam/మచిలీపట్నం" ||
        value == "Avanigadda/అవనిగడ్డ" ||
        value == "Pedana/పెడన" ||
        value == "Gannavaram/గన్నవరం" ||
        value == "Pamarru/పామర్రు ") {
      return "Machilipatnam";
    } else if (value == "Guntur/గుంటూరు" ||
        value == "Guntur West/గుంటూరు పశ్చిమ" ||
        value == "Guntur East/గుంటూరు తూర్పు" ||
        value == "Mangalagiri/మంగళగిరి" ||
        value == "Prathipadu/ప్రత్తిపాడు" ||
        value == "Tadikonda/తాడికొండ" ||
        value == "Tenali/తెనాలి" ||
        value == "Narasaraopet/నరసరావుపేట") {
      return "Guntur";
    } else if (value == "Narasaraopet/నరసరావుపేట" ||
        value == "Gurzala/గురజాల" ||
        value == "Narasaraopet/నరసరావుపేట" ||
        value == "Vinukonda/వినుకొండ" ||
        value == "Sattenapalle/సత్తెనపల్లె" ||
        value == "Macherla/మాచర్ల" ||
        value == "Chilakaluripeta/చిలకలూరిపేట" ||
        value == "Pedakurapadu/పెదకూరపాడు") {
      return "Narasaraopeta";
    } else if (value == "Bapatla/బాపట్ల" ||
        value == "Chirala/చీరాల" ||
        value == "Repalle/రేపల్లె" ||
        value == "Addanki/అద్దంకి" ||
        value == "Parchur/పర్చూరు" ||
        value == "Santhanuthalapadu/సంతనూతలపాడు" ||
        value == "Bapatla/బాపట్ల" ||
        value == "Vemuru/వేమూరు") {
      return "Bapatla";
    } else if (value == "Ongole/ఒంగోలు" ||
        value == "Darsi/దర్శి" ||
        value == "Kondapi/కొండపి" ||
        value == "Yerragondapalem/యర్రగొండపాలెం" ||
        value == "Giddalur/గిద్దలూరు" ||
        value == "Kanigiri/కనిగిరి" ||
        value == "Markapuram/మార్కాపురం" ||
        value == "Ongole/ఒంగోలు") {
      return "Ongole";
    } else if (value == "Tirupathi/తిరుపతి" ||
        value == "Tirupati/తిరుపతి" ||
        value == "Sullurpeta/సూళ్లూరుపేట" ||
        value == "Sarvepalli/సర్వేపల్లి" ||
        value == "Venkatagiri/వెంకటగిరి" ||
        value == "Srikalahasti/శ్రీకాళహస్తి" ||
        value == "Gudur/గూడూరు" ||
        value == "Satyavedu/సత్యవేడు") {
      return "Tirupathi";
    } else if (value == "Nellore/నెల్లూరు" ||
        value == "Nellore City/నెల్లూరు సిటీ" ||
        value == "Kavali/కావలి" ||
        value == "Kandukur/కందుకూరు" ||
        value == "Kovur/కోవూరు" ||
        value == "Nellore Rural/నెల్లూరు రూరల్" ||
        value == "Udayagiri/ఉదయగిరి" ||
        value == "Atmakur/ఆత్మకూర్") {
      return "Nellore";
    } else if (value == "Chittoor/చిత్తూర్" ||
        value == "Chittoor/చిత్తూర్" ||
        value == "Nagari/నగరి" ||
        value == "Gangadhara Nellore/గంగాధర  నెల్లూరు" ||
        value == "Puthalapattu/పూతలపట్టు" ||
        value == "palamaner/పలమనేరు" ||
        value == "Kuppam/కుప్పం" ||
        value == "Chandragiri/చంద్రగిరి") {
      return "Chittoor";
    } else if (value == "Kurnool/కర్నూలు" ||
        value == "Kurnool/కర్నూలు" ||
        value == "Pattikonda/పత్తికొండ" ||
        value == "Kodumur/కోడుమూరు" ||
        value == "Yemmiganur/యెమ్మిగనూరు" ||
        value == "Mantralayam/మంత్రాలయం" ||
        value == "Adoni/ఆదోని" ||
        value == "Alur/ఆలూర్") {
      return "Kurnool";
    } else if (value == "Nandyal/నంద్యాల" ||
        value == "Nandyal/నంద్యాల" ||
        value == "Panyam/పాణ్యం" ||
        value == "Nandikotkur/నందికొట్కూరు" ||
        value == "Allagadda/ఆళ్లగడ్డ" ||
        value == "Dhone/ధోన్" ||
        value == "Srisailam/శ్రీశైలం" ||
        value == "Banaganapalle/బనగానపల్లె") {
      return "Nandyal";
    } else if (value == "Kadapa/కడప" ||
        value == "Kadapa/కడప" ||
        value == "Badvel/బద్వేల్" ||
        value == "Kamalapuram/కమలాపురం" ||
        value == "Mydukur/మైదుకూరు" ||
        value == "Jammalamadugu/జమ్మలమడుగు" ||
        value == "Pulivendla/పులివెందుల" ||
        value == "Proddatur/ప్రొద్దుటూరు") {
      return "Kadapa";
    } else if (value == "Anantapur/అనంతపురం" ||
        value == "Anantapur Urban/అనంతపూర్ అర్బన్" ||
        value == "Guntakal/గుంతకల్" ||
        value == "Kalyandurg/కళ్యాణదుర్గ్" ||
        value == "Rayadurg/రాయదుర్గ్" ||
        value == "Singanamala/సింగనమల" ||
        value == "Tadipatri/తాడిపత్రి" ||
        value == "Uravakonda/ఉరవకొండ") {
      return "Anantapur";
    } else if (value == "Hindupur/హిందూపూర్" ||
        value == "Hindupur/హిందూపూర్" ||
        value == "Penukonda/పెనుకొండ" ||
        value == "Puttaparthi/పుట్టపర్తి" ||
        value == "Kadiri/కదిరి" ||
        value == "Dharmavaram/ధర్మవరం" ||
        value == "Raptadu/రాప్తాడు" ||
        value == "Madakasira/మడకశిర") {
      return "Hindupur";
    } else {
      return "";
    }
  }

  List<String> districts = <String>[
    'Select the district',
    'Alluri Sitharama Raju/అల్లూరి సీతారామ రాజు',
    'Anakapalli/అనకాపల్లి',
    'Anantapuramu/అనంతపురము',
    'Annamayya/అన్నమయ్య',
    'Bapatla/బాపట్ల',
    'Chittoor/చిత్తూరు',
    'Dr. B. R. Ambedkar Konaseema/డా.బి.ఆర్.అంబేద్కర్ కోనసీమ',
    'East Godavari/తూర్పు గోదావరి',
    'Eluru/ఏలూరు',
    'Guntur/గుంటూరు',
    'Kadapa/కడప',
    'Kakinada/కాకినాడ',
    'Krishna/కృష్ణ',
    'Kurnool/కర్నూలు',
    'Nandyal/నంద్యాల',
    'Nellore/నెల్లూరు',
    'NTR/ఎన్టీఆర్',
    'Palnadu/పల్నాడు',
    'Parvathipuram Manyam/పార్వతీపురం మన్యం',
    'Prakasam/ప్రకాశం',
    'Sri Sathya Sai/శ్రీ సత్యసాయి',
    'Srikakulam/శ్రీకాకుళం',
    'Tirupati/తిరుపతి',
    'Visakhapatnam/విశాఖపట్నం',
    'Vizianagaram/విజయనగరం',
    'West Godavari/పశ్చిమ గోదావరి',
  ];

  List<String> asRaju = [
    'please select the Assembly Constituency',
    'Araku Valley/అరకు లోయ',
    'Paderu/పాడేరు',
    'Rampachodavaram/రంపచోడవరం'
  ];

  List<String> anakapalli = [
    'please select the Assembly Constituency',
    'Chodavaram/చోడవరం',
    'Madugula/మాడుగుల',
    'Anakapalle/అనకాపల్లి',
    'Pendurthi/పెందుర్తి',
    'Elamanchili/ఎలమంచిలి',
    'Payakaraopet/పాయకరావుపేట',
    'Narsipatnam/నర్సీపట్నం'
  ];

  List<String> anatapur = [
    'please select the Assembly Constituency',
    'Rayadurg/రాయదుర్గ్',
    'Uravakonda/ఉరవకొండ',
    'Guntakal/గుంతకల్',
    'Tadipatri/తాడిపత్రి',
    'Singanamala/సింగనమల',
    'Anantapur Urban/అనంతపూర్ అర్బన్',
    'Kalyandurg/కళ్యాణదుర్గ్',
    'Raptadu/రాప్తాడు'
  ];
  List<String> bapatla = [
    'please select the Assembly Constituency',
    'Vemuru/వేమూరు',
    'Repalle/రేపల్లె ',
    'Bapatla/బాపట్ల',
    'Parchur/పర్చూరు',
    'Addanki/అద్దంకి',
    'Chirala/చీరాల   '
  ];

  List<String> annamayya = [
    'please select the Assembly Constituency',
    'Rajampeta/రాజంపేట',
    'Kodur/కోడూరు',
    'Rayachoti/రాయచోటి',
    'Thamballapalle/తంబళ్లపల్లె',
    'Pileru/పీలేరు',
    'Madanapalle/మదనపల్లె'
  ];

  List<String> chittoor = [
    'please select the Assembly Constituency',
    'Punganur/పుంగనూరు',
    'Nagari/నగరి',
    'Gangadhara Nellore/గంగాధర  నెల్లూరు',
    'Chittoor/చిత్తూర్',
    'Puthalapattu/పూతలపట్టు',
    'palamaner/పలమనేరు',
    'Kuppam/కుప్పం'
  ];

  List<String> eastGodavari = [
    'please select the Assembly Constituency',
    'Anaparthy/అనపర్తి',
    'Rajanagaram/రాజానగరం',
    'Rajamundry City/రాజమండ్రి సిటీ',
    'Rajahmundry Rural/రాజమండ్రి గ్రామీణ',
    'Kovvur/కొవ్వూరు',
    'Nidadavole/నిడదవోలే',
    'Gopalapuram/గోపాలపురం'
  ];
  List<String> eluru = [
    'please select the Assembly Constituency',
    'Unguturu/ఉంగుటూరు',
    'Denduluru/దెందులూరు ',
    'Eluru/ఏలూరు',
    'Polavaram/పోలవరం',
    'Chintalapudi/చింతలపూడి',
    'Nuzvid/నూజివీడు',
    'Kaikalur/కైకలూరు'
  ];

  List<String> guntur = [
    'please select the Assembly Constituency',
    'Tadikonda/తాడికొండ',
    'Mangalagiri/మంగళగిరి',
    'Ponnuru/పొన్నూరు',
    'Tenali/తెనాలి',
    'Prathipadu/ప్రత్తిపాడు',
    'Guntur West/గుంటూరు పశ్చిమ',
    'Guntur East/గుంటూరు తూర్పు'
  ];

  List<String> westGodavari = [
    'please select the Assembly Constituency',
    'Achanta/ఆచంట',
    'Palakollu/పాలకొల్లు',
    'Narasapuram/నరసాపురం',
    'Bhimavaram/భీమవరం',
    'Undi/ఉండీ',
    'Tanuku/తణుకు',
    'Tadepalligudem/తాడేపల్లిగూడెం'
  ];

  List<String> vizianagaram = [
    'please select the Assembly Constituency',
    'Rajam/రాజం',
    'Bobbili/బొబ్బిలి',
    'Cheepurupalli/చీపురుపల్లి',
    'Gajapathinagaram/గజపతినగరం',
    'Nellimarla/నెల్లిమర్ల',
    'Vizianagaram/విజయనగరం',
    'Srungavarapukota/శృంగవరపుకోట'
  ];

  List<String> vishakapatnam = [
    'please select the Assembly Constituency',
    'Bhimili/భీమిలి',
    'Vishakapatnam East/విశాఖపట్నం తూర్పు',
    'Vishakapatnam West/విశాఖపట్నం పడమర',
    'Vishakapatnam South/విశాఖపట్నం దక్షిణ',
    'Vishakapatnam North/విశాఖపట్నం ఉత్తరం',
    'Gajuwaka/గాజువాక'
  ];

  List<String> tirupati = [
    'please select the Assembly Constituency',
    'Gudur/గూడూరు',
    'Sullurupeta/సూళ్లూరుపేట',
    'Venkatagiri/వెంకటగిరి',
    'Chandragiri/చంద్రగిరి',
    'Tirupati/తిరుపతి',
    'Srikalahasti/శ్రీకాళహస్తి',
    'Sathyavedu/సత్యవేడు'
  ];

  List<String> srikakulam = [
    'please select the Assembly Constituency',
    'Ichchapuram/ఇచ్ఛాపురం',
    'Palasa/పలాస',
    'Tekkali/టెక్కలి',
    'Pathapatnam/పాతపట్నం',
    'Srikakulam/శ్రీకాకుళం',
    'Amadalavalasa/ఆమదాలవలస',
    'Etcherla/ఎచ్చెర్ల',
    'Narasannapeta/నరసన్నపేట'
  ];

  List<String> sssai = [
    'please select the Assembly Constituency',
    'Madakasira/మడకశిర',
    'Hindupur/హిందూపూర్',
    'Penukonda/పెనుకొండ',
    'Puttaparthi/పుట్టపర్తి',
    'Dharmavaram/ధర్మవరం',
    'Kadiri/కదిరి'
  ];

  List<String> prakasam = [
    'please select the Assembly Constituency',
    'Yerragondapalem/యర్రగొండపాలెం',
    'Darsi/దర్శి',
    'Santhanuthalapadu/సంతనూతలపాడు',
    'Ongole/ఒంగోలు',
    'Kondapi/కొండపి',
    'Markapuram/మార్కాపురం',
    'Giddalur/గిద్దలూరు',
    'Kanigiri/కనిగిరి'
  ];

  List<String> palnadu = [
    'please select the Assembly Constituency',
    'Pedakurapadu/పెదకూరపాడు',
    'Chilakaluripeta/చిలకలూరిపేట',
    'Narasaraopet/నరసరావుపేట',
    'Sattenapalle/సత్తెనపల్లె',
    'Vinukonda/వినుకొండ',
    'Gurajala/గురజాల',
    'Macherla/మాచర్ల'
  ];

  List<String> ntr = [
    'please select the Assembly Constituency',
    'Tiruvuru/తిరువూరు',
    'Vijayawada West/విజయవాడ పడమర',
    'Vijayawada Central/విజయవాడ సెంట్రల్',
    'Vijayawada East/విజయవాడ తూర్పు',
    'Mylavaram/మైలవరం',
    'Nandigama/నందిగామ',
    'Jaggayyapeta/జగ్గయ్యపేట'
  ];

  List<String> nellore = [
    'please select the Assembly Constituency',
    'Kandukur/కందుకూరు',
    'Kavali/కావలి',
    'Atmakur/ఆత్మకూర్',
    'Kovur/కోవూరు',
    'Nellore City/నెల్లూరు సిటీ',
    'Nellore Rural/నెల్లూరు రూరల్',
    'Sarvepalli/సర్వేపల్లి',
    'Udayagiri/ఉదయగిరి'
  ];

  List<String> nandyal = [
    'please select the Assembly Constituency',
    'Allagadda/ఆళ్లగడ్డ',
    'Srisailam/శ్రీశైలం',
    'Nandikotkur/నందికొట్కూరు',
    'Panyam/పాణ్యం',
    'Nandyal/నంద్యాల',
    'Banaganapalle/బనగానపల్లె',
    'Dhone/ధోన్'
  ];

  List<String> kadapa = [
    'please select the Assembly Constituency',
    'Badvel/బద్వేల్',
    'Kadapa/కడప',
    'Pulivendla/పులివెందుల',
    'Kamalapuram/కమలాపురం',
    'Jammalamadugu/జమ్మలమడుగు',
    'Proddatur/ప్రొద్దుటూరు',
    'Mydukur/మైదుకూరు'
  ];
  List<String> kakinada = [
    'please select the Assembly Constituency',
    'Tuni/తుని',
    'Prathipadu/ప్రత్తిపాడు',
    'Pithapuram/పిఠాపురం',
    'Kakinada Rural/కాకినాడ గ్రామీణ',
    'Peddapuram/పెద్దాపురం',
    'Kakinada City/కాకినాడ నగరం',
    'Jaggampeta/జగ్గంపేట'
  ];
  List<String> konaseema = [
    'please select the Assembly Constituency',
    'Ramachandrapuram/రామచంద్రపురం',
    'Mummidivaram/ముమ్మిడివరం',
    'Amalapuram/అమలాపురం',
    'Razole/రజోల్',
    'Gannavaram (konaseema)/గన్నవరం',
    'Kothapeta/కొత్తపేట',
    'Mandapeta/మండపేట'
  ];
  List<String> krishna = [
    'please select the Assembly Constituency',
    'Gannavaram/గన్నవరం',
    'Gudivada/గుడివాడ',
    'Pedana/పెడన',
    'Machilipatnam/మచిలీపట్నం',
    'Avanigadda/అవనిగడ్డ',
    'Pamarru/పామర్రు',
    'Penamaluru/పెనమలూరు'
  ];
  List<String> kurnool = [
    'please select the Assembly Constituency',
    'Kurnool/కర్నూలు',
    'Pattikonda/పత్తికొండ',
    'Kodumur/కోడుమూరు',
    'Yemmiganur/యెమ్మిగనూరు',
    'Mantralayam/మంత్రాలయం',
    'Adoni/ఆదోని',
    'Alur/ఆలూర్'
  ];
  List<String> manyam = [
    'please select the Assembly Constituency',
    'Palakonda/పాలకొండ',
    'Kurupam/కురుపాం',
    'Parvathipuram/పార్వతీపురం',
    'Salur/సాలూరు'
  ];

  List<String> jammalamaduguMadals = [
    "Peddamudium/పెద్దముడియం",
    "Mylavaram/మైలవరం",
    "Kondapuram/కొండాపురం",
    "Jammalamadugu/జమ్మలమడుగు"
        "Muddanur/ముద్దనూరు"
        "Yerraguntla/యర్రగుంట్ల"
  ];

  List<String> arakuMandals = [
    "please select the mandal",
    "Munchingi Puttu/ముంచింగి పుట్టు",
    "Peda Bayalu/పెడ బయలు",
    "Dumbriguda/డుంబ్రిగూడ",
    "Araku Valley/అరకు లోయ",
    "Ananthagiri/అనంతగిరి",
    "Hukumpeta/హుకుంపేట"
  ];

  List<String> kurupamMandals = [
    "please select the mandal",
    "Komarada/కొమరాడ",
    "Gummalakshmipuram/గుమ్మలక్ష్మీపురం",
    "Kurupam/కురుపాం",
    "Jiyyammavalasa/జియ్యమ్మవలస",
    "Garugubilli/గరుగుబిల్లి"
  ];
  List<String> paderuMandals = [
    "please select the mandal",
    "Paderu/పాడేరు",
    "G.Madugula/జి.మాడుగుల",
    "Chintapalle/చింతపల్లె",
    "Gudem Kotha Veedhi/గూడెం కొత్త వీధి",
    "Koyyuru/కొయ్యూరు"
  ];
  List<String> palakondaMandals = [
    "please select the mandal",
    "Veeraghattam/వీరఘట్టం",
    "Seethampeta/సీతంపేట",
    "Bhamini/భామిని",
    "Palakonda/పాలకొండ",
    "Palakonda Town/పాలకొండ పట్టణం"
  ];
  List<String> parvathipuramMandals = [
    "please select the mandal",
    "Parvathipuram/పార్వతీపురం",
    "Seethanagaram/సీతానగరం",
    "Balijipeta/బలిజిపేట",
    "Parvathipuram Town/పార్వతీపురం టౌన్"
  ];
  List<String> rampochodavaramMandals = [
    "please select the mandal",
    "Kunavaram/కూనవరం",
    "Chintur/చింతూరు",
    "Vararamachandrapuram/వరరామచంద్రపురం",
    "Maredumilli/మారేడుమిల్లి",
    "Devipatnam/దేవీపట్నం",
    "Y. Ramavaram/వై రామవరం",
    "Addateegala/అడ్డతీగల",
    "Rajavommangi/రాజవొమ్మంగి",
    "Gangavaram/గంగవరం",
    "Rampachodavaram/రంపచోడవరం",
    "Nellipaka/నెల్లిపాక"
  ];
  List<String> salurMandals = [
    "please select the mandal",
    "Makkuva/మక్కువ",
    "Salur/సాలూరు",
    "Pachipenta/పాచిపెంట",
    "Mentada/మెంటాడ",
    "Salur Town/సాలూరు పట్టణం"
  ];
  List<String> amadalavalsaMandals = [
    "please select the mandal",
    "Sarubujjili/సరుబుజ్జిలి",
    "Burja/బుర్జా",
    "Amadalavalasa/ఆమదాలవలస",
    "Ponduru/పొందూరు",
    "Amadalavalasa Town/ఆమదాలవలస పట్టణం"
  ];
  List<String> icchapuramMandals = [
    "please select the mandal",
    "Kanchili/కంచిలి",
    "Ichchapuram/ఇచ్ఛాపురం",
    "Kaviti/కవిటి",
    "Sompeta/సోంపేట",
    "Ichchapuram Town/ఇచ్ఛాపురం పట్టణం"
  ];
  List<String> narasannapetaMandals = [
    "please select the mandal",
    "Saravakota/సారవకోట",
    "Jalumuru/జలుమూరు",
    "Narasannapeta/నరసన్నపేట",
    "Polaki/పోలాకి",
  ];
  List<String> palasaMandals = [
    "please select the mandal",
    "Palasa/పలాస",
    "Mandasa/మందస",
    "Vajrapukothuru/వజ్రపుకొత్తూరు",
    "Palasa Kasibugga Town/అలస కాశీబుగ్గ పట్టణం"
  ];
  List<String> pathapatnamMandals = [
    "please select the mandal",
    "Kothuru/కొత్తూరు",
    "Pathapatnam/పాతపట్నం",
    "Meliaputti/మెళియాపుట్టి",
    "Hiramandalam/హిరమండలం",
    "Lakshminarsupeta/లక్ష్మీనర్సుపేట"
  ];
  List<String> srikakulamMandals = [
    "please select the mandal",
    "Gara/గారా",
    "Srikakulam/శ్రీకాకుళం",
    "Srikakulam Town/శ్రీకాకుళం పట్టణం"
  ];
  List<String> tekkaliMandals = [
    "please select the mandal",
    "Nandigam/నందిగాం",
    "Tekkali/టెక్కలి",
    "Santhabommali/సంతబొమ్మాళి",
    "Kotabommali/కోటబొమ్మాళి"
  ];
  List<String> bobbiliMandals = [
    "please select the mandal",
    "Bobbili/బొబ్బిలి",
    "Ramabhadrapuram/రామభద్రపురం",
    "Badangi/బాడంగి",
    "Therlam/తెర్లాం",
    "Bobbili Town/బొబ్బిలి పట్టణం"
  ];
  List<String> chepurupalliMandals = [
    "please select the mandal",
    "Merakamudidam/మెరకముడిదం",
    "Garividi/గరివిడి",
    "Cheepurupalle/చీపురుపల్లె",
    "Gurla/గుర్ల"
  ];
  List<String> etcherlaMandals = [
    "please select the mandal",
    "Ganguvarisigadam/గంగువారిసిగడము",
    "Laveru/లావేరు",
    "Ranastalam/రణస్థలం",
    "Etcherla/ఎచ్చెర్ల"
  ];
  List<String> gajapathinagaramMandals = [
    "please select the mandal",
    "Dattirajeru/దత్తిరాజేరు",
    "Gajapathinagaram/గజపతినగరం",
    "Bondapalle/బొండపల్లె",
    "Gantyada/గంట్యాడ",
    "Jami/జామి"
  ];
  List<String> nellimarlaMandals = [
    "please select the mandal",
    "Nellimarla/నెల్లిమర్ల",
    "Pusapatirega/పూసపాటిరేగ",
    "Denkada/డెంకాడ",
    "Bhogapuram/భోగాపురం",
    "NELLIMARLA Town/నెల్లిమర్ల పట్టణం"
  ];
  List<String> rajamMandals = [
    "please select the mandal",
    "Vangara/వంగర",
    "Regidi Amadalavalasa/రేగిడి ఆమదాలవలస",
    "Santhakaviti/సంతకవిటి",
    "Rajam/రాజం",
    "RAJAM Town/రాజం పట్టణం"
  ];
  List<String> vizianagaramMandals = [
    "please select the mandal",
    "Vizianagaram/విజయనగరం",
    "Vizianagaram Town/విజయనగరం పట్టణం",
    "GVMC,WARD-1/జీవియంసి వార్డ్-1",
    "GVMC,WARD-2/జీవియంసి వార్డ్-2",
    "GVMC,WARD-3/జీవియంసి వార్డ్-3",
    "GVMC,WARD-6/జీవియంసి వార్డ్-6",
    "GVMC,WARD-7/జీవియంసి వార్డ్-7",
    "GVMC,WARD-8/జీవియంసి వార్డ్-8",
    "GVMC,WARD-4/జీవియంసి వార్డ్-4",
    "GVMC,WARD-5/జీవియంసి వార్డ్-4",
    "GVMC,WARD-98/జీవియంసి వార్డ్-98",
  ];
  List<String> bhimiliMandals = [
    "please select the mandal",
    "Anandapuram/ఆనందపురం",
    "Padmanabham/పద్మనాభం",
    "Bheemunipatnam/భీమునిపట్నం",
  ];
  List<String> gajuwakaMandals = [
    "please select the mandal",
    "GVMC,WARD-66/జీవియంసి వార్డ్-66",
    "GVMC,WARD-67/జీవియంసి వార్డ్-67",
    "GVMC,WARD-68/జీవియంసి వార్డ్-68",
    "GVMC,WARD-64/జీవియంసి వార్డ్-64",
    "GVMC,WARD-65/జీవియంసి వార్డ్-65",
    "GVMC,WARD-72/జీవియంసి వార్డ్-72",
    "GVMC,WARD-73/జీవియంసి వార్డ్-73",
    "GVMC,WARD-74/జీవియంసి వార్డ్-74",
    "GVMC,WARD-75/జీవియంసి వార్డ్-75",
    "GVMC,WARD-76/జీవియంసి వార్డ్-76",
    "GVMC,WARD-79/జీవియంసి వార్డ్-79",
    "GVMC,WARD-85/జీవియంసి వార్డ్-85",
    "GVMC,WARD-86/జీవియంసి వార్డ్-86",
    "GVMC,WARD-87/జీవియంసి వార్డ్-87",
    "GVMC,WARD-69/జీవియంసి వార్డ్-69",
    "GVMC,WARD-70/జీవియంసి వార్డ్-70",
    "GVMC,WARD-71/జీవియంసి వార్డ్-70",
  ];
  List<String> srungavarapukotaMandals = [
    "please select the mandal",
    "Srungavarapukota/శృంగవరపుకోట",
    "Vepada/వేపాడ",
    "Lakkavarapukota/లక్కవరపుకోట",
    "Kothavalasa/కొత్తవలస",
    "Jami-2/జామి-2",
  ];
  List<String> vizagEastMandals = [
    "please select the mandal",
    "GVMC/జీవియంసి",
    "GVMC,WARD-09/జీవియంసి వార్డ్-09",
    "GVMC,WARD-10/జీవియంసి వార్డ్-10",
    "GVMC,WARD-15/జీవియంసి వార్డ్-15",
    "GVMC,WARD-16/జీవియంసి వార్డ్-16",
    "GVMC,WARD-17/జీవియంసి వార్డ్-17",
    "GVMC,WARD-18/జీవియంసి వార్డ్-18",
    "GVMC,WARD-19/జీవియంసి వార్డ్-19",
    "GVMC,WARD-20/జీవియంసి వార్డ్-20",
    "GVMC,WARD-21/జీవియంసి వార్డ్-21",
    "GVMC,WARD-22/జీవియంసి వార్డ్-22",
    "GVMC,WARD-23/జీవియంసి వార్డ్-23",
    "GVMC,WARD-28/జీవియంసి వార్డ్-28",
    "GVMC,WARD-11/జీవియంసి వార్డ్-11",
    "GVMC,WARD-12/జీవియంసి వార్డ్-12",
    "GVMC,WARD-13/జీవియంసి వార్డ్-13",
  ];
  List<String> vizagNorthMandals = [
    "please select the mandal",
    "GVMC,WARD-24/జీవియంసి వార్డ్-24",
    "GVMC,WARD-25/జీవియంసి వార్డ్-25",
    "GVMC,WARD-26/జీవియంసి వార్డ్-26",
    "GVMC,WARD-44/జీవియంసి వార్డ్-44",
    "GVMC,WARD-14/జీవియంసి వార్డ్-14",
    "GVMC,WARD-42/జీవియంసి వార్డ్-42",
    "GVMC,WARD-43/జీవియంసి వార్డ్-43",
    "GVMC,WARD-45/జీవియంసి వార్డ్-45",
    "GVMC,WARD-46/జీవియంసి వార్డ్-46",
    "GVMC,WARD-47/జీవియంసి వార్డ్-47",
    "GVMC,WARD-48/జీవియంసి వార్డ్-48",
    "GVMC,WARD-49/జీవియంసి వార్డ్-49",
    "GVMC,WARD-50/జీవియంసి వార్డ్-50",
    "GVMC,WARD-51/జీవియంసి వార్డ్-51",
    "GVMC,WARD-53/జీవియంసి వార్డ్-53",
    "GVMC,WARD-54/జీవియంసి వార్డ్-54",
    "GVMC,WARD-55/జీవియంసి వార్డ్-55",
  ];
  List<String> vizagSouthMandals = [
    "please select the mandal",
    "GVMC,WARD-27/జీవియంసి వార్డ్-27",
    "GVMC,WARD-29/జీవియంసి వార్డ్-29",
    "GVMC,WARD-30/జీవియంసి వార్డ్-30",
    "GVMC,WARD-31/జీవియంసి వార్డ్-31",
    "GVMC,WARD-32/జీవియంసి వార్డ్-32",
    "GVMC,WARD-33/జీవియంసి వార్డ్-33",
    "GVMC,WARD-34/జీవియంసి వార్డ్-34",
    "GVMC,WARD-35/జీవియంసి వార్డ్-35",
    "GVMC,WARD-37/జీవియంసి వార్డ్-37",
    "GVMC,WARD-38/జీవియంసి వార్డ్-38",
    "GVMC,WARD-39/జీవియంసి వార్డ్-39",
    "GVMC,WARD-41/జీవియంసి వార్డ్-41",
    "GVMC,WARD-36/జీవియంసి వార్డ్-36",
  ];
  List<String> vizagWestMandals = [
    "please select the mandal",
    "GVMC,WARD-40/జీవియంసి వార్డ్-40",
    "GVMC,WARD-52/జీవియంసి వార్డ్-52",
    "GVMC,WARD-56/జీవియంసి వార్డ్-56",
    "GVMC,WARD-58/జీవియంసి వార్డ్-58",
    "GVMC,WARD-59/జీవియంసి వార్డ్-59",
    "GVMC,WARD-60/జీవియంసి వార్డ్-60",
    "GVMC,WARD-61/జీవియంసి వార్డ్-61",
    "GVMC,WARD-62/జీవియంసి వార్డ్-62",
    "GVMC,WARD-63/జీవియంసి వార్డ్-63",
    "GVMC,WARD-90/జీవియంసి వార్డ్-90",
    "GVMC,WARD-91/జీవియంసి వార్డ్-91",
    "GVMC,WARD-92/జీవియంసి వార్డ్-92",
    "GVMC,WARD-57/జీవియంసి వార్డ్-57",
  ];
  List<String> anakapalliMandals = [
    "please select the mandal",
    "Anakapalle/అనకాపల్లి",
    "Kasimkota/కాసింకోట",
    "GVMC,WARD-80/జీవియంసి వార్డు-80",
    "GVMC,WARD-81/జీవియంసి వార్డు-81",
    "GVMC,WARD-82/జీవియంసి వార్డు-82",
    "GVMC,WARD-83/జీవియంసి వార్డు-83",
    "GVMC,WARD-84/జీవియంసి వార్డు-84",
  ];
  List<String> chodavaramMandals = [
    "please select the mandal",
    "Rolugunta/రోలుగుంట",
    "Ravikamatham/రావికమతం",
    "Chodavaram/చోడవరం",
    "Butchayyapeta/బుచ్చయ్యపేట"
  ];
  List<String> elamanchiliMandals = [
    "please select the mandal",
    "Yelamanchili Town/ఎలమంచిలి టౌన్",
    "Munagapaka/మునగపాక",
    "Atchutapuram/అచ్యుతాపురం",
    "Yelamanchili/యలమంచిలి",
    "Rambilli/రాంబిల్లి"
  ];
  List<String> madugulaMandals = [
    "please select the mandal",
    "Madugula/మాడుగుల",
    "Cheedikada/చీడికాడ",
    "Devarapalle/దేవరపల్లె",
    "K.Kotapadu/కె.కోటపాడు"
  ];
  List<String> narsipatnamMandals = [
    "please select the mandal",
    "NARSIPATNAM Town/నర్సీపట్నం టౌన్",
    "Nathavaram/నాతవరం",
    "Golugonda/గొలుగొండ",
    "Narsipatnam/నర్సీపట్నం",
    "Makavarapalem/మాకవరపాలెం"
  ];
  List<String> payakaroapetMandals = [
    "please select the mandal",
    "Kotauratla/కోటౌరట్ల",
    "Nakkapalle/నక్కపల్లె",
    "Payakaraopeta/పాయకరావుపేట",
    "S.Rayavaram/ఎస్.రాయవరం"
  ];
  List<String> pendurthiMandals = [
    "please select the mandal",
    "Sabbavaram/సబ్బవరం",
    "Pendurthi/పెందుర్తి",
    "GVMC,WARD-93/జీవియంసి వార్డు-93",
    "GVMC,WARD-94/జీవియంసి వార్డు-94",
    "GVMC,WARD-95/జీవియంసి వార్డు-95",
    "GVMC,WARD-96/జీవియంసి వార్డు-96",
    "GVMC,WARD-97/జీవియంసి వార్డు-97",
    "GVMC,WARD-89/జీవియంసి వార్డు-89",
    "GVMC,WARD-77/జీవియంసి వార్డు-77",
    "GVMC,WARD-78/జీవియంసి వార్డు-78",
    "GVMC,WARD-88/జీవియంసి వార్డు-88",
    "Paravada/పరవాడ"
  ];
  List<String> jaggampetaMandals = [
    "please select the mandal",
    "Gokavaram/గోకవరం",
    "Jaggampeta/జగ్గంపేట",
    "Kirlampudi/కిర్లంపూడి",
    "Gandepalle/గండేపల్లె",
  ];
  List<String> kkdCityMandals = [
    "please select the mandal",
    "Kakinada Town/కాకినాడ టౌన్"
  ];
  List<String> kkdRuralMandals = [
    "please select the mandal",
    "Kakinada (Rural)/కాకినాడ (రూరల్)",
    "Karapa/కరప"
  ];
  List<String> peddapuramMandals = [
    "please select the mandal",
    "Peddapuram/పెద్దాపురం",
    "Samalkota/సామలకోట",
    "Peddapuram Town/పెద్దాపురం టౌన్",
    "Samalkota Town/సామలకోట టౌన్"
  ];
  List<String> pithapuramMandals = [
    "please select the mandal",
    "Gollaprolu/గొల్లప్రోలు",
    "Pithapuram/పిఠాపురం",
    "Kothapalle/కొత్తపల్లె",
    "Pithapuram Town/పిఠాపురం టౌన్",
    "Gollaproplu Town/గొల్లప్రోలు టౌన్"
  ];
  List<String> prathipaduMandals = [
    "please select the mandal",
    "Sankhavaram/శంఖవరం",
    "Yeleswaram/ఏలేశ్వరం",
    "Prathipadu/ప్రత్తిపాడు",
    "Rowthulapudi/రౌతులపూడి",
    "Yeleshwaram Town/ఏలేశ్వరం పట్టణం"
  ];
  List<String> tuniMandals = [
    "please select the mandal",
    "Kotananduru/కోటనందూరు",
    "Tuni/తుని",
    "Thondangi/తొండంగి",
    "Tuni Town/తుని టౌన్"
  ];
  List<String> amalapuramMandals = [
    "please select the mandal",
    "Allavaram/అల్లవరం",
    "Amalapuram/అమలాపురం",
    "Uppalaguptam/ఉప్పలగుప్తం",
    "Amalapuram Town/అమలాపురం టౌన్"
  ];
  List<String> gannavaramKSMandals = [
    "please select the mandal",
    "Ainavilli/అయినవిల్లి",
    "P.Gannavaram/పి.గన్నవరం",
    "Ambajipeta/అంబాజీపేట"
  ];
  List<String> kothapetaMandals = [
    "please select the mandal",
    "Atreyapuram/ఆత్రేయపురం",
    "Alamuru/ఆలమూరు",
    "Ravulapalem/రావులపాలెం",
    "Kothapeta/కొత్తపేట"
  ];
  List<String> mandapetaMandals = [
    "please select the mandal",
    "Mandapeta/మండపేట",
    "Rayavaram/రాయవరం",
    "Kapileswarapuram/కపిలేశ్వరపురం",
    "Mandapeta Town/మండపేట టౌన్"
  ];
  List<String> mummidivaramMandals = [
    "please select the mandal",
    "Thallarevu/తాళ్లరేవు",
    "I.Polavaram/ఐ.పోలవరం",
    "Mummidivaram/ముమ్మిడివరం",
    "Katrenikona/కాట్రేనికోనా"
  ];
  List<String> rcpmMandals = [
    "please select the mandal",
    "Kajuluru/కాజులూరు",
    "Ramachandrapuram/రామచంద్రపురం",
    "K.gangavaram/కె.గంగవరం",
    "Ramachandrapuram Town/రామచంద్రపురం టౌన్"
  ];

  List<String> razoleMandals = [
    "please select the mandal",
    "Mamidikuduru/మామిడికుదురు",
    "Razole/రజోల్",
    "Malikipuram/మలికిపురం",
    "Sakhinetipalle/సఖినేటిపల్లె"
  ];
  List<String> anaparthyMandals = [
    "please select the mandal",
    "Rangampeta/రంగంపేట",
    "Pedapudi/పెదపూడి",
    "Biccavolu/బిక్కవోలు",
    "Anaparthy/అనపర్తి"
  ];
  List<String> gopalapuramMandals = [
    "please select the mandal",
    "Gopalapuram/గోపాలపురం",
    "Dwarakatirumala/ద్వారకాతిరుమల",
    "Nallajerla/నల్లజర్ల",
    "Devarapalle/దేవరపల్లె"
  ];
  List<String> kovvurMandals = [
    "please select the mandal",
    "Tallapudi/తాళ్లపూడి",
    "Kovvur/కొవ్వూరు",
    "Chagallu/చాగల్లు",
    "Kovvur Town/కొవ్వూరు పట్టణం"
  ];
  List<String> nidadavoleMandals = [
    "please select the mandal",
    "Nidadavole/నిడదవోలే",
    "Undrajavaram/ఉండ్రాజవరం",
    "Peravali/పెరవలి",
    "Nidadavole Town/నిడదవోల్ టౌన్"
  ];
  List<String> rjyCityMandals = [
    "please select the mandal",
    "Rajahmundry Town/రాజమండ్రి టౌన్"
  ];
  List<String> rjyRuralMandals = [
    "please select the mandal",
    "Rajahmundry Rural/రాజమండ్రి రూరల్",
    "Kadiam/కడియం"
  ];
  List<String> rajanagaramMandals = [
    "please select the mandal",
    "Seethanagaram/సీతానగరం",
    "Korukonda/కోరుకొండ",
    "Rajanagaram/రాజానగరం"
  ];
  List<String> achantaMandals = [
    "please select the mandal",
    "Penumantra/పెనుమంట్ర",
    "Penugonda/పెనుగొండ",
    "Achanta/ఆచంట",
    "Poduru/పోడూరు"
  ];
  List<String> bhimavaramMandals = [
    "please select the mandal",
    "Veeravasaram/వీరవాసరం",
    "Bhimavaram/భీమవరం",
    "Bhimavaram Town/భీమవరం టౌన్"
  ];
  List<String> narsapurMandals = [
    "please select the mandal",
    "Mogalthur/మొగల్తూరు",
    "Narasapuram/నరసాపురం",
    "Narsapur Town/నర్సాపూర్ టౌన్"
  ];
  List<String> palakolluMandals = [
    "please select the mandal",
    "Palacole/పాలకోల్",
    "Yelamanchili/యలమంచిలి",
    "Palacole Town/పాలకోల్ టౌన్"
  ];
  List<String> tadepalligudemMandals = [
    "please select the mandal",
    "Tadepalligudem/తాడేపల్లిగూడెం",
    "Pentapadu/పెంటపాడు",
    "Tadepalligudem Town/తాడేపల్లిగూడెం పట్టణం"
  ];
  List<String> tanukuMandals = [
    "please select the mandal",
    "Tanuku/తణుకు",
    "Attili/అత్తిలి",
    "Iragavaram/ఇరగవరం",
    "Tanuku Town/తణుకు టౌన్"
  ];
  List<String> undiMandals = [
    "please select the mandal",
    "Akividu/ఆకివీడు",
    "Undi/ఉండీ",
    "Palacoderu/పాలకోడేరు",
    "Kalla/కల్లా",
    "Akividu Town/ఆకివీడు టౌన్"
  ];
  List<String> chintalapudiMandals = [
    "please select the mandal",
    "Chintalapudi/చింతలపూడి",
    "Lingapalem/లింగపాలెం",
    "Jangareddigudem/జంగారెడ్డిగూడెం",
    "Kamavarapukota/కమవరపుకోట",
    "JANGAREDDIGUDEM Town/జంగారెడ్డిగూడెం టౌన్",
    "Chintalapudi Town/చింతలపూడి టౌన్"
  ];
  List<String> dendulurMandals = [
    "please select the mandal",
    "Pedavegi/పెదవేగి",
    "Pedapadu/పెదపాడు",
    "Denduluru/దెందులూరు",
    "Eluru/ఏలూరు"
  ];
  List<String> eluruMandals = ["please select the mandal", 'Eluru Town'];

  List<String> vjyCentralMandals = [
    "please select the mandal",
    "Vijayawada/విజయవాడ",
    "Vijayawada,WARD-23/విజయవాడ, వార్డ్-23",
    "Vijayawada,WARD-24/విజయవాడ, వార్డ్-24",
    "Vijayawada,WARD-25/విజయవాడ, వార్డ్-25",
    "Vijayawada,WARD-26/విజయవాడ, వార్డ్-26",
    "Vijayawada,WARD-27/విజయవాడ, వార్డ్-27",
    "Vijayawada,WARD-28/విజయవాడ, వార్డ్-28",
    "Vijayawada,WARD-29/విజయవాడ, వార్డ్-29",
    "Vijayawada,WARD-30/విజయవాడ, వార్డ్-30",
    "Vijayawada,WARD-31/విజయవాడ, వార్డ్-31",
    "Vijayawada,WARD-32/విజయవాడ, వార్డ్-32",
    "Vijayawada,WARD-33/విజయవాడ, వార్డ్-33",
    "Vijayawada,WARD-36/విజయవాడ, వార్డ్-36",
    "Vijayawada,WARD-1/విజయవాడ, వార్డ్-1",
    "Vijayawada,WARD-57/విజయవాడ, వార్డ్-57",
    "Vijayawada,WARD-58/విజయవాడ, వార్డ్-58",
    "Vijayawada,WARD-59/విజయవాడ, వార్డ్-59",
    "Vijayawada,WARD-60/విజయవాడ, వార్డ్-60",
    "Vijayawada,WARD-61/విజయవాడ, వార్డ్-61",
    "Vijayawada,WARD-62/విజయవాడ, వార్డ్-62",
    "Vijayawada,WARD-63/విజయవాడ, వార్డ్-63",
    "Vijayawada,WARD-64/విజయవాడ, వార్డ్-64",
  ];
  List<String> vjyEastMandals = [
    "please select the mandal",
    "Vijayawada,WARD-2/విజయవాడ, వార్డ్-2",
    "Vijayawada,WARD-3/విజయవాడ, వార్డ్-3",
    "Vijayawada,WARD-4/విజయవాడ, వార్డ్-4",
    "Vijayawada,WARD-6/విజయవాడ, వార్డ్-6",
    "Vijayawada,WARD-7/విజయవాడ, వార్డ్-7",
    "Vijayawada,WARD-8/విజయవాడ, వార్డ్-8",
    "Vijayawada,WARD-9/విజయవాడ, వార్డ్-9",
    "Vijayawada,WARD-10/విజయవాడ, వార్డ్-10",
    "Vijayawada,WARD-11/విజయవాడ, వార్డ్-11",
    "Vijayawada,WARD-12/విజయవాడ, వార్డ్-12",
    "Vijayawada,WARD-13/విజయవాడ, వార్డ్-13",
    "Vijayawada,WARD-14/విజయవాడ, వార్డ్-14",
    "Vijayawada,WARD-15/విజయవాడ, వార్డ్-15",
    "Vijayawada,WARD-16/విజయవాడ, వార్డ్-16",
    "Vijayawada,WARD-17/విజయవాడ, వార్డ్-17",
    "Vijayawada,WARD-18/విజయవాడ, వార్డ్-18",
    "Vijayawada,WARD-22/విజయవాడ, వార్డ్-22",
    "Vijayawada,WARD-5/విజయవాడ, వార్డ్-5",
    "Vijayawada,WARD-19/విజయవాడ, వార్డ్-19",
    "Vijayawada,WARD-20/విజయవాడ, వార్డ్-20",
    "Vijayawada,WARD-21/విజయవాడ, వార్డ్-21",
  ];
  List<String> vjyWestMandals = [
    "please select the mandal",
    "Vijayawada,WARD-34/విజయవాడ, వార్డ్-34",
    "Vijayawada,WARD-35/విజయవాడ, వార్డ్-35",
    "Vijayawada,WARD-37/విజయవాడ, వార్డ్-37",
    "Vijayawada,WARD-38/విజయవాడ, వార్డ్-38",
    "Vijayawada,WARD-39/విజయవాడ, వార్డ్-39",
    "Vijayawada,WARD-40/విజయవాడ, వార్డ్-40",
    "Vijayawada,WARD-41/విజయవాడ, వార్డ్-41",
    "Vijayawada,WARD-48/విజయవాడ, వార్డ్-48",
    "Vijayawada,WARD-49/విజయవాడ, వార్డ్-49",
    "Vijayawada,WARD-50/విజయవాడ, వార్డ్-50",
    "Vijayawada,WARD-42/విజయవాడ, వార్డ్-42",
    "Vijayawada,WARD-43/విజయవాడ, వార్డ్-43",
    "Vijayawada,WARD-44/విజయవాడ, వార్డ్-44",
    "Vijayawada,WARD-45/విజయవాడ, వార్డ్-45",
    "Vijayawada,WARD-46/విజయవాడ, వార్డ్-46",
    "Vijayawada,WARD-47/విజయవాడ, వార్డ్-47",
    "Vijayawada,WARD-51/విజయవాడ, వార్డ్-51",
    "Vijayawada,WARD-52/విజయవాడ, వార్డ్-52",
    "Vijayawada,WARD-53/విజయవాడ, వార్డ్-53",
    "Vijayawada,WARD-54/విజయవాడ, వార్డ్-54",
    "Vijayawada,WARD-55/విజయవాడ, వార్డ్-55",
    "Vijayawada,WARD-56/విజయవాడ, వార్డ్-56",
  ];
  List<String> kaikaluruMandals = [
    "please select the mandal",
    "Mandavalli/మండవల్లి",
    "Kaikalur/కైకలూరు",
    "Kalidindi/కలిదిండి",
    "Mudinepalle/ముదినేపల్లె"
  ];
  List<String> nuzvidMandals = [
    "please select the mandal",
    "Chatrai/చత్రై",
    "Musunuru/ముసునూరు",
    "Nuzvid/నుజ్విద్",
    "Agiripalle/ఆగిరిపల్లె",
    "Nuzvid Town/నుజ్విద్ టౌన్"
  ];
  List<String> polavaramMandals = [
    "please select the mandal",
    "Velairpadu/వేలైర్పాడు",
    "Kukunoor/కుకునూర్",
    "T.Narasapuram/టి.నరసాపురం",
    "Jeelugu Milli/జీలుగు మిల్లి",
    "Buttayagudem/బుట్టాయగూడెం",
    "Polavaram/పోలవరం",
    "Koyyalagudem/కొయ్యలగూడెం"
  ];
  List<String> unguturuMandals = [
    "please select the mandal",
    "Unguturu/ఉంగుటూరు",
    "Bhimadole/భీమడోలు",
    "Nidamarru/నిడమర్రు",
    "Ganapavaram/గణపవరం"
  ];
  List<String> avanigaddaMandals = [
    "please select the mandal",
    "Ghantasala/ఘంటసాల",
    "Challapalle/చల్లపల్లె",
    "Mopidevi/మోపిదేవి",
    "Avanigadda/అవనిగడ్డ",
    "Nagayalanka/నాగాయలంక",
    "Koduru/కోడూరు"
  ];
  List<String> gannavaramMandals = [
    "please select the mandal",
    "Bapulapadu/బాపులపాడు",
    "Vijayawada (Rural)/విజయవాడ (గ్రామీణ)",
    "Gannavaram/గన్నవరం",
    "Unguturu/ఉంగుటూరు"
  ];
  List<String> gudivadaMandals = [
    "please select the mandal",
    "Nandivada/నందివాడ",
    "Gudivada/గుడివాడ",
    "Gudlavalleru/గుడ్లవల్లేరు",
    "Gudivada Town/గుడివాడ టౌన్"
  ];
  List<String> machilipatnamMandals = [
    "please select the mandal",
    "Machilipatnam/మచిలీపట్నం",
    "Machilipatnam Town/మచిలీపట్నం టౌన్"
  ];
  List<String> pamarruMandals = [
    "please select the mandal",
    "Pedaparupudi/పెదపారుపూడి",
    "Thotlavalluru/తోట్లవల్లూరు",
    "Pamidimukkala/పమిడిముక్కల",
    "Pamarru/పామర్రు",
    "Movva/మొవ్వ"
  ];
  List<String> pedanaMandals = [
    "please select the mandal",
    "Kruthivennu/కృతివెన్ను",
    "Bantumilli/బంటుమిల్లి",
    "Pedana/పెదన",
    "Guduru/గూడూరు",
    "Pedana Town/పెడన టౌన్"
  ];
  List<String> penamaluruMandals = [
    "please select the mandal",
    "Kankipadu/కంకిపాడు",
    "Penamaluru/పెనమలూరు",
    "Vuyyuru/వుయ్యూరు",
    "Vuyyuru Town/వుయ్యూరు టౌన్",
    "YSR Tadigadapa/వైఎస్ఆర్ తడిగడప"
  ];
  List<String> jaggayyapetMandals = [
    "please select the mandal",
    "Vatsavai/వత్సవై",
    "Jaggayyapeta/జగ్గయ్యపేట",
    "Penuganchiprolu/పెనుగంచిప్రోలు",
    "Jaggayyapeta Town/జగ్గయ్యపేట టౌన్"
  ];
  List<String> mylavaramMandals = [
    "please select the mandal",
    "Mylavaram/మైలవరం",
    "Reddigudem/రెడ్డిగూడెం",
    "G.Konduru/జి.కొండూరు",
    "Vijayawada (Rural)/విజయవాడ (గ్రామీణ)",
    "Ibrahimpatnam/ఇబ్రహీంపట్నం",
    "Kondapalli/కొండపల్లి"
  ];
  List<String> nandigamaMandals = [
    "please select the mandal",
    "Nandigama/నందిగామ",
    "Veerullapadu/వీరుళ్లపాడు",
    "Kanchikacherla/కంచికచెర్ల",
    "Chandarlapadu/చందర్లపాడు",
    "Nandigama Town/నందిగామ టౌన్"
  ];
  List<String> tiruvuruMandals = [
    "please select the mandal",
    "Gampalagudem/గంపలగూడెం",
    "Tiruvuru/తిరువూరు",
    "A.Konduru/ఏ.కొండూరు",
    "Vissannapet/విస్సన్నపేట్",
    "Tiruvuru Town/తిరువూరు టౌన్"
  ];
  List<String> gunturEastMandals = [
    "please select the mandal",
    "Guntur East/గుంటూరు తూర్పు"
  ];
  List<String> gunturWestMandals = [
    "please select the mandal",
    "Guntur West/గుంటూరు పశ్చిమ"
  ];
  List<String> mangalagiriMandals = [
    "please select the mandal",
    "Tadepalle/తాడేపల్లి",
    "Mangalagiri/మంగళగిరి",
    "Duggirala/దుగ్గిరాల",
    "Mangalagiri Town/మంగళగిరి టౌన్"
  ];
  List<String> ponnurMandals = [
    "please select the mandal",
    "Pedakakani/పెడకాకని",
    "Chebrolu/ చెబ్రోలు",
    "Ponnur/పొన్నూర్",
    "Ponnur Town/  పొన్నూరు టౌన్"
  ];
  List<String> prathipaduGMandals = [
    "please select the mandal",
    "Guntur Rural mandal/గుంటూరు రూరల్ మండల",
    "Kakumanu/కాకుమాను",
    "Prathipadu/ప్రత్తిపాడు",
    "Pedanandipadu/  పెదనందిపాడు",
    "Vatticherukuru/వట్టిచేరుకురు"
  ];
  List<String> tadikondaMandals = [
    "please select the mandal",
    "Thullur/తుల్లూర్",
    "Tadikonda/తడికొండ",
    "Phirangipuram/ఫిరంగిపురం",
    "Medikonduru/మేడికొండూరు"
  ];
  List<String> tenaliMandals = [
    "please select the mandal",
    "Kollipara/కొల్లిపారా",
    "Tenali/  తెనాలి",
    "Tenali Town/తెనాలి టౌన్"
  ];
  List<String> chilakaluripetaMandals = [
    "please select the mandal",
    "Nadendla/నాదేండ్ల",
    "Purushotha Patnam/పురుషోత పట్నం",
    "Edlapadu/ఎడ్లపాడు"
  ];
  List<String> gurajalaMandals = [
    "please select the mandal",
    "Gurazala/గురజాల",
    "Dachepalle/దాచేపల్లె",
    "Piduguralla/పిడుగురాళ్ళ",
    "Machavaram/మాచవరం",
    "Piduguralla Town/ పిడుగురాళ్ళ టౌన్",
    "Gurazala Town/గురజాల టౌన్",
    "Dachepalle Town/దాచేపల్లి టౌన్"
  ];
  List<String> macherlaMandals = [
    "please select the mandal",
    "Macherla/మాచర్ల",
    "Veldurthi/వెల్దుర్తి",
    "Durgi/దుర్గి",
    "Rentachintala/రెంటచింతల",
    "Karempudi/కారెంపూడి",
    "Macherla Town/మాచెర్ల టౌన్"
  ];
  List<String> narasaraopetMandals = [
    "please select the mandal",
    "Rompicherla/రొంపిచెర్ల",
    "Narasaraopet/నరసరావుపేట",
    "Narasaraopet/నరసరావుపేట"
  ];
  List<String> pedakurapaduMandals = [
    "please select the mandal",
    "Bellamkonda/బెల్లంకొండ",
    "Atchampet/అచ్చంపేట్",
    "Krosuru/క్రోసూరు",
    "Amaravathi/అమరావతి",
    "Pedakurapadu/పెదకురపాడు"
  ];
  List<String> sattenapalliMandals = [
    "please select the mandal",
    "Sattenapalle/సత్తెనపల్లి",
    "Rajupalem/రాజుపాలెం",
    "Nekarikallu/నేకరికల్లు",
    "Muppalla/ముప్పల్ల",
    "Sattenapalle Town/సత్తెనపల్లి టౌన్"
  ];
  List<String> vinkuondaMandals = [
    "please select the mandal",
    "Bollapalle/బొల్లపల్లె",
    "Vinukonda/బొల్లపల్లె",
    "Nuzendla/నుజెండ్ల",
    "Savalyapuram HO Kanamarlapudi/సావల్యపురం హో కనమర్లపూడి",
    "Ipur/ఐపూర్",
    "Vinukonda/వినుకొండ"
  ];
  List<String> addankiMandals = [
    "please select the mandal",
    "Santhamaguluru/శాంతమగులూరు",
    "Ballikurava/బల్లికురవ",
    "Janakavarampanguluru/జనకావరంపులూరు",
    "Addanki/అడ్డంకి",
    "Korisapadu/కొరిసపాడు",
    "Addanki Town/అద్దంకి టౌన్"
  ];
  List<String> baptlaMandals = [
    "please select the mandal",
    "Pittalavanipalem/పిట్టలవనిపాలెం",
    "Karlapalem/కర్లపాలెం",
    "Bapatla/బాపట్ల",
    "Bapatla Town/బాపట్ల టౌన్"
  ];
  List<String> chiralaMandals = [
    "please select the mandal",
    "Chirala/చిరాల",
    "Vetapalem/వేటపాలెం",
    "Chirala Town/చీరాల టౌన్"
  ];
  List<String> parchurMandals = [
    "please select the mandal",
    "Martur/మార్టూర్",
    "Yeddana Pudi/యెద్దన పూడి",
    "Parchur/పర్చూర్",
    "Karamchedu/కరంచేడు",
    "Inkollu/ఇంకోళ్లు",
    "Chinaganjam/చినగంజం"
  ];
  List<String> repalleMandals = [
    "please select the mandal",
    "Cherukupalle HO Arumbaka/చెరుకుపల్లి హో అరుంబాక",
    "Nizampatnam/నిజాంపట్నం",
    "Nagaram/నగరం",
    "Repalle/రేపల్లె",
    "Repalle Town/రేపల్లె టౌన్"
  ];
  List<String> snathanuthalapaduMandals = [
    "please select the mandal",
    "Naguluppala Padu/నాగులుప్పల పాడు",
    "Maddipadu/మద్దిపాడు",
    "Chimakurthi/చీమకూర్తి",
    "Santhanuthala Padu/సంతనుతల పాడు",
    "Chimakurthy/చీమకూర్తి"
  ];
  List<String> vemuruMandals = [
    "please select the mandal",
    "Tsundur/త్సుందూర్",
    "Amruthalur/అమృతలూర్",
    "Vemuru/వేమూరు",
    "Kollur/కొల్లూర్",
    "Bhattiprolu/భట్టిప్రోలు"
  ];
  List<String> darsiMandals = [
    "please select the mandal",
    "Donakonda/దొనకొండ",
    "Kurichedu/కురిచేడు",
    "Mundlamuru/ముండ్లమూరు",
    "Darsi/దర్శి",
    "Thallur/తాళ్లూరు",
    "Darsi Town/దర్శి టౌన్",
  ];
  List<String> giddaluruMandals = [
    "please select the mandal",
    "Ardhaveedu/అర్ధవీడు",
    "Cumbum/కంబమ్",
    "Bestawaripeta/బేస్తవారిపేట",
    "Racherla/రాచర్ల",
    "Giddalur/గిద్దలూరు",
    "Komarolu/కొమరోలు",
    "GIDDALUR TOWN/గిద్దలూరు పట్టణం",
  ];
  List<String> kanigiriMandals = [
    "please select the mandal",
    "Hanumanthuni Padu/హనుమంతుని పాడు",
    "Veligandla/వెలిగండ్ల",
    "Kanigiri/కనిగిరి",
    "Pedacherlo Palle/పెదచెర్లో పల్లె",
    "Chandra Sekhara Puram/చంద్ర శేఖర పురం",
    "Pamur/పామూరు",
    "KANIGIRI TOWN/కనిగిరి టౌన్",
  ];
  List<String> kondepiMandals = [
    "please select the mandal",
    "Marripudi/మర్రిపూడి",
    "Kondapi/కొండపి",
    "Tangutur/టంగుటూరు",
    "Zarugumilli/జరుగుమిల్లి",
    "Ponnaluru/పొన్నలూరు",
    "Singarayakonda/సింగరాయకొండ",
  ];
  List<String> markapurMandals = [
    "please select the mandal",
    "Markapur/మార్కాపూర్",
    "Tarlupadu/తర్లుపాడు",
    "Konakanamitla/కొనకనమిట్ల",
    "Podili/పొదిలి",
    "Markapur Town/మార్కాపూర్ టౌన్",
    "Podili Town/పొదిలి టౌన్",
  ];
  List<String> ongoleMandals = [
    "please select the mandal",
    "Ongole/ఒంగోలు",
    "Kotha Patnam/కొత్త పట్నం",
    "Ongole Town/ఒంగోలు పట్టణం",
  ];
  List<String> yerragondapalemMandals = [
    "please select the mandal",
    "Yerragondapalem/యర్రగొండపాలెం",
    "Pullalacheruvu/పుల్లలచెరువు",
    "Tripuranthakam/త్రిపురాంతకం",
    "Dornala/దోర్నాల",
    "Peda Araveedu/పెద అరవీడు",
  ];
  List<String> allagaddaMandals = [
    "please select the mandal",
    "Sirvel/సర్వెల్",
    "Rudravaram/రుద్రవరం",
    "Allagadda/ఆళ్లగడ్డ",
    "Dornipadu/దొర్నిపాడు",
    "Uyyalawada/ఉయ్యాలవాడ",
    "Chagalamarri/చాగలమర్రి",
    "ALLAGADDA Town/ఆళ్లగడ్డ పట్టణం",
  ];
  List<String> banaganapalleMandals = [
    "please select the mandal",
    "Banaganapalle/బనగానపల్లె",
    "Owk/ఓక్",
    "Koilkuntla/కోయిల్‌కుంట్ల",
    "Sanjamala/సంజామాల",
    "Kolimigundla/కొలిమిగుండ్ల",
  ];
  List<String> dhoneMandals = [
    "please select the mandal",
    "Bethamcherla/బేతంచెర్ల",
    "Dhone/ధోన్",
    "Peapally/పీపల్లి",
    "Dhone Town/ధోన్ టౌన్",
    "Bethamcherla Town/బేతంచెర్ల టౌన్",
  ];
  List<String> nandikotkuruMandals = [
    "please select the mandal",
    "Nandikotkur/నందికొట్కూరు",
    "Pagidyala/పగిడ్యాల",
    "Jupadu Bungalow/జూపాడు బంగ్లా",
    "Kothapalle/కొత్తపల్లె",
    "Pamulapadu/పాములపాడు",
    "Midthur/మిడ్తూర్",
    "NANDIKOTKUR TOWN/నందికొట్కూరు పట్టణం",
  ];
  List<String> nandyalMandals = [
    "please select the mandal",
    "Nandyal/నంద్యాల",
    "Gospadu/గోస్పాడు",
    "Nandyal Town/నంద్యాల టౌన్",
  ];
  List<String> panyamMandals = [
    "please select the mandal",
    "Kallur/కల్లూర్",
    "Orvakal/ఓర్వకల్",
    "Panyam/పాణ్యం",
    "Gadivemula/గడివేముల",
  ];
  List<String> srisailamMandals = [
    "please select the mandal",
    "Srisailam/శ్రీశైలం",
    "Atmakur/ఆత్మకూర్",
    "Velgode/వెల్గోడ్",
    "Bandi Atmakur/బండి ఆత్మకూర్",
    "Mahanandi/మహానంది",
    "Atmakuru Town/ఆత్మకూరు టౌన్",
  ];
  List<String> adoniMandals = [
    "please select the mandal",
    "Adoni/ఆదోని",
    "Adoni Town/ఆదోని టౌన్",
  ];
  List<String> alurMandals = [
    "please select the mandal",
    "Holagunda/హొళగుండ",
    "Halaharvi/హాలహర్వి",
    "Alur/ఆలూర్",
    "Aspari/ఆస్పరి",
    "Devanakonda/దేవనకొండ",
    "Chippagiri/చిప్పగిరి",
  ];
  List<String> kodumurMandals = [
    "please select the mandal",
    "C.Belagal/సి.బెళగల్",
    "C Belagala Town/సి బెలగల టౌన్",
    "Gudur/గూడూరు",
    "Kurnool/కర్నూలు",
    "Kodumur/కోడుమూరు",
    "GUDUR Town/గూడూరు పట్టణం"
  ];
  List<String> kurnoolMandals = ["please select the mandal", "Kurnool Town"];
  List<String> matralayamMandals = [
    "please select the mandal",
    "Mantralayam/మంత్రాలయం",
    "Kosigi/కోసిగి",
    "Kowthalam/కౌతాళం",
    "Pedda Kadubur/పెద్ద కడుబూరు",
  ];
  List<String> pattikondaMandals = [
    "please select the mandal",
    "Krishnagiri/కృష్ణగిరి"
        "Veldurthi/వెల్దుర్తి",
    "Pattikonda/పట్టికొండ",
    "Maddikera (East)/మద్దికెర (తూర్పు)",
    "Tuggali/తుగ్గలి",
  ];
  List<String> yemmiagnurMandals = [
    "please select the mandal",
    "Yemmiganur/యెమ్మిగనూరు",
    "Nandavaram/నందవరం",
    "Gonegandla/గోనెగండ్ల",
    "Yemmiganur Town/యెమ్మిగనూరు పట్టణం",
  ];
  List<String> anatapurUrbanMandals = ["please select the mandal", "Anatapur"];
  List<String> guntakalMandals = [
    "please select the mandal",
    "Guntakal/గుంతకల్",
    "Gooty/గూటీ",
    "Pamidi/పమిడి",
    "Guntakal Town/గుంతకల్ టౌన్",
    "GOOTY Town/గూటీ టౌన్",
    "Pamidi/పమిడి",
  ];
  List<String> kalyandurgMandals = [
    "please select the mandal",
    "Brahmasamudram/బ్రహ్మసముద్రం",
    "Brahmasamudram Town/బ్రహ్మసముద్రం టౌన్",
    "Kalyandurg/కళ్యాణదుర్గ్",
    "Settur/సెట్ూర్",
    "Kundurpi/కుందుర్పి",
    "Kambadur/కంబదూరు",
    "KALYANDURG Town/కళ్యాణదుర్గ్ టౌన్",
  ];
  List<String> rayadurgMandals = [
    "please select the mandal",
    "D.Hirehal/డి.హిరేహల్",
    "Rayadurg/రాయదుర్గ్",
    "Kanekal/కణేకల్",
    "Bommanahal/బొమ్మనహాల్",
    "Gummagatta/గుమ్మగట్ట",
    "Rayadurg Town/రాయదుర్గం పట్టణం",
  ];
  List<String> singanamalaMandals = [
    "please select the mandal",
    "Garladinne/గార్లదిన్నె",
    "Singanamala/సింగనమల",
    "Putlur/పుట్లూరు",
    "Yellanur/యల్లనూరు",
    "Narpala/నార్పల",
    "B.K. Samudram/బి.కె. సముద్రం",
  ];
  List<String> tadipatriMandals = [
    "please select the mandal",
    "Peddavadugur/పెద్దవడుగూరు ",
    "Yadiki/యాడికి ",
    "Tadpatri/తాడిపత్రి",
    "Peddapappur/పెద్దపప్పూర్ ",
    "Tadpatri Town/తాడిపత్రి టౌన్"
  ];
  List<String> uravakondaMandals = [
    "please select the mandal",
    "Vidapanakal/విడపనకల్",
    "Vajrakarur/వజ్రకరూరు",
    "Uravakonda/ఉరవకొండ",
    "Beluguppa/బెళుగుప్ప",
    "Kudair/కూడైర్"
  ];
  List<String> dharmavaramMandals = [
    "please select the mandal",
    "Dharmavaram/ధర్మవరం",
    "Bathalapalle/బత్తలపల్లె",
    "Tadimarri/తాడిమర్రి",
    "Mudigubba/ముదిగుబ్బ",
    "Dharmavaram Town/ధర్మవరం  టౌన్"
  ];
  List<String> hindupurMandals = [
    "please select the mandal",
    "Hindupur/హిందూపూర్",
    "Lepakshi/లేపాక్షి",
    "Chilamathur/చిలమత్తూరు",
    "Hindupur Town/హిందూపూర్  టౌన్ "
  ];
  List<String> kadiriMandals = [
    "please select the mandal",
    "Talupula/తలుపుల ",
    "Nambulipulikunta/నంబులిపులికుంట",
    "Gandlapenta/గాండ్లపెంట",
    "Kadiri/కదిరి",
    "Nallacheruvu/నల్లచెరువు",
    "Tanakal/తనకల్",
    "Kadiri Town/కదిరి  టౌన్"
  ];
  List<String> madakasiraMandals = [
    "please select the mandal",
    "Madakasira/మడకశిర",
    "Amarapuram/అమరాపురం",
    "Gudibanda/గుదిబండ",
    "Rolla/రోళ్ల",
    "Agali/అగళి",
    "Madakasira/మడకశిర"
  ];
  List<String> penukondaMandals = [
    "please select the mandal",
    "Roddam/రొద్దం",
    "Parigi/పెరిగి",
    "Penukonda/పెనుకొండ",
    "Gorantla/గోరంట్ల ",
    "Somandepalle/సోమందేపల్లె",
    "Penukonda Town/పెనుకొండ టౌన్"
  ];
  List<String> puttaparthiMandals = [
    "please select the mandal",
    "Nallamada/నల్లమాడ",
    "Bukkapatnam/బుక్కపట్నం",
    "Kothacheruvu/కొత్తచెరువు ",
    "Puttaparthi/పుట్టపర్తి ",
    "Obuladevaracheruvu/ఓబుళదేవరచెరువు",
    "Amadagur/ఆమడగూరు",
    "Puttaparthi Town/పుట్టపర్తి టౌన్ "
  ];
  List<String> raptaduMandals = [
    "please select the mandal",
    "Atmakur/ఆత్మకూరు",
    "Anantapur Rural/అనంతపూర్  రూరల్",
    "Raptadu/రాప్తాడు",
    "Kanaganapalle/కనగానపల్లె",
    "Chennekothapalle/చెన్నెకొత్తపల్లె",
    "Ramagiri/రామగిరి"
  ];
  List<String> badvelMandals = [
    "please select the mandal",
    "Sri Avadhutha Kasinayana/శ్రీ అవధూత  కాశినాయన",
    "Kalasapadu/కలసపాడు",
    "Porumamilla/పోరుమామిళ్ల",
    "B.Kodur/బి .కోడూరు ",
    "Badvel/బద్వేల్",
    "Gopavaram/గోపవరం ",
    "Atlur/అట్లూరి",
    "Badvel Town/బద్వేల్ టౌన్",
    "Yerraguntla/ఎర్రగుంట్ల"
  ];
  List<String> kadapaMandals = ["please select the mandal", "Cuddapah/కడప"];
  List<String> kamalapuramMandals = [
    "please select the mandal",
    "Veerapunayunipalle/వీరపునాయునిపల్లె",
    "Kamalapuram/కమలాపురం",
    "Vallur/వల్లూరు",
    "Chennur/చెన్నూర్",
    "Chinthakommadinne/చింతకొమ్మదిన్నె",
    "Pendlimarri/పెండ్లిమర్రి ",
    "Kamalapuram Town/కమలాపురం  టౌన్"
  ];
  List<String> mydukurMandals = [
    "please select the mandal",
    "Duvvur/దువ్వూరి",
    "S.Mydukur/S.మైదుకూరు",
    "Brahmamgarimattam/బ్రహ్మంగారిమత్తం",
    "Khajipet/ఖాజీపేట",
    "Chapad/చాపాడు",
    "Mydukur Town/మైదుకూరు  టౌన్ "
  ];
  List<String> proddaturMandals = [
    "please select the mandal",
    "Rajupalem/రాజుపాలెం",
    "Proddatur/ప్రొద్దుటూరు",
    "Proddatur Town/V"
  ];
  List<String> pulivendulaMandals = [
    "please select the mandal",
    "Simhadripuram/సింహాద్రిపురం",
    "Lingala/లింగాల",
    "Pulivendla/పులివెందుల ",
    "Vemula/వేముల",
    "Thondur/తొండూరు",
    "Vempalle/వేంపల్లె",
    "Chakrayapet/చక్రాయపేట",
    "Pulivendla Town/పులివెందుల  టౌన్"
  ];
  List<String> atmakurMandals = [
    "please select the mandal",
    "Marripadu/మర్రిపాడు",
    "Atmakur/ఆత్మకూరు",
    "Anumasamudrampeta/అనుమాసముద్రంపేట",
    "Sangam/సంగం",
    "Chejerla/చేజెర్ల",
    "Ananthasagaram/అనంతసాగరం",
    "Atmakur Town/ఆత్మకూరు  టౌన్ "
  ];
  List<String> kandukurMandals = [
    "please select the mandal",
    "Voletivaripalem/వోలేటివారిపాలెం",
    "Kandukur/కందుకూరు",
    "Lingasamudram/లింగసముద్రం",
    "Gudluru/గుడ్లూరు",
    "Ulavapadu/ఉలవపాడు",
    "KANDUKUR TOWN/కందుకూరు  టౌన్"
  ];
  List<String> kavaliMandals = [
    "please select the mandal",
    "Kavali/కావలి",
    "Bogole/బోగోలు",
    "Dagadarthi/దగదర్తి ",
    "Allur/అల్లూరి",
    "Kavali Town/కావలి  టౌన్ ",
    "Allur Town/అల్లూరి  టౌన్"
  ];

  List<String> kovurMandals = [
    "please select the mandal",
    "Vidavalur/విడవలూరు",
    "Kodavalur/కొడవలూరు",
    "Buchireddipalem/బుచ్చిరెడ్డిపాలెం",
    "Kovur/కోవూరు",
    "Indukurpet/ఇందుకూరుపేట",
    "Buchireddipalem Town/బుచ్చిరెడ్డిపాలెం టౌన్"
  ];
  List<String> nelloreCityMandals = [
    "please select the mandal",
    "Nellore City/నెల్లూరు సిటీ"
  ];
  List<String> nelloreRuralMandals = [
    "please select the mandal",
    "Nellore rural/నెల్లూరు రూరల్"
  ];
  List<String> udayagiriMandals = [
    "please select the mandal",
    "Seetharamapuram/సీతారామపురం",
    "Udayagiri/ఉదయగిరి",
    "Varikuntapadu/వరికుంటపాడు",
    "Kondapuram/కొండాపురం",
    "Jaladanki/జలదంకి",
    "Kaligiri/కలిగిరి",
    "Vinjamur/వింజమూరు",
    "Duttalur/దుత్తలూరు"
  ];
  List<String> guduruMandals = [
    "please select the mandal",
    "Gudur/గూడూరు",
    "Chillakur/చిల్లకూరు",
    "Kota/కోట",
    "Vakadu/వాకాడు",
    "Chittamur/చిట్టమూరు",
    "Gudur Town/గూడూరు పట్టణం"
  ];
  List<String> sarvepalliMandals = [
    "please select the mandal",
    "Podalakur/పొదలకూరు",
    "Thotapalligudur/తోటపల్లిగూడూరు",
    "Muthukur/ముత్తుకూరు",
    "Venkatachalam/వెంకటాచలం",
    "Manubolu/మనుబోలు"
  ];
  List<String> satyaveduMandals = [
    "please select the mandal",
    "Buchinaidu Kandriga/బుచ్చినాయుడు కండ్రిగ",
    "Varadaiahpalem/వరదయ్యపాలెం",
    "K.V.B.Puram/కె.వి.బి.పురం",
    "Narayanavanam/నారాయణవనం",
    "Pichatur/పిచతుర్",
    "Satyavedu/సత్యవేడు",
    "Nagalapuram/నాగలాపురం"
  ];
  List<String> srikalahasthiMandals = [
    "please select the mandal",
    "Renigunta/రేణిగుంట",
    "Yerpedu/ఏర్పేడు",
    "Srikalahasti/శ్రీకాళహస్తి",
    "Thottambedu/తొట్టంబేడు",
    "Srikalahasti Town/శ్రీకాళహస్తి టౌన్"
  ];
  List<String> sullurpetMandals = [
    "please select the mandal",
    "Ojili/ఓజిలి",
    "Naidupet/నాయుడుపేట",
    "Pellakur/పెళ్లకూర్",
    "Doravarisatram/దొరవారిసత్రం",
    "Sullurpeta/సూళ్లూరుపేట",
    "Tada/తడ",
    "Naidupeta Town/నాయుడుపేట టౌన్",
    "Sullurpet Town/సూళ్లూరుపేట పట్టణం"
  ];
  List<String> tirupatiMandals = ["please select the mandal", "Tirupati"];
  List<String> venkatagiriMandals = [
    "please select the mandal",
    "Kaluvoya/కలువోయ",
    "Rapur/రాపూర్",
    "Sydapuram/సైదాపురం",
    "Dakkili/డక్కిలి",
    "Venkatagiri/వెంకటగిరి",
    "Balayapalle/బాలయపల్లె",
    "Venkatagiri Town/వెంకటగిరి టౌన్"
  ];
  List<String> kodurMandals = [
    "please select the mandal",
    "Penagalur/పెనగలూరు",
    "Chitvel/చిట్వేల్",
    "Pullampeta/పుల్లంపేట",
    "Obulavaripalle/ఓబులవారిపల్లె",
    "Kodur/కోడూరు"
  ];
  List<String> madanepalleMandals = [
    "please select the mandal",
    "Madanapalle/మదనపల్లె",
    "Nimmanapalle/నిమ్మనపల్లె",
    "Ramasamudram/రామసముద్రం",
    "Madanapalle Town/మదనపల్లె టౌన్"
  ];
  List<String> pileruMandals = [
    "please select the mandal",
    "Gurramkonda/గుర్రంకొండ",
    "Kalakada/కలకడ",
    "Kambhamvaripalle/కంభంవారిపల్లె",
    "Pileru/పీలేరు",
    "Kalikiri/కలికిరి",
    "Valmikipuram/వాల్మీకిపురం"
  ];
  List<String> punganurMandals = [
    "please select the mandal",
    "Rompicherla/రొంపిచెర్ల",
    "Sodam/సోడం",
    "Pulicherla/పులిచెర్ల",
    "Somala/సోమల",
    "Chowdepalle/చౌడేపల్లె",
    "Punganur/పుంగనూరు",
    "Punganur Town/పుంగనూరు టౌన్"
  ];
  List<String> rajampetMandals = [
    "please select the mandal",
    "Vontimitta/వొంటిమిట్ట",
    "Sidhout/సిధౌట్",
    "T Sundupalle/టి సుండుపల్లె",
    "Veeraballe/వీరబల్లే",
    "Nandalur/నందలూరు",
    "Rajampet/రాజంపేట",
    "Rajampet Town/రాజంపేట టౌన్"
  ];
  List<String> rayachotiMandals = [
    "please select the mandal",
    "Galiveedu/గాలివీడు",
    "Chinnamandem/చిన్నమండెం",
    "Sambepalle/సంబేపల్లె",
    "Rayachoti/రాయచోటి",
    "Lakkireddipalle/లక్కిరెడ్డిపల్లె",
    "Ramapuram/రామపురం",
    "Rayachoti Town/రాయచోటి టౌన్"
  ];
  List<String> thamballapalleMandals = [
    "please select the mandal",
    "Mulakalacheruvu/ములకలచెరువు",
    "Thamballapalle/తంబళ్లపల్లె",
    "Peddamandyam/పెద్దమండ్యం",
    "Kurabalakota/కురబలకోట",
    "Pedda Thippasamudram/పెద్ద తిప్పసముద్రం",
    "B.Kothakota/బి.కొత్తకోట",
    "B.Kothakota Town/బి.కొత్తకోట టౌన్"
  ];
  List<String> chandragiriMandals = [
    "please select the mandal",
    "Yerravaripalem/యర్రావారిపాలెం",
    "Tirupati (Rural)/తిరుపతి (గ్రామీణ)",
    "Chandragiri/చంద్రగిరి",
    "Chinnagottigallu/చిన్నగొట్టిగల్లు",
    "Pakala/పాకాల",
    "Ramachandrapuram/రామచంద్రపురం"
  ];
  List<String> chittoorMandals = [
    "please select the mandal",
    "Chittoor/చిత్తూరు",
    "Gudipala/గుడిపాల",
    "Chittoor Town/చిత్తూరు టౌన్"
  ];
  List<String> gangadharaNelloreMandals = [
    "please select the mandal",
    "Vedurukuppam/వెదురుకుప్పం",
    "Karvetinagar/కార్వేటినగర్",
    "Penumuru/పెనుమూరు",
    "Srirangarajapuram/శ్రీరంగరాజపురం",
    "Gangadhara Nellore/గంగాధర నెల్లూరు",
    "Palasamudram/పాలసముద్రం"
  ];
  List<String> kuppamMandals = [
    "please select the mandal",
    "Santhipuram/శాంతిపురం",
    "Gudupalle/గూడుపల్లె",
    "Kuppam/కుప్పం",
    "Ramakuppam/రామకుప్పం",
    "Kuppam Town/కుప్పం టౌన్"
  ];
  List<String> nagariMandals = [
    "please select the mandal",
    "Vadamalapeta/వడమాలపేట",
    "Nindra/నింద్రా",
    "Vijayapuram/విజయపురం",
    "Nagari/నగరి",
    "Puttur Town/పుత్తూరు పట్టణం",
    "Nagari Town/నగరి టౌన్",
    "Puttur/పుత్తూరు"
  ];
  List<String> palamanerMandals = [
    "please select the mandal",
    "Peddapanjani/పెద్దపంజాని",
    "Gangavaram/గంగవరం",
    "Palamaner/పలమనేరు",
    "Baireddipalle/బైరెడ్డిపల్లె",
    "Venkatagirikota/వెంకటగిరికోట",
    "Palamaner Town/పలమనేరు టౌన్"
  ];
  List<String> puthalapattuMandals = [
    "please select the mandal",
    "Puthalapattu/పూతలపట్టు",
    "Irala/ఇరాలా",
    "Thavanampalle/తవణంపల్లె",
    "Bangarupalem/బంగారుపాలెం",
    "Yadamarri/యాడమర్రి"
  ];

  HashMap<String, CheckBox> optionSelected = HashMap();
  String verificatioID = '';
  RegistrationModel? userDetails;
  bool enableOTPtext = false;

  setValueChecked(bool? value, CheckBox checkBox) {
    checkBox.checked = value;
    optionSelected.putIfAbsent(checkBox.title!, () => checkBox);
    notifyListeners();
  }

  setRoles(String value) {
    //formKey.currentState!.validate();
    if (value == "Select AC Name") {
      selectedConstituency = '';
      return "Please select your role";
    } else {
      selectedConstituency = value;
      pc = setPC(value);
      zone = setZone(pc);
      print(pc);
      sMandals = '';
    }
    notifyListeners();
  }

  setdistritcs(String value) {
    // print(value);
    //formKey.currentState!.validate();
    if (value == "Select District") {
      sDistrcts = '';
      return "Please select your district";
    } else {
      sDistrcts = value;
      selectedConstituency = '';
      sMandals = '';
    }
    notifyListeners();
  }

  setMandals(String value) {
    if (value == "Select Mandal") {
      sMandals = '';
      return "Please select your Mandal";
    } else {
      sMandals = value;
    }
    notifyListeners();
  }

  verifyPhone(BuildContext context, String phone) async {
    // showAlert(context, "భవిష్యత్తుకు గ్యారెంటీ... ఇది చంద్రబాబు గ్యారెంటీ తెలుగుదేశం పార్టీ", "నమస్కారం K SIVA.name},\nమీ భవిష్యత్తుకు గ్యారెంటీ నమోదు సంఖ్య : ${uniqueCode.text} \nభవిష్యత్తుకు గ్యారెంటీ కార్యక్రమంలో మీ పేరు నమోదు చేసుకున్నందుకు కృతజ్ఞతలు.");
    if (formKey.currentState!.validate()) {
      //DialogBuilder(context).showLoadingIndicator("Please wait while loading!");
      showLoaderOTP = true;
      String id = randomIdGenerator();
      checkID(context, id);
      if (uniqueCode.text.isNotEmpty) {
        //checkNumber(context, phone, id);
        sendSMS(context, phone, id);
      }
      notifyListeners();
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  sendToPdf(BuildContext context) {
    List<String> schems = setSchemes();
    DateTime dt = DateTime.now();
    List<Map<String, dynamic>> fList = [];
    List<Map<String, dynamic>> sList = [];
    List<Map<String, dynamic>> wList = [];
    List<Map<String, dynamic>> uEMPList = [];
    if (farmers > 0) {
      for (int i = 0; i < farmersFields.length; i++) {
        fList.add(PersonDetails(
                age: int.parse(farmersAgeController[i].text),
                name: farmersController[i].text)
            .toJson());
      }
    }
    //PersonDetailsList farmerList = PersonDetailsList(pdList: fList);

    if (students > 0) {
      for (int i = 0; i < studentFields.length; i++) {
        sList.add(PersonDetails(
                age: int.parse(studentsAgeController[i].text),
                name: studentsController[i].text)
            .toJson());
      }
    }

    //PersonDetailsList studentList = PersonDetailsList(pdList: sList);
    if (womenAbv > 0) {
      for (int i = 0; i < womenFields.length; i++) {
        wList.add(PersonDetails(
                age: int.parse(womenAgeController[i].text),
                name: womenController[i].text)
            .toJson());
      }
    }

    //PersonDetailsList womentList = PersonDetailsList(pdList: wList);
    if (unEMployedYouth > 0) {
      for (int i = 0; i < uEmpYouthFields.length; i++) {
        uEMPList.add(PersonDetails(
                age: int.parse(uEmpYouthAgeController[i].text),
                name: uEmpYouthController[i].text)
            .toJson());
      }
    }

    RegistrationModel rModel = RegistrationModel(
        name: name.text,
        age: age.text,
        constituency: selectedConstituency,
        district: sDistrcts,
        mandal: sMandals,
        address: address.text,
        pincode: pincode.text,
        vNum: vNumController.text.isNotEmpty ? vNumController.text : "",
        vName: vName.text.isNotEmpty ? vName.text : "",
        number: "$cc${phoneTextController.text}",
        gender: gender,
        isVerified: isVerified,
        date: dt.toIso8601String(),
        id: uniqueCode.text.isNotEmpty ? uniqueCode.text : "",
        scheme: schems,
        totalFam: famMembers,
        totalFarmers: farmers,
        totalStudents: students,
        totalUnEmployedYouth: unEMployedYouth,
        totalWomen: womenAbv,
        fatherNamefield: fatherNamefield.text,
        farmersList: fList,
        womenList: wList,
        studentList: sList,
        uEMPList: uEMPList,
        pc: '',
        zone: '');

    //print("${wList.first.toJson()}");
    //AppConstants.moveNextstl(context, MyPDF(rModel: rModel));
  }

  // checkNumber(BuildContext context, String phone, String id) {
  //   _db
  //       .collection('users')
  //       .where("phone", isEqualTo: phone)
  //       .get()
  //       .then((value) {
  //     Navigator.of(context, rootNavigator: true).pop();

  //     showAlert(context, "Error",
  //         "User is already registered \n with this UID: ${value.docs.first.get("id")} ");

  //     enableOTPtext = false;

  //     showLoaderOTP = false;
  //     notifyListeners();
  //   }).catchError((err) {
  //     sendSMS(context, phone, id);
  //     notifyListeners();
  //   });
  // }

  sendSMS(BuildContext context, String phone, String id) {
    DialogBuilder(context).showLoadingIndicator(
        "Please wait while we are sending UID to Registered Number");
    apiRequest.sendUID(phone, id).then((value) {
      enableOTPtext = true;
      timer =
          Timer.periodic(const Duration(seconds: 1), (timer) => processTimer());
      Navigator.of(context, rootNavigator: true).pop();
      showLoaderOTP = false;
      AppConstants.showSnackBar(context, value);
      notifyListeners();
    }).catchError((err) {
      showLoaderOTP = false;
      enableOTPtext = false;
      Navigator.of(context, rootNavigator: true).pop();
      AppConstants.showSnackBar(context, "$err");
      notifyListeners();
    });
  }

  showAlert(BuildContext context, String title, String msg) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            icon: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  "assets/images/ic_new_logo.png",
                  scale: 3.5,
                )),
            backgroundColor: AppConstants.appYellowBG,
            title: Text(
              title,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            content: Text(
              msg,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          );
        });
  }

  void checkID(BuildContext context, String id) {
    bool idPresent = getDetails(context, id);
    if (idPresent) {
      id = randomIdGenerator();
      checkID(context, id);
    } else {
      uniqueCode = TextEditingController(text: id);
    }
    notifyListeners();
  }

  bool getDetails(BuildContext context, String id) {
    bool checked = false;
    _db.collection('users').where("id", isEqualTo: id).get().then((value) {
      QuerySnapshot data = value;

      checked = false;
      notifyListeners();
    }).catchError((err) {
      checked = true;
      notifyListeners();
    });
    return checked;
  }

  randomIdGenerator() {
    String first4alphabets = '';
    for (int i = 0; i < 8; i++) {
      first4alphabets += math.Random.secure().nextInt(10).toString();
    }
    log(first4alphabets);
    return first4alphabets;
  }

  otpVerify(BuildContext context) async {
    DialogBuilder(context)
        .showLoadingIndicator("Please wait while we verifying the OTP ");
    // print("e.toString()");
    // print(verificatioID);
    try {
      if (otpTextController.text.isNotEmpty) {
        if (uniqueCode.text == otpTextController.text) {
          showLoader = false;
          showSubmit = true;
          isVerified = true;
          Navigator.of(context, rootNavigator: true).pop();
          AppConstants.showSnackBar(context, "Verifed Successfully");
        } else {
          showLoader = false;
          Navigator.of(context, rootNavigator: true).pop();
          AppConstants.showSnackBar(context, "Please Enter valid UID");
        }
      }
    } catch (e) {
      showLoader = false;
      Navigator.of(context, rootNavigator: true).pop();
      AppConstants.showSnackBar(context, e.toString());
    }
    notifyListeners();
  }

  List<String> setSchemes() {
    List<String> schemes = [];
    schemes.add("Deepam");
    schemes.add("water scheme");
    if (unEMployedYouth > 0) {
      schemes.add("YuvaGalam Nidhi");
    }
    if (farmers > 0) {
      schemes.add("Annadatha");
    }
    if (womenAbv > 0) {
      schemes.add("Maha Shakti");
    }
    if (students > 0) {
      schemes.add("Thalliki Vandanam");
    }

    return schemes;
  }

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
        setCC(country.phoneCode);
      },
    );
  }
  // setAcID(String value){

  // }

  setCC(String c) {
    cc = c;
    notifyListeners();
  }

  setGender(int val) {
    if (val == 1) {
      gender = "Male";
      selectedGRadio = val;
    } else if (val == 2) {
      gender = "Female";
      selectedGRadio = val;
    } else {
      gender = "Others";
      selectedGRadio = val;
    }
    notifyListeners();
  }

  void registerUser(BuildContext context) async {
    showLoader = true;
    List<String> schems = setSchemes();
    DialogBuilder(context)
        .showLoadingIndicator("Please wait while we are updating details ");
    DateTime dt = DateTime.now();
    List<Map<String, dynamic>> fList = [];
    List<Map<String, dynamic>> sList = [];
    List<Map<String, dynamic>> wList = [];
    List<Map<String, dynamic>> uEMPList = [];
    if (farmers > 0) {
      for (int i = 0; i < farmersFields.length; i++) {
        fList.add(PersonDetails(
                age: int.parse(farmersAgeController[i].text),
                name: farmersController[i].text)
            .toJson());
      }
    }
    //PersonDetailsList farmerList = PersonDetailsList(pdList: fList);

    if (students > 0) {
      for (int i = 0; i < studentFields.length; i++) {
        sList.add(PersonDetails(
                age: int.parse(studentsAgeController[i].text),
                name: studentsController[i].text)
            .toJson());
      }
    }

    //PersonDetailsList studentList = PersonDetailsList(pdList: sList);
    if (womenAbv > 0) {
      for (int i = 0; i < womenFields.length; i++) {
        wList.add(PersonDetails(
                age: int.parse(womenAgeController[i].text),
                name: womenController[i].text)
            .toJson());
      }
    }

    //PersonDetailsList womentList = PersonDetailsList(pdList: wList);
    if (unEMployedYouth > 0) {
      for (int i = 0; i < uEmpYouthFields.length; i++) {
        uEMPList.add(PersonDetails(
                age: int.parse(uEmpYouthAgeController[i].text),
                name: uEmpYouthController[i].text)
            .toJson());
      }
    }

    //Position pos = await _determinePosition();

    RegistrationModel rModel = RegistrationModel(
        name: name.text,
        age: age.text,
        constituency: selectedConstituency,
        district: sDistrcts,
        mandal: sMandals,
        address: address.text,
        pincode: pincode.text,
        vNum: vNumController.text.isNotEmpty ? vNumController.text : "",
        vName: vName.text.isNotEmpty ? vName.text : "",
        number: "$cc${phoneTextController.text}",
        gender: gender,
        isVerified: isVerified,
        date: dt.toIso8601String(),
        id: uniqueCode.text.isNotEmpty ? uniqueCode.text : "",
        scheme: schems,
        totalFam: famMembers,
        totalFarmers: farmers,
        totalStudents: students,
        totalUnEmployedYouth: unEMployedYouth,
        totalWomen: womenAbv,
        fatherNamefield: fatherNamefield.text,
        farmersList: fList,
        womenList: wList,
        studentList: sList,
        uEMPList: uEMPList,
        pc: pc,
        zone: zone,
        lat: "",
        longitude: "");
    //Uint8List data = await makePDF(context, rModel);

    _db
        .collection('users')
        .doc("$cc${phoneTextController.text}")
        .set(rModel.toJSON())
        .then((value) {
      showLoader = false;
      Navigator.of(context, rootNavigator: true).pop();
      showAlert(
          context,
          "భవిష్యత్తుకు గ్యారెంటీ... ఇది చంద్రబాబు గ్యారెంటీ తెలుగుదేశం పార్టీ",
          "దాన్యవాదాలు ${rModel.name},\nమీ భవిష్యత్తుకు గ్యారెంటీ నమోదు సంఖ్య : ${uniqueCode.text} \nభవిష్యత్తుకు గ్యారెంటీ కార్యక్రమంలో మీ పేరు నమోదు చేసుకున్నందుకు కృతజ్ఞతలు.");

      sendtoMSDB(context, rModel);
    }).catchError((err) {
      Navigator.of(context, rootNavigator: true).pop();
      AppConstants.showSnackBar(context, "$err");
    });
    notifyListeners();
  }

  setVlues(VRegistration vRegistration) {
    if (vRegistration.toJSON().isNotEmpty) {
      name = TextEditingController(text: vRegistration.name ?? "");
      vNumController = TextEditingController(text: vRegistration.phone ?? "");
      selectedConstituency = vRegistration.constituency ?? "";
      sDistrcts = vRegistration.district ?? "";
      sMandals = vRegistration.mandal ?? "";
      gpController = TextEditingController(text: vRegistration.panchayat ?? "");
    }
  }

  // setQRValues(BuildContext context) async {
  //   // final qrResults = await Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //       builder: (context) => const QRViewExample(), fullscreenDialog: true),
  //   // );
  //   // if (qrResults != null) {
  //   //   String qrcode = qrResults.code;
  //   //   List<String> uID = qrcode.split("/");
  //   //   // print("uid:${uID.last}");
  //   //   uniqueCode = TextEditingController(text: uID.last);
  //   //   // print(uniqueCode.text);
  //   // }

  //   notifyListeners();
  // }

  sendtoMSDB(BuildContext context, RegistrationModel rmodel) {
    Map<String, dynamic> data = {
      "name": rmodel.name,
      "age": rmodel.age,
      "mobileNo": rmodel.number,
      "constitunecyId": setAcID(rmodel.constituency!),
      "pincode": rmodel.pincode,
      "address": rmodel.address,
      "noOfChildren": rmodel.totalStudents,
      "noOfWomen": rmodel.totalWomen,
      "noOfUnEmployed": rmodel.totalUnEmployedYouth
    };
    apiRequest.sendDataMaster(data).then((value) {
      AppConstants.showSnackBar(
          context, "Thank you for enrolling into Bhavishyathuku guarantee");
      apiRequest
          .sendFinalMsg("$cc${phoneTextController.text}", uniqueCode.text)
          .then((value) {
        AppConstants.moveNextClearAll(context, ValidationScreen());
      }).catchError((err) {
        AppConstants.showSnackBar(context, "Registration Successfully done");
        AppConstants.showSnackBar(context, "$err");
      });
      notifyListeners();
    }).catchError((err) {
      AppConstants.showSnackBar(context, "$err");
      notifyListeners();
    });
  }

  setSelectedRadio(int? val) {
    selectedRadio = val!;
    // print("${val}selected");
    if (val == 1) {
      setVDetails();
    }
    notifyListeners();
  }

  setSelectedUniqueRadio(int? val) {
    selectedURadio = val!;
    // print("${val}selected");

    notifyListeners();
  }

  @override
  void dispose() {
    name.dispose();
    timer?.cancel();
    gpController.dispose();
    phoneTextController.dispose();
    super.dispose();
  }

  Future otpSaved(BuildContext context, String verificatioID) async {
    // print(verificationCode);
    showLoader = false;
    showLoader = true;

    try {
      showLoader = true;
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificatioID, smsCode: otpTextController.text))
          .then((value) async {
        if (value.user != null) {
          // sharedPref.save('id', value.user?.uid);
          // sharedPref.saveBool('keyVerified', true);
          showLoader = false;
        }
      });
    } catch (e) {
      showLoader = false;
      AppConstants.showSnackBar(context, '$e');
      //  print(e.toString());
    }

    notifyListeners();
  }

  Future<Uint8List> makePDF(
      BuildContext context, RegistrationModel rModel) async {
    final pdf = pw.Document();
    final svgmage = pw.SvgImage(svg: svgImage);
    final svgmage2 = pw.SvgImage(svg: pg2SVG);

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return svgmage; // Center
    }));
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return svgmage; // Center
    }));
    // pdf.addPage(await createPageOne(rModel));
    // pdf.addPage(await createPageTwo(rModel));
    return pdf.save();
  }

  createPage() async {
    final svgmage = pw.SvgImage(svg: svgImage);
  }

  createPageOne(RegistrationModel rModel) async {
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
                                                "${(rModel.totalWomen * 18000 + rModel.totalFarmers * 20000 + rModel.totalStudents * 15000 + rModel.totalUnEmployedYouth * 36000) * 5}",
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

  createPageTwo(RegistrationModel rModel) async {
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
                                    child:
                                        detailText("${rModel.totalFam}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalFarmers}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalWomen}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalStudents}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.totalUnEmployedYouth}",
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
                                        detailText2("${rModel.totalWomen}"),
                                        pw.SizedBox(width: 10),
                                        detailText2(""),
                                        pw.SizedBox(width: 10),
                                        detailText2(
                                            "${rModel.totalWomen * 18000}"),
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
                                        detailText2("${rModel.totalStudents}"),
                                        pw.SizedBox(width: 10),
                                        detailText2(""),
                                        pw.SizedBox(width: 10),
                                        detailText2(
                                            "${rModel.totalStudents * 15000}"),
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
                                          detailText2("${rModel.totalFarmers}"),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalFarmers * 20000}"),
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
                                              "${rModel.totalUnEmployedYouth}"),
                                          pw.SizedBox(width: 10),
                                          detailText2(""),
                                          pw.SizedBox(width: 10),
                                          detailText2(
                                              "${rModel.totalUnEmployedYouth * 36000}"),
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
                                          "${rModel.id!.isEmpty ? 12345678 : rModel.id}",
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
                                    child:
                                        detailText("${rModel.pincode}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.constituency}", fontG),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.number}", fontG),
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
                                    child: detailText("${rModel.name}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText(
                                        "${rModel.fatherNamefield}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child: detailText("${rModel.age}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.address}", fontG),
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Positioned(
                                    left: 80,
                                    child:
                                        detailText("${rModel.district}", fontG),
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
