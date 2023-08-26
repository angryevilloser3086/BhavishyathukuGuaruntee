// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vregistration/src/utils/shared_pref.dart';
import '../../src/network/api_request.dart';
import '../../src/view/registration/qr.dart';
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

  List<int> famMem = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

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
    String name='';
    String number='';
    if(kIsWeb){
     name  = await sharedPref.read("vname");
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
      if (value == 'Alluri Sitharama Raju') {
        return asRaju;
      } else if (value == 'Anakapalli') {
        // print(value);
        return anakapalli;
      } else if (value == 'Anantapuramu') {
        return anatapur;
      } else if (value == 'Annamayya') {
        return annamayya;
      } else if (value == 'Bapatla') {
        return bapatla;
      } else if (value == 'Chittoor') {
        return chittoor;
      } else if (value == 'Dr. B. R. Ambedkar Konaseema') {
        return konaseema;
      } else if (value == 'East Godavari') {
        return eastGodavari;
      } else if (value == 'Eluru') {
        return eluru;
      } else if (value == 'Guntur') {
        return guntur;
      } else if (value == 'Kadapa') {
        return kadapa;
      } else if (value == 'Kakinada') {
        return kakinada;
      } else if (value == 'Krishna') {
        return krishna;
      } else if (value == 'Kurnool') {
        return kurnool;
      } else if (value == 'Nandyal') {
        return nandyal;
      } else if (value == 'Nellore') {
        return nellore;
      } else if (value == 'NTR') {
        return ntr;
      } else if (value == 'Palnadu') {
        return palnadu;
      } else if (value == 'Parvathipuram Manyam') {
        return manyam;
      } else if (value == 'Prakasam') {
        return prakasam;
      } else if (value == 'Sri Sathya Sai') {
        return sssai;
      } else if (value == 'Srikakulam') {
        return srikakulam;
      } else if (value == 'Tirupati') {
        return tirupati;
      } else if (value == 'Visakhapatnam') {
        return vishakapatnam;
      } else if (value == 'Vizianagaram') {
        return vizianagaram;
      } else if (value == 'West Godavari') {
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
      if (value == 'Araku Valley') {
        return arakuMandals;
      } else if (value == 'Paderu') {
        return paderuMandals;
      } else if (value == 'Rampachodavaram') {
        return rampochodavaramMandals;
      } else if (value == 'Chodavaram') {
        return chodavaramMandals;
      } else if (value == 'Madugula') {
        return madugulaMandals;
      } else if (value == 'Anakapalle') {
        return anakapalliMandals;
      } else if (value == 'Pendurthi') {
        return pendurthiMandals;
      } else if (value == 'Elamanchili') {
        return elamanchiliMandals;
      } else if (value == 'Payakaraopet') {
        return payakaroapetMandals;
      } else if (value == 'Narsipatnam') {
        return narsipatnamMandals;
      } else if (value == 'Rayadurg') {
        return rayadurgMandals;
      } else if (value == 'Uravakonda') {
        return uravakondaMandals;
      } else if (value == 'Guntakal') {
        return guntakalMandals;
      } else if (value == 'Tadipatri') {
        return tadipatriMandals;
      } else if (value == 'Singanamala') {
        return singanamalaMandals;
      } else if (value == 'Anantapur Urban') {
        return anatapurUrbanMandals;
      } else if (value == 'Kalyandurg') {
        return kalyandurgMandals;
      } else if (value == 'Raptadu') {
        return raptaduMandals;
      } else if (value == 'Vemuru') {
        return vemuruMandals;
      } else if (value == 'Repalle') {
        return repalleMandals;
      } else if (value == 'Bapatla') {
        return baptlaMandals;
      } else if (value == 'Parchur') {
        return parchurMandals;
      } else if (value == 'Addanki') {
        return addankiMandals;
      } else if (value == 'Chirala') {
        return chiralaMandals;
      } else if (value == 'Rajampeta') {
        return rajampetMandals;
      } else if (value == 'Kodur') {
        return kodurMandals;
      } else if (value == 'Rayachoti') {
        return rayachotiMandals;
      } else if (value == 'Thamballapalle') {
        return thamballapalleMandals;
      } else if (value == 'Pileru') {
        return pileruMandals;
      } else if (value == 'Madanapalle') {
        return madanepalleMandals;
      } else if (value == 'Punganur') {
        return punganurMandals;
      } else if (value == 'Nagari') {
        return nagariMandals;
      } else if (value == 'Gangadhara Nellore') {
        return gangadharaNelloreMandals;
      } else if (value == 'Chittoor') {
        return chittoorMandals;
      } else if (value == 'Puthalapattu') {
        return puthalapattuMandals;
      } else if (value == 'palamaner') {
        return palamanerMandals;
      } else if (value == 'Kuppam') {
        return kuppamMandals;
      } else if (value == 'Anaparthy') {
        return anaparthyMandals;
      } else if (value == 'Rajanagaram') {
        return rajanagaramMandals;
      } else if (value == 'Rajamundry City') {
        return rjyCityMandals;
      } else if (value == 'Rajahmundry Rural') {
        return rjyRuralMandals;
      } else if (value == 'Kovvur') {
        return kovvurMandals;
      } else if (value == 'Nidadavole') {
        return nidadavoleMandals;
      } else if (value == 'Gopalapuram') {
        return gopalapuramMandals;
      } else if (value == 'Unguturu') {
        return unguturuMandals;
      } else if (value == 'Denduluru') {
        return dendulurMandals;
      } else if (value == 'Eluru') {
        return eluruMandals;
      } else if (value == 'Polavaram') {
        return polavaramMandals;
      } else if (value == 'Chintalapudi') {
        return chintalapudiMandals;
      } else if (value == 'Nuzvid') {
        return nuzvidMandals;
      } else if (value == 'Kaikalur') {
        return kaikaluruMandals;
      } else if (value == 'Tadikonda') {
        return tadikondaMandals;
      } else if (value == 'Mangalagiri') {
        return mangalagiriMandals;
      } else if (value == 'Ponnuru') {
        return ponnurMandals;
      } else if (value == 'Tenali') {
        return tenaliMandals;
      } else if (value == 'Prathipadu') {
        return prathipaduGMandals;
      } else if (value == 'Guntur West') {
        return gunturWestMandals;
      } else if (value == 'Guntur East') {
        return gunturEastMandals;
      } else if (value == 'Achanta') {
        return achantaMandals;
      } else if (value == 'Palakollu') {
        return palakolluMandals;
      } else if (value == 'Narasapuram') {
        return narsapurMandals;
      } else if (value == 'Bhimavaram') {
        return bhimavaramMandals;
      } else if (value == 'Undi') {
        return undiMandals;
      } else if (value == 'Tanuku') {
        return tanukuMandals;
      } else if (value == 'Tadepalligudem') {
        return tadepalligudemMandals;
      } else if (value == 'Rajam') {
        return rajamMandals;
      } else if (value == 'Bobbili') {
        return bobbiliMandals;
      } else if (value == 'Cheepurupalli') {
        return chepurupalliMandals;
      } else if (value == 'Gajapathinagaram') {
        return gajapathinagaramMandals;
      } else if (value == 'Nellimarla') {
        return nellimarlaMandals;
      } else if (value == 'Vizianagaram') {
        return vizianagaramMandals;
      } else if (value == 'Srungavarapukota') {
        return srungavarapukotaMandals;
      } else if (value == 'Bhimili') {
        return bhimiliMandals;
      } else if (value == 'Vishakapatnam East') {
        return vizagEastMandals;
      } else if (value == 'Vishakapatnam West') {
        return vizagWestMandals;
      } else if (value == 'Vishakapatnam South') {
        return vizagSouthMandals;
      } else if (value == 'Vishakapatnam North') {
        return vizagNorthMandals;
      } else if (value == 'Gajuwaka') {
        return gajuwakaMandals;
      } else if (value == 'Gudur') {
        return guduruMandals;
      } else if (value == 'Sullurupeta') {
        return sullurpetMandals;
      } else if (value == 'Venkatagiri') {
        return venkatagiriMandals;
      } else if (value == 'Chandragiri') {
        return chandragiriMandals;
      } else if (value == 'Tirupati') {
        return tirupatiMandals;
      } else if (value == 'Srikalahasti') {
        return srikalahasthiMandals;
      } else if (value == 'Sathyavedu') {
        return satyaveduMandals;
      } else if (value == 'Ichchapuram') {
        return icchapuramMandals;
      } else if (value == 'Palasa') {
        return palasaMandals;
      } else if (value == 'Tekkali') {
        return tekkaliMandals;
      } else if (value == 'Pathapatnam') {
        return pathapatnamMandals;
      } else if (value == 'Srikakulam') {
        return srikakulamMandals;
      } else if (value == 'Amadalavalasa') {
        return amadalavalsaMandals;
      } else if (value == 'Etcherla') {
        return etcherlaMandals;
      } else if (value == 'Narasannapeta') {
        return narasannapetaMandals;
      } else if (value == 'Madakasira') {
        return madakasiraMandals;
      } else if (value == 'Hindupur') {
        return hindupurMandals;
      } else if (value == 'Penukonda') {
        return penukondaMandals;
      } else if (value == 'Puttaparthi') {
        return puttaparthiMandals;
      } else if (value == 'Dharmavaram') {
        return dharmavaramMandals;
      } else if (value == 'Kadiri') {
        return kadiriMandals;
      } else if (value == 'Yerragondapalem') {
        return yerragondapalemMandals;
      } else if (value == 'Darsi') {
        return darsiMandals;
      } else if (value == 'Santhanuthalapadu') {
        return snathanuthalapaduMandals;
      } else if (value == 'Ongole') {
        return ongoleMandals;
      } else if (value == 'Kondapi') {
        return kondepiMandals;
      } else if (value == 'Markapuram') {
        return markapurMandals;
      } else if (value == 'Giddalur') {
        return giddaluruMandals;
      } else if (value == 'Kanigiri') {
        return kanigiriMandals;
      } else if (value == 'Pedakurapadu') {
        return pedakurapaduMandals;
      } else if (value == 'Chilakaluripeta') {
        return chilakaluripetaMandals;
      } else if (value == 'Narasaraopet') {
        return narasaraopetMandals;
      } else if (value == 'Sattenapalle') {
        return sattenapalliMandals;
      } else if (value == 'Vinukonda') {
        return vinkuondaMandals;
      } else if (value == 'Gurajala') {
        return gurajalaMandals;
      } else if (value == 'Macherla') {
        return macherlaMandals;
      } else if (value == 'Tiruvuru') {
        return tiruvuruMandals;
      } else if (value == 'Vijayawada West') {
        return vjyWestMandals;
      } else if (value == 'Vijayawada Central') {
        return vjyCentralMandals;
      } else if (value == 'Vijayawada East') {
        return vjyEastMandals;
      } else if (value == 'Mylavaram') {
        return mylavaramMandals;
      } else if (value == 'Nandigama') {
        return nandigamaMandals;
      } else if (value == 'Jaggayyapeta') {
        return jaggayyapetMandals;
      } else if (value == 'Kandukur') {
        return kandukurMandals;
      } else if (value == 'Kavali') {
        return kavaliMandals;
      } else if (value == 'Atmakur') {
        return atmakurMandals;
      } else if (value == 'Kovur') {
        return kovurMandals;
      } else if (value == 'Nellore City') {
        return nelloreCityMandals;
      } else if (value == 'Nellore Rural') {
        return nelloreRuralMandals;
      } else if (value == 'Sarvepalli') {
        return sarvepalliMandals;
      } else if (value == 'Udayagiri') {
        return udayagiriMandals;
      } else if (value == 'Allagadda') {
        return allagaddaMandals;
      } else if (value == 'Srisailam') {
        return srisailamMandals;
      } else if (value == 'Nandikotkur') {
        return nandikotkuruMandals;
      } else if (value == 'Panyam') {
        return panyamMandals;
      } else if (value == 'Nandyal') {
        return nandyalMandals;
      } else if (value == 'Banaganapalle') {
        return banaganapalleMandals;
      } else if (value == 'Dhone') {
        return dhoneMandals;
      } else if (value == 'Badvel') {
        return badvelMandals;
      } else if (value == 'Kadapa') {
        return kadapaMandals;
      } else if (value == 'Pulivendla') {
        return pulivendulaMandals;
      } else if (value == 'Kamalapuram') {
        return kamalapuramMandals;
      } else if (value == 'Jammalamadugu') {
        return jammalamaduguMadals;
      } else if (value == 'Mydukur') {
        return mydukurMandals;
      } else if (value == 'Proddatur') {
        return proddaturMandals;
      } else if (value == 'Tuni') {
        return tuniMandals;
      } else if (value == 'Prathipadu') {
        return prathipaduMandals;
      } else if (value == 'Pithapuram') {
        return pithapuramMandals;
      } else if (value == 'Kakinada Rural') {
        return kkdRuralMandals;
      } else if (value == 'Peddapuram') {
        return peddapuramMandals;
      } else if (value == 'Kakinada City') {
        return kkdCityMandals;
      } else if (value == 'Jaggampeta') {
        return jaggampetaMandals;
      } else if (value == 'Ramachandrapuram') {
        return rcpmMandals;
      } else if (value == 'Mummidivaram') {
        return mummidivaramMandals;
      } else if (value == 'Amalapuram') {
        return amalapuramMandals;
      } else if (value == 'Razole') {
        return razoleMandals;
      } else if (value == 'Gannavaram (konaseema)') {
        return gannavaramKSMandals;
      } else if (value == 'Kothapeta') {
        return kothapetaMandals;
      } else if (value == 'Mandapeta') {
        return mandapetaMandals;
      } else if (value == 'Gannavaram') {
        return gannavaramMandals;
      } else if (value == 'Gudivada') {
        return gudivadaMandals;
      } else if (value == 'Pedana') {
        return pedanaMandals;
      } else if (value == 'Machilipatnam') {
        return machilipatnamMandals;
      } else if (value == 'Avanigadda') {
        return avanigaddaMandals;
      } else if (value == 'Pamarru') {
        return pamarruMandals;
      } else if (value == 'Penamaluru') {
        return penamaluruMandals;
      } else if (value == 'Kurnool') {
        return kurnoolMandals;
      } else if (value == 'Pattikonda') {
        return pattikondaMandals;
      } else if (value == 'Kodumur') {
        return kodumurMandals;
      } else if (value == 'Yemmiganur') {
        return yemmiagnurMandals;
      } else if (value == 'Mantralayam') {
        return matralayamMandals;
      } else if (value == 'Adoni') {
        return adoniMandals;
      } else if (value == 'Alur') {
        return alurMandals;
      } else if (value == 'Palakonda') {
        return palakondaMandals;
      } else if (value == 'Kurupam') {
        return kurupamMandals;
      } else if (value == 'Parvathipuram') {
        return parvathipuramMandals;
      } else if (value == 'Salur') {
        return salurMandals;
      } else {
        return ['Please select your Assembly Constituency'];
      }
    } else {
      return ['Please select your Assembly Constituency'];
    }
  }

  List<String> mandals = [
    "Please select your Mandal",
    "Select Mandal",
    "Addateegala mandal",
    "Ananthagiri mandal",
    "Araku Valley mandal",
    "Chintapalle mandal",
    "Chintur mandal",
    "Devipatnam mandal",
    "Dumbriguda mandal",
    "Etapaka mandal",
    "Ganagaraju Madugula mandal",
    "Gangavaram mandal",
    "Gudem Kotha Veedhi mandal",
    "Hukumpeta mandal",
    "Koyyuru mandal",
    "Kunavaram mandal",
    "Maredumilli mandal",
    "Munchingi Puttu mandal",
    "Paderu mandal",
    "Peda Bayalu mandal",
    "Rajavommangi mandal",
    "Rampachodavaram mandal",
    "Vararamachandrapuram mandal",
    "Y. Ramavaram mandal",
    "Anakapalle mandal",
    "Atchutapuram mandal",
    "Butchayyapeta mandal",
    "Cheedikada mandal",
    "Chodavaram mandal",
    "Devarapalli mandal",
    "Elamanchili mandal",
    "Golugonda mandal",
    "K.Kotapadu mandal",
    "Kasimkota mandal",
    "Kotauratla mandal",
    "Madugula mandal",
    "Makavarapalem mandal",
    "Munagapaka mandal",
    "Nakkapalle mandal",
    "Narsipatnam mandal",
    "Nathavaram mandal",
    "Paravada mandal",
    "Payakaraopeta Mandal",
    "Rambilli mandal",
    "Ravikamatham mandal",
    "Rolugunta mandal",
    "Sarvasiddhi Rayavaram mandal",
    "Sabbavaram mandal",
    "Anantapur Urban mandal",
    "Anantapur Rural mandal",
    "Atmakur mandal",
    "Beluguppa mandal",
    "Bommanahal mandal",
    "Brahmasamudram mandal",
    "Bukkaraya Samudram mandal",
    "D.Hirehal mandal",
    "Garladinne mandal",
    "Gooty mandal",
    "Gummagatta mandal",
    "Guntakal mandal",
    "Kalyandurg mandal",
    "Kambadur mandal",
    "Kanekal mandal",
    "Kudair mandal",
    "Kundurpi mandal",
    "Narpala mandal",
    "Pamidi mandal",
    "Peddapappur mandal",
    "Peddavadugur mandal",
    "Putlur mandal",
    "Raptadu mandal",
    "Rayadurg mandal",
    "Settur mandal",
    "Singanamala mandal",
    "Tadpatri mandal",
    "Uravakonda mandal",
    "Vajrakarur mandal",
    "Vidapanakal mandal",
    "Yadiki mandal",
    "Yellanur mandal",
    "Beerangi Kothakota mandal",
    "Chinnamandyam mandal",
    "Chitvel mandal",
    "Galiveedu mandal",
    "Gurramkonda mandal",
    "Kalakada mandal",
    "Kalikiri mandal",
    "Kambhamvaripalle mandal",
    "Railway Koduru mandal",
    "Kurabalakota mandal",
    "Lakkireddypalle mandal",
    "Madanapalle mandal",
    "Mulakalacheruvu mandal",
    "Nandalur mandal",
    "Nimmanapalle mandal",
    "Obulavaripalle mandal",
    "Pedda Thippasamudram mandal",
    "Peddamandyam mandal",
    "Penagalur mandal",
    "Pileru mandal",
    "Pullampeta mandal",
    "Rajampet mandal",
    "Ramapuram mandal",
    "Ramasamudram mandal",
    "Rayachoti mandal",
    "Sambepalli mandal",
    "T Sundupalle mandal",
    "Thamballapalle mandal",
    "Valmikipuram mandal",
    "Veeraballi mandal",
    "Addanki mandal",
    "Amruthalur mandal",
    "Ballikurava mandal",
    "Bapatla mandal",
    "Bhattiprolu mandal",
    "Cherukupalle mandal",
    "Chinaganjam mandal",
    "Chirala mandal",
    "Inkollu mandal",
    "Janakavarampanguluru mandal",
    "Karamchedu mandal",
    "Karlapalem mandal",
    "Kolluru mandal",
    "Korisapadu mandal",
    "Martur mandal",
    "Nagaram mandal",
    "Nizampatnam mandal",
    "Parchur mandal",
    "Pittalavanipalem mandal",
    "Repalle mandal",
    "Santhamaguluru mandal",
    "Tsundur mandal",
    "Vemuru mandal",
    "Vetapalem mandal",
    "Yeddanapudi mandal",
    "Baireddipalle mandal",
    "Bangarupalem mandal",
    "Chittoor Rural mandal",
    "Chittoor Urban mandal",
    "Chowdepalle mandal",
    "Gangadhara Nellore mandal",
    "Gangavaram mandal",
    "Gudipala mandal",
    "Gudupalle mandal",
    "Irala mandal",
    "Karvetinagar mandal",
    "Kuppam mandal",
    "Nagari mandal",
    "Nindra mandal",
    "Palamaner mandal",
    "Palasamudram mandal",
    "Peddapanjani mandal",
    "Penumuru mandal",
    "Pulicherla mandal",
    "Punganur mandal",
    "Puthalapattu mandal",
    "Ramakuppam mandal",
    "Rompicherla mandal",
    "Santhipuram mandal",
    "Sodam mandal",
    "Somala mandal",
    "Srirangarajapuram mandal",
    "Thavanampalle mandal",
    "Vedurukuppam mandal",
    "Venkatagirikota mandal",
    "Vijayapuram mandal",
    "Yadamarri mandal",
    "Anaparthi mandal",
    "Biccavolu mandal",
    "Chagallu mandal",
    "Devarapalle mandal",
    "Gokavaram mandal",
    "Gopalapuram mandal",
    "Kadiam mandal",
    "Korukonda Mandal",
    "Kovvur mandal",
    "Nallajerla mandal",
    "Nidadavole mandal",
    "Peravali mandal",
    "Rajahmundry Urban mandal",
    "Rajahmundry Rural mandal",
    "Rajanagaram mandal",
    "Rangampeta mandal",
    "Seethanagaram mandal",
    "Tallapudi mandal",
    "Undrajavaram mandal",
    "Agiripalle mandal",
    "Bhimadole mandal",
    "Buttayagudem mandal",
    "Chatrai mandal",
    "Chintalapudi mandal",
    "Denduluru mandal",
    "Dwaraka Tirumala mandal",
    "Eluru mandal",
    "Jangareddygudem mandal",
    "Jeelugu Milli mandal",
    "Kaikalur mandal",
    "Kalidindi mandal",
    "Kamavarapukota mandal",
    "Koyyalagudem mandal",
    "Kukunoor mandal",
    "Lingapalem mandal",
    "Mandavalli mandal",
    "Mudinepalle mandal",
    "Musunuru mandal",
    "Nidamarru mandal",
    "Nuzvid mandal",
    "Pedapadu mandal",
    "Pedavegi mandal",
    "Polavaram mandal",
    "T. Narasapuram mandal",
    "Unguturu mandal",
    "Velairpadu mandal",
    "Chebrolu mandal",
    "Duggirala mandal",
    "Guntur East mandal",
    "Guntur West mandal",
    "Kakumanu mandal",
    "Kollipara mandal",
    "Mangalagiri mandal",
    "Medikonduru mandal",
    "Pedakakani mandal",
    "Pedanandipadu mandal",
    "Phirangipuram mandal",
    "Ponnur mandal",
    "Prathipadu mandal",
    "Tadepalle mandal",
    "Tadikonda mandal",
    "Tenali mandal",
    "Thullur mandal",
    "Vatticherukuru mandal",
    "Gandepalli mandal",
    "Gollaprolu mandal",
    "Jaggampeta mandal",
    "Kajuluru mandal",
    "Kakinada Rural mandal",
    "Kakinada Urban mandal",
    "Karapa mandal",
    "Kirlampudi mandal",
    "Kotananduru mandal",
    "U.Kothapalli mandal",
    "Pedapudi mandal",
    "Peddapuram mandal",
    "Pithapuram mandal",
    "Prathipadu mandal",
    "Rowthulapudi mandal",
    "Samalkota mandal",
    "Sankhavaram mandal",
    "Thallarevu mandal",
    "Thondangi mandal",
    "Tuni mandal",
    "Yeleswaram mandal",
    "Ainavilli mandal",
    "Alumuru mandal",
    "Allavaram mandal",
    "Amalapuram mandal",
    "Ambajipeta mandal",
    "Atreyapuram mandal",
    "Island Polavaram mandal",
    "Gangavaram mandal",
    "Kapileswarapuram mandal",
    "Katrenikona mandal",
    "Kothapeta mandal",
    "Malikipuram mandal",
    "Mamidikuduru Mandal",
    "Mandapeta mandal",
    "Mummidivaram mandal",
    "Patha Gannavaram mandal",
    "Ramachandrapuram mandal",
    "Ravulapalem mandal",
    "Rayavaram mandal",
    "Razole mandal",
    "Sakhinetipalle mandal",
    "Uppalaguptam mandal",
    "Avanigadda mandal",
    "Bantumilli mandal",
    "Bapulapadu mandal",
    "Challapalli mandal",
    "Gannavaram mandal",
    "Ghantasala mandal",
    "Gudivada mandal",
    "Gudlavalleru mandal",
    "Guduru mandal",
    "Kankipadu mandal",
    "Koduru mandal",
    "Kruthivennu mandal",
    "Machilipatnam North mandal",
    "Machilipatnam South mandal",
    "Mopidevi mandal",
    "Movva mandal",
    "Nagayalanka mandal",
    "Nandivada mandal",
    "Pamarru mandal",
    "Pamidimukkala mandal",
    "Pedana mandal",
    "Pedaparupudi mandal",
    "Penamaluru mandal",
    "Thotlavalluru mandal",
    "Unguturu mandal",
    "Vuyyuru mandal",
    "Adoni mandal",
    "Alur mandal",
    "Aspari mandal",
    "C.Belagal mandal",
    "Chippagiri mandal",
    "Devanakonda mandal",
    "Gonegandla mandal",
    "Gudur mandal",
    "Halaharvi mandal",
    "Holagunda mandal",
    "Kallur mandal",
    "Kodumur mandal",
    "Kosigi mandal",
    "Kowthalam mandal",
    "Krishnagiri mandal",
    "Kurnool Urban mandal",
    "Kurnool Rural mandal",
    "Maddikera East mandal",
    "Mantralayam mandal",
    "Nandavaram mandal",
    "Orvakal mandal",
    "Pattikonda mandal",
    "Pedda Kadubur mandal",
    "Tuggali mandal",
    "Veldurthi mandal",
    "Yemmiganur mandal",
    "Allagadda mandal",
    "Atmakur mandal",
    "Banaganapalle mandal",
    "Bandi Atmakur mandal",
    "Bethamcherla mandal",
    "Chagalamarri mandal",
    "Dhone mandal",
    "Dornipadu mandal",
    "Gadivemula mandal",
    "Gospadu mandal",
    "Jupadu Bungalow mandal",
    "Koilkuntla mandal",
    "Kolimigundla mandal",
    "Kothapalle mandal",
    "Mahanandi mandal",
    "Midthuru mandal",
    "Nandikotkur mandal",
    "Nandyal Rural mandal",
    "Nandyal Urban mandal",
    "Owk mandal",
    "Pagidyala mandal",
    "Pamulapadu mandal",
    "Panyam mandal",
    "Peapally mandal",
    "Rudravaram mandal",
    "Sanjamala mandal",
    "Sirvella mandal",
    "Srisailam mandal",
    "Uyyalawada mandal",
    "Velgodu mandal",
    "A.Konduru mandal",
    "Chandarlapadu Mandal",
    "G.Konduru mandal",
    "Gampalagudem mandal",
    "Ibrahimpatnam mandal",
    "Jaggayyapeta mandal",
    "Kanchikacherla mandal",
    "Mylavaram mandal",
    "Nandigama mandal",
    "Penuganchiprolu mandal",
    "Reddigudem mandal",
    "Tiruvuru mandal",
    "Vatsavai mandal",
    "Veerullapadu mandal",
    "Vijayawada Rural mandal",
    "Vijayawada North mandal",
    "Vijayawada Central mandal",
    "Vijayawada East mandal",
    "Vijayawada West mandal",
    "Vissannapeta mandal",
    "Amaravathi mandal",
    "Atchampet mandal",
    "Bellamkonda mandal",
    "Bollapalle mandal",
    "Chilakaluripet mandal",
    "Dachepalle mandal",
    "Durgi mandal",
    "Edlapadu mandal",
    "Gurazala mandal",
    "Ipuru mandal",
    "Karempudi mandal",
    "Krosuru mandal",
    "Macharla mandal",
    "Machavaram mandal",
    "Muppalla mandal",
    "Nadendla mandal",
    "Narasaraopet mandal",
    "Nekarikallu mandal",
    "Nuzendla mandal",
    "Pedakurapadu mandal",
    "Piduguralla mandal",
    "Rajupalem mandal",
    "Rentachintala mandal",
    "Rompicherla mandal",
    "Sattenapalle mandal",
    "Savalyapuram mandal",
    "Veldurthi mandal",
    "Vinukonda mandal",
    "Balijipeta mandal",
    "Bhamini mandal",
    "Garugubilli mandal",
    "Gummalakshmipuram mandal",
    "Jiyyammavalasa mandal",
    "Komarada mandal",
    "Kurupam mandal",
    "Makkuva mandal",
    "Pachipenta mandal",
    "Palakonda mandal",
    "Parvathipuram mandal",
    "Salur mandal",
    "Seethampeta mandal",
    "Seethanagaram mandal",
    "Veeraghattam mandal",
    "Ardhaveedu mandal",
    "Bestawaripeta mandal",
    "Chandra Sekhara Puram mandal",
    "Chimakurthi mandal",
    "Cumbum mandal",
    "Darsi mandal",
    "Donakonda mandal",
    "Dornala mandal",
    "Giddalur mandal",
    "Hanumanthuni Padu mandal",
    "Kanigiri mandal",
    "Komarolu mandal",
    "Konakanamitla mandal",
    "Kondapi mandal",
    "Kotha Patnam mandal",
    "Kurichedu mandal",
    "Maddipadu mandal",
    "Markapuram mandal",
    "Marripudi mandal",
    "Mundlamuru mandal",
    "Naguluppala Padu mandal",
    "Ongole Rural mandal",
    "Ongole Urban mandal",
    "Pamuru mandal",
    "Peda Araveedu mandal",
    "Pedacherlo Palle mandal",
    "Podili mandal",
    "Ponnaluru mandal",
    "Pullalacheruvu mandal",
    "Racherla mandal",
    "Santhanuthala Padu mandal",
    "Singarayakonda mandal",
    "Tangutur mandal",
    "Tarlupadu mandal",
    "Thallur mandal",
    "Tripuranthakam mandal",
    "Veligandla mandal",
    "Yerragondapalem mandal",
    "Zarugumilli mandal",
    "Allur mandal, Nellore district",
    "Ananthasagaram mandal",
    "Anumasamudrampeta mandal",
    "Atmakuru mandal",
    "Bogolu mandal",
    "Buchireddypalem mandal",
    "Chejerla mandal",
    "Dagadarthi mandal",
    "Duttaluru mandal",
    "Gudluru mandal",
    "Indukurpet mandal",
    "Jaladanki mandal",
    "Kaligiri mandal",
    "Kaluvoya mandal",
    "Kandukur mandal",
    "Kavali mandal",
    "Kodavaluru mandal",
    "Kondapuram mandal",
    "Kovuru mandal",
    "Lingasamudram mandal",
    "Manubolu mandal",
    "Marripadu mandal",
    "Muttukuru mandal",
    "Nellore Urban mandal",
    "Nellore Rural mandal",
    "Podalakuru mandal",
    "Rapuru mandal",
    "Saidapuramu mandal",
    "Sangam mandal",
    "Sitarampuramu mandal",
    "Thotapalligudur mandal",
    "Udayagiri mandal",
    "Ulavapadu mandal",
    "Varikuntapadu mandal",
    "Venkatachalam mandal",
    "Vidavaluru mandal",
    "Vinjamuru mandal",
    "Voletivaripalem mandal",
    "Agali mandal",
    "Amadagur mandal",
    "Amarapuram mandal",
    "Bathalapalle mandal",
    "Bukkapatnam mandal",
    "Chennekothapalle mandal",
    "Chilamathur mandal",
    "Dharmavaram mandal",
    "Gandlapenta mandal",
    "Gorantla mandal",
    "Gudibanda mandal",
    "Hindupur mandal",
    "Kadiri mandal",
    "Kanaganapalle mandal",
    "Kothacheruvu mandal",
    "Lepakshi mandal",
    "Madakasira mandal",
    "Mudigubba mandal",
    "Nallacheruvu mandal",
    "Nallamada mandal",
    "Nambulipulikunta mandal",
    "Obuladevaracheruvu mandal",
    "Parigi mandal",
    "Penukonda mandal",
    "Puttaparthi mandal",
    "Ramagiri mandal",
    "Roddam mandal",
    "Rolla mandal",
    "Somandepalle mandal",
    "Tadimarri mandal",
    "Talupula mandal",
    "Tanakal mandal",
    "Amadalavalasa mandal",
    "Burja mandal",
    "Etcherla mandal",
    "Ganguvarisigadam mandal",
    "Gara mandal",
    "Hiramandalam mandal",
    "Ichchapuram mandal",
    "Jalumuru mandal",
    "Kanchili mandal",
    "Kaviti mandal",
    "Kotabommali mandal",
    "Kothuru mandal",
    "Lakshminarsupeta mandal",
    "Laveru mandal",
    "Mandasa mandal",
    "Meliaputti mandal",
    "Nandigam mandal",
    "Narasannapeta mandal",
    "Palasa Mandal",
    "Pathapatnam mandal",
    "Polaki mandal",
    "Ponduru mandal",
    "Ranastalam mandal",
    "Santhabommali mandal",
    "Saravakota mandal",
    "Sarubujjili mandal",
    "Sompeta mandal",
    "Srikakulam mandal",
    "Tekkali mandal",
    "Vajrapukothuru mandal",
    "Balayapalli mandal",
    "Buchinaidu Kandriga mandal",
    "Chandragiri mandal",
    "Chilakuru mandal",
    "Chinnagottigallu mandal",
    "Chittamuru mandal",
    "Dakkili mandal",
    "Doravarisatramu mandal",
    "Gudur mandal",
    "K.V.B.Puram mandal",
    "Kota mandal",
    "Nagalapuram mandal",
    "Naidupeta mandal",
    "Narayanavanam mandal",
    "Ojili mandal",
    "Pakala mandal",
    "Pellakuru mandal",
    "Pichatur mandal",
    "Puttur mandal",
    "Ramachandrapuram mandal",
    "Renigunta mandal",
    "Satyavedu mandal",
    "Srikalahasti mandal",
    "Sullurpeta mandal",
    "Tada mandal",
    "Thottambedu mandal",
    "Tirupati Rural mandal",
    "Tirupati Urban mandal",
    "Vadamalapeta mandal",
    "Vakadu mandal",
    "Varadaiahpalem mandal",
    "Venkatagiri mandal",
    "Yerpedu mandal",
    "Yerravaripalem mandal",
    "Anandapuram mandal",
    "Bheemunipatnam mandal",
    "Gajuwaka mandal",
    "Gopalapatnam mandal",
    "Maharanipeta mandal",
    "Mulagada mandal",
    "Padmanabham mandal",
    "Pedagantyada mandal",
    "Pendurthi mandal",
    "Seethammadhara mandal",
    "Visakhapatnam Rural mandal",
    "Badangi mandal",
    "Bhogapuram mandal",
    "Bobbili mandal",
    "Bondapalle mandal",
    "Cheepurupalle mandal",
    "Dattirajeru mandal",
    "Denkada mandal",
    "Gajapathinagaram mandal",
    "Gantyada mandal",
    "Garividi mandal",
    "Gurla mandal",
    "Jami mandal",
    "Kothavalasa mandal",
    "Lakkavarapukota mandal",
    "Mentada mandal",
    "Merakamudidam mandal",
    "Nellimarla mandal",
    "Pusapatirega mandal",
    "Rajam mandal",
    "Ramabhadrapuram mandal",
    "Regidi Amadalavalasa mandal",
    "Santhakaviti mandal",
    "Srungavarapukota mandal",
    "Therlam mandal",
    "Vangara mandal",
    "Vepada mandal",
    "Vizianagaram Rural mandal",
    "Vizianagaram Urban mandal",
    "Achanta mandal",
    "Akividu mandal",
    "Attili mandal",
    "Bhimavaram mandal",
    "Ganapavaram mandal",
    "Iragavaram mandal",
    "Kalla mandal",
    "Mogalthur mandal",
    "Palacoderu mandal",
    "Palakollu Mandal",
    "Pentapadu mandal",
    "Penugonda mandal",
    "Penumantra mandal",
    "Poduru mandal",
    "T.Narasapuram mandal",
    "Tadepalligudem mandal",
    "Tanuku mandal",
    "Undi mandal",
    "Veeravasaram mandal",
    "Yelamanchili mandal",
    "Atlur mandal",
    "B.Kodur mandal",
    "Badvel mandal",
    "Brahmamgarimattam mandal",
    "Chakrayapet mandal",
    "Chapad mandal",
    "Chennur mandal",
    "Chinthakommadinne mandal",
    "Duvvur mandal",
    "Gopavaram mandal",
    "Jammalamadugu mandal",
    "Kadapa mandal",
    "Kalasapadu mandal",
    "Kamalapuram mandal",
    "Khajipet mandal",
    "Kondapuram mandal",
    "Lingala mandal",
    "Muddanur mandal",
    "Mylavaram mandal",
    "Peddamudium mandal",
    "Pendlimarri mandal",
    "Porumamilla mandal",
    "Proddatur mandal",
    "Pulivendla mandal",
    "Rajupalem mandal",
    "S.Mydukur mandal",
    "Sidhout mandal",
    "Simhadripuram mandal",
    "Sri Avadhutha Kasinayana mandal",
    "Thondur mandal",
    "Vallur mandal",
    "Veerapunayunipalle mandal",
    "Vempalle mandal",
    "Vemula mandal",
    "Vontimitta mandal",
    "Yerraguntla mandal"
  ];
  List<String> districts = <String>[
    'Please Select your District',
    'Alluri Sitharama Raju',
    'Anakapalli',
    'Anantapuramu',
    'Annamayya',
    'Bapatla',
    'Chittoor',
    'Dr. B. R. Ambedkar Konaseema',
    'East Godavari',
    'Eluru',
    'Guntur',
    'Kadapa',
    'Kakinada',
    'Krishna',
    'Kurnool',
    'Nandyal',
    'Nellore',
    'NTR',
    'Palnadu',
    'Parvathipuram Manyam',
    'Prakasam',
    'Sri Sathya Sai',
    'Srikakulam',
    'Tirupati',
    'Visakhapatnam',
    'Vizianagaram',
    'West Godavari',
  ];

  List<String> asRaju = [
    'Please select your Assembly Constituency',
    'Araku Valley',
    'Paderu',
    'Rampachodavaram'
  ];

  List<String> anakapalli = [
    'Please select your Assembly Constituency',
    'Chodavaram',
    'Madugula',
    'Anakapalle',
    'Pendurthi',
    'Elamanchili',
    'Payakaraopet',
    'Narsipatnam'
  ];

  List<String> anatapur = [
    'Please select your Assembly Constituency',
    'Rayadurg',
    'Uravakonda',
    'Guntakal',
    'Tadipatri',
    'Singanamala',
    'Anantapur Urban',
    'Kalyandurg',
    'Raptadu'
  ];
  List<String> bapatla = [
    'Please select your Assembly Constituency',
    'Vemuru',
    'Repalle',
    'Bapatla',
    'Parchur',
    'Addanki',
    'Chirala'
  ];

  List<String> annamayya = [
    'Please select your Assembly Constituency',
    'Rajampeta',
    'Kodur',
    'Rayachoti',
    'Thamballapalle',
    'Pileru',
    'Madanapalle'
  ];

  List<String> chittoor = [
    'Please select your Assembly Constituency',
    'Punganur',
    'Nagari',
    'Gangadhara Nellore',
    'Chittoor',
    'Puthalapattu',
    'palamaner',
    'Kuppam'
  ];

  List<String> eastGodavari = [
    'Please select your Assembly Constituency',
    'Anaparthy',
    'Rajanagaram',
    'Rajamundry City',
    'Rajahmundry Rural',
    'Kovvur',
    'Nidadavole',
    'Gopalapuram'
  ];
  List<String> eluru = [
    'Please select your Assembly Constituency',
    'Unguturu',
    'Denduluru',
    'Eluru',
    'Polavaram',
    'Chintalapudi',
    'Nuzvid',
    'Kaikalur'
  ];

  List<String> guntur = [
    'Please select your Assembly Constituency',
    'Tadikonda',
    'Mangalagiri',
    'Ponnuru',
    'Tenali',
    'Prathipadu',
    'Guntur West',
    'Guntur East'
  ];

  List<String> westGodavari = [
    'Please select your Assembly Constituency',
    'Achanta',
    'Palakollu',
    'Narasapuram',
    'Bhimavaram',
    'Undi',
    'Tanuku',
    'Tadepalligudem'
  ];

  List<String> vizianagaram = [
    'Please select your Assembly Constituency',
    'Rajam',
    'Bobbili',
    'Cheepurupalli',
    'Gajapathinagaram',
    'Nellimarla',
    'Vizianagaram',
    'Srungavarapukota'
  ];

  List<String> vishakapatnam = [
    'Please select your Assembly Constituency',
    'Bhimili',
    'Vishakapatnam East',
    'Vishakapatnam West',
    'Vishakapatnam South',
    'Vishakapatnam North',
    'Gajuwaka'
  ];

  List<String> tirupati = [
    'Please select your Assembly Constituency',
    'Gudur',
    'Sullurupeta',
    'Venkatagiri',
    'Chandragiri',
    'Tirupati',
    'Srikalahasti',
    'Sathyavedu'
  ];

  List<String> srikakulam = [
    'Please select your Assembly Constituency',
    'Ichchapuram',
    'Palasa',
    'Tekkali',
    'Pathapatnam',
    'Srikakulam',
    'Amadalavalasa',
    'Etcherla',
    'Narasannapeta'
  ];

  List<String> sssai = [
    'Please select your Assembly Constituency',
    'Madakasira',
    'Hindupur',
    'Penukonda',
    'Puttaparthi',
    'Dharmavaram',
    'Kadiri'
  ];

  List<String> prakasam = [
    'Please select your Assembly Constituency',
    'Yerragondapalem',
    'Darsi',
    'Santhanuthalapadu',
    'Ongole',
    'Kondapi',
    'Markapuram',
    'Giddalur',
    'Kanigiri'
  ];

  List<String> palnadu = [
    'Please select your Assembly Constituency',
    'Pedakurapadu',
    'Chilakaluripeta',
    'Narasaraopet',
    'Sattenapalle',
    'Vinukonda',
    'Gurajala',
    'Macherla'
  ];

  List<String> ntr = [
    'Please select your Assembly Constituency',
    'Tiruvuru',
    'Vijayawada West',
    'Vijayawada Central',
    'Vijayawada East',
    'Mylavaram',
    'Nandigama',
    'Jaggayyapeta'
  ];

  List<String> nellore = [
    'Please select your Assembly Constituency',
    'Kandukur',
    'Kavali',
    'Atmakur',
    'Kovur',
    'Nellore City',
    'Nellore Rural',
    'Sarvepalli',
    'Udayagiri'
  ];

  List<String> nandyal = [
    'Please select your Assembly Constituency',
    'Allagadda',
    'Srisailam',
    'Nandikotkur',
    'Panyam',
    'Nandyal',
    'Banaganapalle',
    'Dhone'
  ];

  List<String> kadapa = [
    'Please select your Assembly Constituency',
    'Badvel',
    'Kadapa',
    'Pulivendla',
    'Kamalapuram',
    'Jammalamadugu',
    'Proddatur',
    'Mydukur'
  ];
  List<String> kakinada = [
    'Please select your Assembly Constituency',
    'Tuni',
    'Prathipadu',
    'Pithapuram',
    'Kakinada Rural',
    'Peddapuram',
    'Kakinada City',
    'Jaggampeta'
  ];
  List<String> konaseema = [
    'Please select your Assembly Constituency',
    'Ramachandrapuram',
    'Mummidivaram',
    'Amalapuram',
    'Razole',
    'Gannavaram (konaseema)',
    'Kothapeta',
    'Mandapeta'
  ];
  List<String> krishna = [
    'Please select your Assembly Constituency',
    'Gannavaram',
    'Gudivada',
    'Pedana',
    'Machilipatnam',
    'Avanigadda',
    'Pamarru',
    'Penamaluru'
  ];
  List<String> kurnool = [
    'Please select your Assembly Constituency',
    'Kurnool',
    'Pattikonda',
    'Kodumur',
    'Yemmiganur',
    'Mantralayam',
    'Adoni',
    'Alur'
  ];
  List<String> manyam = [
    'Please select your Assembly Constituency',
    'Palakonda',
    'Kurupam',
    'Parvathipuram',
    'Salur'
  ];
  List<CheckBox> options = [
    CheckBox(title: 'Rising essential commodity prices', checked: false),
    CheckBox(title: 'Drinking water issues', checked: false),
    CheckBox(title: 'Electricity prices', checked: false),
    CheckBox(title: "Women's safety", checked: false),
    CheckBox(title: "Employment opportunities", checked: false),
    CheckBox(title: 'Financial empowerment', checked: false),
    CheckBox(title: 'Maternity Benefits', checked: false),
    CheckBox(title: 'Others', checked: false)
  ];

  List<String> jammalamaduguMadals = [
    "Peddamudium",
    "Mylavaram",
    "Kondapuram",
    "Jammalamadugu"
        "Muddanur"
        "Yerraguntla"
  ];

  List<String> arakuMandals = [
    "Please select your Mandal",
    "Munchingi Puttu",
    "Peda Bayalu",
    "Dumbriguda",
    "Araku Valley",
    "Ananthagiri",
    "Hukumpeta"
  ];

  List<String> kurupamMandals = [
    "Please select your Mandal",
    "Komarada",
    "Gummalakshmipuram",
    "Kurupam",
    "Jiyyammavalasa",
    "Garugubilli"
  ];
  List<String> paderuMandals = [
    "Please select your Mandal",
    "Paderu",
    "G.Madugula",
    "Chintapalle",
    "Gudem Kotha Veedhi",
    "Koyyuru"
  ];
  List<String> palakondaMandals = [
    "Please select your Mandal",
    "Veeraghattam",
    "Seethampeta",
    "Bhamini",
    "Palakonda",
    "Palakonda Town"
  ];
  List<String> parvathipuramMandals = [
    "Please select your Mandal",
    "Parvathipuram",
    "Seethanagaram",
    "Balijipeta",
    "Parvathipuram Town"
  ];
  List<String> rampochodavaramMandals = [
    "Please select your Mandal",
    "Kunavaram",
    "Chintur",
    "Vararamachandrapuram",
    "Maredumilli",
    "Devipatnam",
    "Y. Ramavaram",
    "Addateegala",
    "Rajavommangi",
    "Gangavaram",
    "Rampachodavaram",
    "Nellipaka"
  ];
  List<String> salurMandals = [
    "Please select your Mandal",
    "Makkuva",
    "Salur",
    "Pachipenta",
    "Mentada",
    "Salur Town"
  ];
  List<String> amadalavalsaMandals = [
    "Please select your Mandal",
    "Sarubujjili",
    "Burja",
    "Amadalavalasa",
    "Ponduru",
    "Amadalavalasa Town"
  ];
  List<String> icchapuramMandals = [
    "Please select your Mandal",
    "Kanchili",
    "Ichchapuram",
    "Kaviti",
    "Sompeta",
    "Ichchapuram Town"
  ];
  List<String> narasannapetaMandals = [
    "Please select your Mandal",
    "Saravakota"
        "Jalumuru"
        "Narasannapeta"
        "Polaki"
  ];
  List<String> palasaMandals = [
    "Please select your Mandal",
    "Palasa",
    "Mandasa",
    "Vajrapukothuru",
    "Palasa Kasibugga Town"
  ];
  List<String> pathapatnamMandals = [
    "Please select your Mandal",
    "Kothuru",
    "Pathapatnam",
    "Meliaputti",
    "Hiramandalam",
    "Lakshminarsupeta"
  ];
  List<String> srikakulamMandals = [
    "Please select your Mandal",
    "Gara",
    "Srikakulam",
    "Srikakulam Town"
  ];
  List<String> tekkaliMandals = [
    "Please select your Mandal",
    "Nandigam",
    "Tekkali",
    "Santhabommali",
    "Kotabommali"
  ];
  List<String> bobbiliMandals = [
    "Please select your Mandal",
    "Bobbili",
    "Ramabhadrapuram",
    "Badangi",
    "Therlam",
    "Bobbili Town"
  ];
  List<String> chepurupalliMandals = [
    "Please select your Mandal",
    "Merakamudidam",
    "Garividi",
    "Cheepurupalle",
    "Gurla"
  ];
  List<String> etcherlaMandals = [
    "Please select your Mandal",
    "Ganguvarisigadam",
    "Laveru",
    "Ranastalam",
    "Etcherla"
  ];
  List<String> gajapathinagaramMandals = [
    "Please select your Mandal",
    "Dattirajeru",
    "Gajapathinagaram",
    "Bondapalle",
    "Gantyada",
    "Jami"
  ];
  List<String> nellimarlaMandals = [
    "Please select your Mandal",
    "Nellimarla",
    "Pusapatirega",
    "Denkada",
    "Bhogapuram",
    "NELLIMARLA Town"
  ];
  List<String> rajamMandals = [
    "Please select your Mandal",
    "Vangara",
    "Regidi Amadalavalasa",
    "Santhakaviti",
    "Rajam",
    "RAJAM Town"
  ];
  List<String> vizianagaramMandals = [
    "Please select your Mandal",
    "Vizianagaram",
    "Vizianagaram Town",
    "GVMC,WARD-1",
    "GVMC,WARD-2",
    "GVMC,WARD-3",
    "GVMC,WARD-6",
    "GVMC,WARD-7",
    "GVMC,WARD-8",
    "GVMC,WARD-4",
    "GVMC,WARD-5",
    "GVMC,WARD-98"
  ];
  List<String> bhimiliMandals = [
    "Please select your Mandal",
    "Anandapuram",
    "Padmanabham",
    "Bheemunipatnam",
  ];
  List<String> gajuwakaMandals = [
    "Please select your Mandal",
    "GVMC,WARD-66",
    "GVMC,WARD-67",
    "GVMC,WARD-68",
    "GVMC,WARD-64",
    "GVMC,WARD-65",
    "GVMC,WARD-72",
    "GVMC,WARD-73",
    "GVMC,WARD-74",
    "GVMC,WARD-75",
    "GVMC,WARD-76",
    "GVMC,WARD-79",
    "GVMC,WARD-85",
    "GVMC,WARD-86",
    "GVMC,WARD-87",
    "GVMC,WARD-69",
    "GVMC,WARD-70",
    "GVMC,WARD-71",
  ];
  List<String> srungavarapukotaMandals = [
    "Please select your Mandal",
    "Srungavarapukota",
    "Vepada",
    "Lakkavarapukota",
    "Kothavalasa",
    "Jami-2"
  ];
  List<String> vizagEastMandals = [
    "Please select your Mandal",
    "GVMC",
    "GVMC,WARD-09",
    "GVMC,WARD-10",
    "GVMC,WARD-15",
    "GVMC,WARD-16",
    "GVMC,WARD-17",
    "GVMC,WARD-18",
    "GVMC,WARD-19",
    "GVMC,WARD-20",
    "GVMC,WARD-21",
    "GVMC,WARD-22",
    "GVMC,WARD-23",
    "GVMC,WARD-28",
    "GVMC,WARD-11",
    "GVMC,WARD-12",
    "GVMC	WARD-13"
  ];
  List<String> vizagNorthMandals = [
    "Please select your Mandal",
    "GVMC,WARD-24",
    "GVMC,WARD-25",
    "GVMC,WARD-26",
    "GVMC,WARD-44",
    "GVMC,WARD-14",
    "GVMC,WARD-42",
    "GVMC,WARD-43",
    "GVMC,WARD-45",
    "GVMC,WARD-46",
    "GVMC,WARD-47",
    "GVMC,WARD-48",
    "GVMC,WARD-49",
    "GVMC,WARD-50",
    "GVMC,WARD-51",
    "GVMC,WARD-53",
    "GVMC,WARD-54",
    "GVMC,WARD-55",
  ];
  List<String> vizagSouthMandals = [
    "Please select your Mandal",
    "GVMC,WARD-27",
    "GVMC,WARD-29",
    "GVMC,WARD-30",
    "GVMC,WARD-31",
    "GVMC,WARD-32",
    "GVMC,WARD-33",
    "GVMC,WARD-34",
    "GVMC,WARD-35",
    "GVMC,WARD-37",
    "GVMC,WARD-38",
    "GVMC,WARD-39",
    "GVMC,WARD-41",
    "GVMC,WARD-36",
  ];
  List<String> vizagWestMandals = [
    "Please select your Mandal",
    "GVMC,WARD-40",
    "GVMC,WARD-52",
    "GVMC,WARD-56",
    "GVMC,WARD-58",
    "GVMC,WARD-59",
    "GVMC,WARD-60",
    "GVMC,WARD-61",
    "GVMC,WARD-62",
    "GVMC,WARD-63",
    "GVMC,WARD-90",
    "GVMC,WARD-91",
    "GVMC,WARD-92",
    "GVMC,WARD-57",
  ];
  List<String> anakapalliMandals = [
    "Please select your Mandal",
    "Anakapalle",
    "Kasimkota",
    "GVMC,WARD-80",
    "GVMC,WARD-81",
    "GVMC,WARD-82",
    "GVMC,WARD-83",
    "GVMC,WARD-84",
  ];
  List<String> chodavaramMandals = [
    "Please select your Mandal",
    "Rolugunta",
    "Ravikamatham",
    "Chodavaram",
    "Butchayyapeta"
  ];
  List<String> elamanchiliMandals = [
    "Please select your Mandal",
    "Yelamanchili Town",
    "Munagapaka",
    "Atchutapuram",
    "Yelamanchili",
    "Rambilli"
  ];
  List<String> madugulaMandals = [
    "Please select your Mandal",
    "Madugula",
    "Cheedikada",
    "Devarapalle",
    "K.Kotapadu"
  ];
  List<String> narsipatnamMandals = [
    "Please select your Mandal",
    "NARSIPATNAM Town",
    "Nathavaram",
    "Golugonda",
    "Narsipatnam",
    "Makavarapalem"
  ];
  List<String> payakaroapetMandals = [
    "Please select your Mandal",
    "Kotauratla",
    "Nakkapalle",
    "Payakaraopeta",
    "S.Rayavaram"
  ];
  List<String> pendurthiMandals = [
    "Please select your Mandal",
    "Sabbavaram",
    "Pendurthi",
    "GVMC,WARD-93",
    "GVMC,WARD-94",
    "GVMC,WARD-95",
    "GVMC,WARD-96",
    "GVMC,WARD-97",
    "GVMC,WARD-89",
    "GVMC,WARD-77",
    "GVMC,WARD-78",
    "GVMC,WARD-88",
    "Paravada"
  ];
  List<String> jaggampetaMandals = [
    "Please select your Mandal",
    "Gokavaram",
    "Jaggampeta",
    "Kirlampudi",
    "Gandepalle",
  ];
  List<String> kkdCityMandals = ["Please select your Mandal", "Kakinada Town"];
  List<String> kkdRuralMandals = [
    "Please select your Mandal",
    "Kakinada (Rural)",
    "Karapa"
  ];
  List<String> peddapuramMandals = [
    "Please select your Mandal",
    "Peddapuram",
    "Samalkota",
    "Peddapuram Town",
    "Samalkota Town"
  ];
  List<String> pithapuramMandals = [
    "Please select your Mandal",
    "Gollaprolu",
    "Pithapuram",
    "Kothapalle",
    "Pithapuram Town",
    "Gollaproplu Town"
  ];
  List<String> prathipaduMandals = [
    "Please select your Mandal",
    "Sankhavaram",
    "Yeleswaram",
    "Prathipadu",
    "Rowthulapudi",
    "Yeleshwaram Town"
  ];
  List<String> tuniMandals = [
    "Please select your Mandal",
    "Kotananduru",
    "Tuni",
    "Thondangi",
    "Tuni Town"
  ];
  List<String> amalapuramMandals = [
    "Please select your Mandal",
    "Allavaram",
    "Amalapuram",
    "Uppalaguptam",
    "Amalapuram Town"
  ];
  List<String> gannavaramKSMandals = [
    "Please select your Mandal",
    "Ainavilli",
    "P.Gannavaram",
    "Ambajipeta"
  ];
  List<String> kothapetaMandals = [
    "Please select your Mandal",
    "Atreyapuram",
    "Alamuru",
    "Ravulapalem",
    "Kothapeta"
  ];
  List<String> mandapetaMandals = [
    "Please select your Mandal",
    "Mandapeta",
    "Rayavaram",
    "Kapileswarapuram",
    "Mandapeta Town"
  ];
  List<String> mummidivaramMandals = [
    "Please select your Mandal",
    "Thallarevu",
    "I. Polavaram",
    "Mummidivaram",
    "Katrenikona"
  ];
  List<String> rcpmMandals = [
    "Please select your Mandal",
    "Kajuluru",
    "Ramachandrapuram",
    "K.gangavaram",
    "Ramachandrapuram Town"
  ];
  List<String> razoleMandals = [
    "Please select your Mandal",
    "Mamidikuduru",
    "Razole",
    "Malikipuram",
    "Sakhinetipalle"
  ];
  List<String> anaparthyMandals = [
    "Please select your Mandal",
    "Rangampeta",
    "Pedapudi",
    "Biccavolu",
    "Anaparthy"
  ];
  List<String> gopalapuramMandals = [
    "Please select your Mandal",
    "Gopalapuram",
    "Dwarakatirumala",
    "Nallajerla",
    "Devarapalle"
  ];
  List<String> kovvurMandals = [
    "Please select your Mandal",
    "Tallapudi",
    "Kovvur",
    "Chagallu",
    "Kovvur Town"
  ];
  List<String> nidadavoleMandals = [
    "Please select your Mandal",
    "Nidadavole",
    "Undrajavaram",
    "Peravali",
    "Nidadavole Town"
  ];
  List<String> rjyCityMandals = [
    "Please select your Mandal",
    "Rajahmundry Town"
  ];
  List<String> rjyRuralMandals = [
    "Please select your Mandal",
    "Rajahmundry Rural",
    "Kadiam"
  ];
  List<String> rajanagaramMandals = [
    "Please select your Mandal",
    "Seethanagaram",
    "Korukonda",
    "Rajanagaram"
  ];
  List<String> achantaMandals = [
    "Please select your Mandal",
    "Penumantra",
    "Penugonda",
    "Achanta",
    "Poduru"
  ];
  List<String> bhimavaramMandals = [
    "Please select your Mandal",
    "Veeravasaram",
    "Bhimavaram",
    "Bhimavaram Town"
  ];
  List<String> narsapurMandals = [
    "Please select your Mandal",
    "Mogalthur",
    "Narasapuram",
    "Narsapur Town"
  ];
  List<String> palakolluMandals = [
    "Please select your Mandal",
    "Palacole",
    "Yelamanchili",
    "Palacole Town"
  ];
  List<String> tadepalligudemMandals = [
    "Please select your Mandal",
    "Tadepalligudem",
    "Pentapadu",
    "Tadepalligudem Town"
  ];
  List<String> tanukuMandals = [
    "Please select your Mandal",
    "Tanuku",
    "Attili",
    "Iragavaram",
    "Tanuku Town"
  ];
  List<String> undiMandals = [
    "Please select your Mandal",
    "Akividu",
    "Undi",
    "Palacoderu",
    "Kalla",
    "Akividu Town"
  ];
  List<String> chintalapudiMandals = [
    "Please select your Mandal",
    "Chintalapudi",
    "Lingapalem",
    "Jangareddigudem",
    "Kamavarapukota",
    "JANGAREDDIGUDEM Town",
    "Chintalapudi Town"
  ];
  List<String> dendulurMandals = [
    "Please select your Mandal",
    "Pedavegi",
    "Pedapadu",
    "Denduluru",
    "Eluru"
  ];
  List<String> eluruMandals = ["Please select your Mandal", 'Eluru Town'];

  List<String> vjyCentralMandals = [
    "Please select your Mandal",
    "Vijayawada",
    "Vijayawada,WARD-23",
    "Vijayawada,WARD-24",
    "Vijayawada,WARD-25",
    "Vijayawada,WARD-26",
    "Vijayawada,WARD-27",
    "Vijayawada,WARD-28",
    "Vijayawada,WARD-29",
    "Vijayawada,WARD-30",
    "Vijayawada,WARD-31",
    "Vijayawada,WARD-32",
    "Vijayawada,WARD-33",
    "Vijayawada,WARD-36",
    "Vijayawada,WARD-1",
    "Vijayawada,WARD-57",
    "Vijayawada,WARD-58",
    "Vijayawada,WARD-59",
    "Vijayawada,WARD-60",
    "Vijayawada,WARD-61",
    "Vijayawada,WARD-62",
    "Vijayawada,WARD-63",
    "Vijayawada,WARD-64",
  ];
  List<String> vjyEastMandals = [
    "Please select your Mandal",
    "Vijayawada,WARD-2",
    "Vijayawada,WARD-3",
    "Vijayawada,WARD-4",
    "Vijayawada,WARD-6",
    "Vijayawada,WARD-7",
    "Vijayawada,WARD-8",
    "Vijayawada,WARD-9",
    "Vijayawada,WARD-10",
    "Vijayawada,WARD-11",
    "Vijayawada,WARD-12",
    "Vijayawada,WARD-13",
    "Vijayawada,WARD-14",
    "Vijayawada,WARD-15",
    "Vijayawada,WARD-16",
    "Vijayawada,WARD-17",
    "Vijayawada,WARD-18",
    "Vijayawada,WARD-22",
    "Vijayawada,WARD-5",
    "Vijayawada,WARD-19",
    "Vijayawada,WARD-20",
    "Vijayawada,WARD-21",
  ];
  List<String> vjyWestMandals = [
    "Please select your Mandal",
    "Vijayawada,WARD-34",
    "Vijayawada,WARD-35",
    "Vijayawada,WARD-37",
    "Vijayawada,WARD-38",
    "Vijayawada,WARD-39",
    "Vijayawada,WARD-40",
    "Vijayawada,WARD-41",
    "Vijayawada,WARD-48",
    "Vijayawada,WARD-49",
    "Vijayawada,WARD-50",
    "Vijayawada,WARD-42",
    "Vijayawada,WARD-43",
    "Vijayawada,WARD-44",
    "Vijayawada,WARD-45",
    "Vijayawada,WARD-46",
    "Vijayawada,WARD-47",
    "Vijayawada,WARD-51",
    "Vijayawada,WARD-52",
    "Vijayawada,WARD-53",
    "Vijayawada,WARD-54",
    "Vijayawada,WARD-55",
    "Vijayawada,WARD-56",
  ];
  List<String> kaikaluruMandals = [
    "Please select your Mandal",
    "Mandavalli",
    "Kaikalur",
    "Kalidindi",
    "Mudinepalle"
  ];
  List<String> nuzvidMandals = [
    "Please select your Mandal",
    "Chatrai",
    "Musunuru",
    "Nuzvid",
    "Agiripalle",
    "Nuzvid Town"
  ];
  List<String> polavaramMandals = [
    "Please select your Mandal",
    "Velairpadu",
    "Kukunoor",
    "T.Narasapuram",
    "Jeelugu Milli",
    "Buttayagudem",
    "Polavaram",
    "Koyyalagudem"
  ];
  List<String> unguturuMandals = [
    "Please select your Mandal",
    "Unguturu",
    "Bhimadole",
    "Nidamarru",
    "Ganapavaram"
  ];
  List<String> avanigaddaMandals = [
    "Please select your Mandal",
    "Ghantasala",
    "Challapalle",
    "Mopidevi",
    "Avanigadda",
    "Nagayalanka",
    "Koduru"
  ];
  List<String> gannavaramMandals = [
    "Please select your Mandal",
    "Bapulapadu",
    "Vijayawada (Rural)",
    "Gannavaram",
    "Unguturu"
  ];
  List<String> gudivadaMandals = [
    "Please select your Mandal",
    "Nandivada",
    "Gudivada",
    "Gudlavalleru",
    "Gudivada Town"
  ];
  List<String> machilipatnamMandals = [
    "Please select your Mandal",
    "Machilipatnam",
    "Machilipatnam Town"
  ];
  List<String> pamarruMandals = [
    "Please select your Mandal",
    "Pedaparupudi",
    "Thotlavalluru",
    "Pamidimukkala",
    "Pamarru",
    "Movva"
  ];
  List<String> pedanaMandals = [
    "Please select your Mandal",
    "Kruthivennu",
    "Bantumilli",
    "Pedana",
    "Guduru",
    "Pedana Town"
  ];
  List<String> penamaluruMandals = [
    "Please select your Mandal",
    "Kankipadu",
    "Penamaluru",
    "Vuyyuru",
    "Vuyyuru Town",
    "YSR Tadigadapa"
  ];
  List<String> jaggayyapetMandals = [
    "Please select your Mandal",
    "Vatsavai",
    "Jaggayyapeta",
    "Penuganchiprolu",
    "Jaggayyapeta Town"
  ];
  List<String> mylavaramMandals = [
    "Please select your Mandal",
    "Mylavaram",
    "Reddigudem",
    "G.Konduru",
    "Ibrahimpatnam",
    "Kondapalli"
  ];
  List<String> nandigamaMandals = [
    "Please select your Mandal",
    "Nandigama",
    "Veerullapadu",
    "Kanchikacherla",
    "Chandarlapadu",
    "Nandigama Town"
  ];
  List<String> tiruvuruMandals = [
    "Please select your Mandal",
    "Gampalagudem",
    "Tiruvuru",
    "A.Konduru",
    "Vissannapet",
    "Tiruvuru Town"
  ];
  List<String> gunturEastMandals = ["Please select your Mandal", "Guntur East"];
  List<String> gunturWestMandals = ["Please select your Mandal", "Guntur West"];
  List<String> mangalagiriMandals = [
    "Please select your Mandal",
    "Tadepalle",
    "Mangalagiri",
    "Duggirala",
    "Mangalagiri Town"
  ];
  List<String> ponnurMandals = [
    "Please select your Mandal",
    "Pedakakani",
    "Chebrolu",
    "Ponnur",
    "Ponnur Town"
  ];
  List<String> prathipaduGMandals = [
    "Please select your Mandal",
    "Guntur Rural mandal",
    "Kakumanu",
    "Prathipadu",
    "Pedanandipadu",
    "Vatticherukuru"
  ];
  List<String> tadikondaMandals = [
    "Please select your Mandal",
    "Thullur",
    "Tadikonda",
    "Phirangipuram",
    "Medikonduru"
  ];
  List<String> tenaliMandals = [
    "Please select your Mandal",
    "Kollipara",
    "Tenali",
    "Tenali Town"
  ];
  List<String> chilakaluripetaMandals = [
    "Please select your Mandal",
    "Nadendla",
    "Purushotha Patnam",
    "Edlapadu"
  ];
  List<String> gurajalaMandals = [
    "Please select your Mandal",
    "Gurazala",
    "Dachepalle",
    "Piduguralla",
    "Machavaram",
    "Piduguralla Town",
    "Gurazala Town",
    "Dachepalle Town"
  ];
  List<String> macherlaMandals = [
    "Please select your Mandal",
    "Macherla",
    "Veldurthi",
    "Durgi",
    "Rentachintala",
    "Karempudi",
    "Macherla Town"
  ];
  List<String> narasaraopetMandals = [
    "Please select your Mandal",
    "Rompicherla",
    "Narasaraopet",
    "Narasaraopet"
  ];
  List<String> pedakurapaduMandals = [
    "Please select your Mandal",
    "Bellamkonda",
    "Atchampet",
    "Krosuru",
    "Amaravathi",
    "Pedakurapadu"
  ];
  List<String> sattenapalliMandals = [
    "Please select your Mandal",
    "Sattenapalle",
    "Rajupalem",
    "Nekarikallu",
    "Muppalla",
    "Sattenapalle Town"
  ];
  List<String> vinkuondaMandals = [
    "Please select your Mandal",
    "Bollapalle",
    "Vinukonda",
    "Nuzendla",
    "Savalyapuram HO Kanamarlapudi",
    "Ipur",
    "Vinukonda"
  ];
  List<String> addankiMandals = [
    "Please select your Mandal",
    "Santhamaguluru",
    "Ballikurava",
    "Janakavarampanguluru",
    "Addanki",
    "Korisapadu",
    "Addanki Town"
  ];
  List<String> baptlaMandals = [
    "Please select your Mandal",
    "Pittalavanipalem",
    "Karlapalem",
    "Bapatla",
    "Bapatla Town"
  ];
  List<String> chiralaMandals = [
    "Please select your Mandal",
    "Chirala",
    "Vetapalem",
    "Chirala Town"
  ];
  List<String> parchurMandals = [
    "Please select your Mandal",
    "Martur",
    "Yeddana Pudi",
    "Parchur",
    "Karamchedu",
    "Inkollu",
    "Chinaganjam"
  ];
  List<String> repalleMandals = [
    "Please select your Mandal",
    "Cherukupalle HO Arumbaka",
    "Nizampatnam",
    "Nagaram",
    "Repalle",
    "Repalle Town"
  ];
  List<String> snathanuthalapaduMandals = [
    "Please select your Mandal",
    "Naguluppala Padu",
    "Maddipadu",
    "Chimakurthi",
    "Santhanuthala Padu",
    "Chimakurthy"
  ];
  List<String> vemuruMandals = [
    "Please select your Mandal",
    "Tsundur",
    "Amruthalur",
    "Vemuru",
    "Kollur",
    "Bhattiprolu"
  ];
  List<String> darsiMandals = [
    "Please select your Mandal",
    "Donakonda",
    "Kurichedu",
    "Mundlamuru",
    "Darsi",
    "Thallur",
    "Darsi Town"
  ];
  List<String> giddaluruMandals = [
    "Please select your Mandal",
    "Ardhaveedu",
    "Cumbum",
    "Bestawaripeta",
    "Racherla",
    "Giddalur",
    "Komarolu",
    "GIDDALUR TOWN"
  ];
  List<String> kanigiriMandals = [
    "Please select your Mandal",
    "Hanumanthuni Padu",
    "Veligandla",
    "Kanigiri",
    "Pedacherlo Palle",
    "Chandra Sekhara Puram",
    "Pamur",
    "KANIGIRI TOWN"
  ];
  List<String> kondepiMandals = [
    "Please select your Mandal",
    "Marripudi",
    "Kondapi",
    "Tangutur",
    "Zarugumilli",
    "Ponnaluru",
    "Singarayakonda",
  ];
  List<String> markapurMandals = [
    "Please select your Mandal",
    "Markapur",
    "Tarlupadu",
    "Konakanamitla",
    "Podili",
    "Markapur Town",
    "Podili Town"
  ];
  List<String> ongoleMandals = [
    "Please select your Mandal",
    "Ongole",
    "Kotha Patnam",
    "Ongole Town"
  ];
  List<String> yerragondapalemMandals = [
    "Please select your Mandal",
    "Yerragondapalem",
    "Pullalacheruvu",
    "Tripuranthakam",
    "Dornala",
    "Peda Araveedu"
  ];
  List<String> allagaddaMandals = [
    "Please select your Mandal",
    "Sirvel",
    "Rudravaram",
    "Allagadda",
    "Dornipadu",
    "Uyyalawada",
    "Chagalamarri",
    "ALLAGADDA Town"
  ];
  List<String> banaganapalleMandals = [
    "Please select your Mandal",
    "Banaganapalle",
    "Owk",
    "Koilkuntla",
    "Sanjamala",
    "Kolimigundla"
  ];
  List<String> dhoneMandals = [
    "Please select your Mandal",
    "Bethamcherla",
    "Dhone",
    "Peapally",
    "Dhone Town",
    "Bethamcherla Town"
  ];
  List<String> nandikotkuruMandals = [
    "Please select your Mandal",
    "Nandikotkur",
    "Pagidyala",
    "Jupadu Bungalow",
    "Kothapalle",
    "Pamulapadu",
    "Midthur",
    "NANDIKOTKUR TOWN"
  ];
  List<String> nandyalMandals = [
    "Please select your Mandal",
    "Nandyal",
    "Gospadu",
    "Nandyal Town"
  ];
  List<String> panyamMandals = [
    "Please select your Mandal",
    "Kallur",
    "Orvakal",
    "Panyam",
    "Gadivemula"
  ];
  List<String> srisailamMandals = [
    "Please select your Mandal",
    "Srisailam",
    "Atmakur",
    "Velgode",
    "Bandi Atmakur",
    "Mahanandi",
    "Atmakuru Town"
  ];
  List<String> adoniMandals = [
    "Please select your Mandal",
    "Adoni",
    "Adoni Town"
  ];
  List<String> alurMandals = [
    "Please select your Mandal",
    "Holagunda",
    "Halaharvi",
    "Alur",
    "Aspari",
    "Devanakonda",
    "Chippagiri"
  ];
  List<String> kodumurMandals = [
    "Please select your Mandal",
    "C.Belagal",
    "C Belagala Town",
    "Gudur",
    "Kurnool",
    "Kodumur",
    "GUDUR Town"
  ];
  List<String> kurnoolMandals = ["Please select your Mandal", "Kurnool Town"];
  List<String> matralayamMandals = [
    "Please select your Mandal",
    "Mantralayam",
    "Kosigi",
    "Kowthalam",
    "Pedda Kadubur"
  ];
  List<String> pattikondaMandals = [
    "Please select your Mandal",
    "Krishnagiri",
    "Veldurthi",
    "Pattikonda",
    "Maddikera (East)",
    "Tuggali"
  ];
  List<String> yemmiagnurMandals = [
    "Please select your Mandal",
    "Yemmiganur",
    "Nandavaram",
    "Gonegandla",
    "Yemmiganur Town"
  ];
  List<String> anatapurUrbanMandals = ["Please select your Mandal", "Anatapur"];
  List<String> guntakalMandals = [
    "Please select your Mandal",
    "Guntakal",
    "Gooty",
    "Pamidi",
    "Guntakal Town",
    "GOOTY Town",
    "Pamidi"
  ];
  List<String> kalyandurgMandals = [
    "Please select your Mandal",
    "Brahmasamudram",
    "Brahmasamudram Town",
    "Kalyandurg",
    "Settur",
    "Kundurpi",
    "Kambadur",
    "KALYANDURG Town"
  ];
  List<String> rayadurgMandals = [
    "Please select your Mandal",
    "D.Hirehal",
    "Rayadurg",
    "Kanekal",
    "Bommanahal",
    "Gummagatta",
    "Rayadurg Town"
  ];
  List<String> singanamalaMandals = [
    "Please select your Mandal",
    "Garladinne",
    "Singanamala",
    "Putlur",
    "Yellanur",
    "Narpala",
    "B.K. Samudram"
  ];
  List<String> tadipatriMandals = [
    "Please select your Mandal",
    "Peddavadugur",
    "Yadiki",
    "Tadpatri",
    "Peddapappur",
    "Tadpatri Town"
  ];
  List<String> uravakondaMandals = [
    "Please select your Mandal",
    "Vidapanakal",
    "Vajrakarur",
    "Uravakonda",
    "Beluguppa",
    "Kudair"
  ];
  List<String> dharmavaramMandals = [
    "Please select your Mandal",
    "Dharmavaram",
    "Bathalapalle",
    "Tadimarri",
    "Mudigubba",
    "Dharmavaram Town"
  ];
  List<String> hindupurMandals = [
    "Please select your Mandal",
    "Hindupur",
    "Lepakshi",
    "Chilamathur",
    "Hindupur Town"
  ];
  List<String> kadiriMandals = [
    "Please select your Mandal",
    "Talupula",
    "Nambulipulikunta",
    "Gandlapenta",
    "Kadiri",
    "Nallacheruvu",
    "Tanakal",
    "Kadiri Town"
  ];
  List<String> madakasiraMandals = [
    "Please select your Mandal",
    "Madakasira",
    "Amarapuram",
    "Gudibanda",
    "Rolla",
    "Agali",
    "Madakasira"
  ];
  List<String> penukondaMandals = [
    "Please select your Mandal",
    "Roddam",
    "Parigi",
    "Penukonda",
    "Gorantla",
    "Somandepalle",
    "Penukonda Town"
  ];
  List<String> puttaparthiMandals = [
    "Please select your Mandal",
    "Nallamada",
    "Bukkapatnam",
    "Kothacheruvu",
    "Puttaparthi",
    "Obuladevaracheruvu",
    "Amadagur",
    "Puttaparthi Town"
  ];
  List<String> raptaduMandals = [
    "Please select your Mandal",
    "Atmakur",
    "Anantapur Rural",
    "Raptadu",
    "Kanaganapalle",
    "Chennekothapalle",
    "Ramagiri"
  ];
  List<String> badvelMandals = [
    "Please select your Mandal",
    "Sri Avadhutha Kasinayana",
    "Kalasapadu",
    "Porumamilla",
    "B.Kodur",
    "Badvel",
    "Gopavaram",
    "Atlur",
    "Badvel Town",
    "Yerraguntla"
  ];
  List<String> kadapaMandals = ["Please select your Mandal", "Cuddapah"];
  List<String> kamalapuramMandals = [
    "Please select your Mandal",
    "Veerapunayunipalle",
    "Kamalapuram",
    "Vallur",
    "Chennur",
    "Chinthakommadinne",
    "Pendlimarri",
    "Kamalapuram Town"
  ];
  List<String> mydukurMandals = [
    "Please select your Mandal",
    "Duvvur",
    "S.Mydukur",
    "Brahmamgarimattam",
    "Khajipet",
    "Chapad",
    "Mydukur Town"
  ];
  List<String> proddaturMandals = [
    "Please select your Mandal",
    "Rajupalem",
    "Proddatur",
    "Proddatur Town"
  ];
  List<String> pulivendulaMandals = [
    "Please select your Mandal",
    "Simhadripuram",
    "Lingala",
    "Pulivendla",
    "Vemula",
    "Thondur",
    "Vempalle",
    "Chakrayapet",
    "Pulivendla Town"
  ];
  List<String> atmakurMandals = [
    "Please select your Mandal",
    "Marripadu",
    "Atmakur",
    "Anumasamudrampeta",
    "Sangam",
    "Chejerla",
    "Ananthasagaram",
    "Atmakur Town"
  ];
  List<String> kandukurMandals = [
    "Please select your Mandal",
    "Voletivaripalem",
    "Kandukur",
    "Lingasamudram",
    "Gudluru",
    "Ulavapadu",
    "KANDUKUR TOWN"
  ];
  List<String> kavaliMandals = [
    "Please select your Mandal",
    "Kavali",
    "Bogole",
    "Dagadarthi",
    "Allur",
    "Kavali Town",
    "Allur Town"
  ];

  List<String> kovurMandals = [
    "Please select your Mandal",
    "Vidavalur",
    "Kodavalur",
    "Buchireddipalem",
    "Kovur",
    "Indukurpet",
    "Buchireddipalem Town"
  ];
  List<String> nelloreCityMandals = [
    "Please select your Mandal",
    "Nellore City"
  ];
  List<String> nelloreRuralMandals = [
    "Please select your Mandal",
    "Nellore rural"
  ];
  List<String> udayagiriMandals = [
    "Please select your Mandal",
    "Seetharamapuram",
    "Udayagiri",
    "Varikuntapadu",
    "Kondapuram",
    "Jaladanki",
    "Kaligiri",
    "Vinjamur",
    "Duttalur"
  ];
  List<String> guduruMandals = [
    "Please select your Mandal",
    "Gudur",
    "Chillakur",
    "Kota",
    "Vakadu",
    "Chittamur",
    "Gudur Town"
  ];
  List<String> sarvepalliMandals = [
    "Please select your Mandal",
    "Podalakur",
    "Thotapalligudur",
    "Muthukur",
    "Venkatachalam",
    "Manubolu"
  ];
  List<String> satyaveduMandals = [
    "Please select your Mandal",
    "Buchinaidu Kandriga",
    "Varadaiahpalem",
    "K.V.B.Puram",
    "Narayanavanam",
    "Pichatur",
    "Satyavedu",
    "Nagalapuram"
  ];
  List<String> srikalahasthiMandals = [
    "Please select your Mandal",
    "Renigunta",
    "Yerpedu",
    "Srikalahasti",
    "Thottambedu",
    "Srikalahasti Town"
  ];
  List<String> sullurpetMandals = [
    "Please select your Mandal",
    "Ojili",
    "Naidupet",
    "Pellakur",
    "Doravarisatram",
    "Sullurpeta",
    "Tada",
    "Naidupeta Town",
    "Sullurpet Town"
  ];
  List<String> tirupatiMandals = ["Please select your Mandal", "Tirupati"];
  List<String> venkatagiriMandals = [
    "Please select your Mandal",
    "Kaluvoya",
    "Rapur",
    "Sydapuram",
    "Dakkili",
    "Venkatagiri",
    "Balayapalle",
    "Venkatagiri Town"
  ];
  List<String> kodurMandals = [
    "Please select your Mandal",
    "Penagalur",
    "Chitvel",
    "Pullampeta",
    "Obulavaripalle",
    "Kodur"
  ];
  List<String> madanepalleMandals = [
    "Please select your Mandal",
    "Madanapalle",
    "Nimmanapalle",
    "Ramasamudram",
    "Madanapalle Town"
  ];
  List<String> pileruMandals = [
    "Please select your Mandal",
    "Gurramkonda",
    "Kalakada",
    "Kambhamvaripalle",
    "Pileru",
    "Kalikiri",
    "Valmikipuram"
  ];
  List<String> punganurMandals = [
    "Please select your Mandal",
    "Rompicherla",
    "Sodam",
    "Pulicherla",
    "Somala",
    "Chowdepalle",
    "Punganur",
    "Punganur Town"
  ];
  List<String> rajampetMandals = [
    "Please select your Mandal",
    "Vontimitta",
    "Sidhout",
    "T Sundupalle",
    "Veeraballe",
    "Nandalur",
    "Rajampet",
    "Rajampet Town"
  ];
  List<String> rayachotiMandals = [
    "Please select your Mandal",
    "Galiveedu",
    "Chinnamandem",
    "Sambepalle",
    "Rayachoti",
    "Lakkireddipalle",
    "Ramapuram",
    "Rayachoti Town"
  ];
  List<String> thamballapalleMandals = [
    "Please select your Mandal",
    "Mulakalacheruvu",
    "Thamballapalle",
    "Peddamandyam",
    "Kurabalakota",
    "Pedda Thippasamudram",
    "B.Kothakota",
    "B.Kothakota Town"
  ];
  List<String> chandragiriMandals = [
    "Please select your Mandal",
    "Yerravaripalem",
    "Tirupati (Rural)",
    "Chandragiri",
    "Chinnagottigallu",
    "Pakala",
    "Ramachandrapuram"
  ];
  List<String> chittoorMandals = [
    "Please select your Mandal",
    "Chittoor",
    "Gudipala",
    "Chittoor Town"
  ];
  List<String> gangadharaNelloreMandals = [
    "Please select your Mandal",
    "Vedurukuppam",
    "Karvetinagar",
    "Penumuru",
    "Srirangarajapuram",
    "Gangadhara Nellore",
    "Palasamudram"
  ];
  List<String> kuppamMandals = [
    "Please select your Mandal",
    "Santhipuram",
    "Gudupalle",
    "Kuppam",
    "Ramakuppam",
    "Kuppam Town"
  ];
  List<String> nagariMandals = [
    "Please select your Mandal",
    "Vadamalapeta",
    "Nindra",
    "Vijayapuram",
    "Nagari",
    "Puttur Town",
    "Nagari Town",
    "Puttur"
  ];
  List<String> palamanerMandals = [
    "Please select your Mandal",
    "Peddapanjani",
    "Gangavaram",
    "Palamaner",
    "Baireddipalle",
    "Venkatagirikota",
    "Palamaner Town"
  ];
  List<String> puthalapattuMandals = [
    "Please select your Mandal",
    "Puthalapattu",
    "Irala",
    "Thavanampalle",
    "Bangarupalem",
    "Yadamarri"
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
    if (formKey.currentState!.validate()) {
      DialogBuilder(context).showLoadingIndicator("Please wait while loading!");
      showLoaderOTP = true;
      String id = randomIdGenerator();
      checkID(context, id);
      if (uniqueCode.text.isNotEmpty) {
        checkNumber(context, phone, id);
      }
      notifyListeners();
    }
  }

  checkNumber(BuildContext context, String phone, String id) {
    _db
        .collection('users')
        .where("phone", isEqualTo: phone)
        .get()
        .then((value) {
      Navigator.of(context, rootNavigator: true).pop();

      showAlert(context, "Error",
          "User is already registered \n with this UID: ${value.docs.first.get("id")} ");

      enableOTPtext = false;

      showLoaderOTP = false;
      notifyListeners();
    }).catchError((err) {
      sendSMS(context, phone, id);
      notifyListeners();
    });
  }

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
        //print('Select country: ${country.displayName}');
        // print(country.countryCode);
        // print(country.phoneCode);
        setCC(country.phoneCode);
      },
    );
  }

  // sendToPdf(BuildContext context) {
  //   List<String> schems = setSchemes();
  //   DateTime dt = DateTime.now();
  //   List<Map<String,dynamic>> fList = [];
  //   List<Map<String,dynamic>> sList = [];
  //   List<Map<String,dynamic>> wList = [];
  //   List<Map<String,dynamic>> uEMPList = [];
  //   if (farmers > 0) {
  //     for (int i = 0; i < farmersFields.length; i++) {
  //       fList.add(PersonDetails(
  //           age: int.parse(farmersAgeController[i].text),
  //           name: farmersController[i].text).toJson());
  //     }
  //   }
  //   //PersonDetailsList farmerList = PersonDetailsList(pdList: fList);

  //   if (students > 0) {
  //     for (int i = 0; i < studentFields.length; i++) {
  //       sList.add(PersonDetails(
  //           age: int.parse(studentsAgeController[i].text),
  //           name: studentsController[i].text).toJson());
  //     }
  //   }

  //   //PersonDetailsList studentList = PersonDetailsList(pdList: sList);
  //   if (womenAbv > 0) {
  //     for (int i = 0; i < womenFields.length; i++) {
  //       wList.add(PersonDetails(
  //           age: int.parse(womenAgeController[i].text),
  //           name: womenController[i].text).toJson());
  //     }
  //   }

  //   //PersonDetailsList womentList = PersonDetailsList(pdList: wList);
  //   if (unEMployedYouth > 0) {
  //     for (int i = 0; i < uEmpYouthFields.length; i++) {
  //       uEMPList.add(PersonDetails(
  //           age: int.parse(uEmpYouthAgeController[i].text),
  //           name: uEmpYouthController[i].text).toJson());
  //     }
  //   }

  //    RegistrationModel rModel = RegistrationModel(
  //       name: name.text,
  //       age: age.text,
  //       constituency: selectedConstituency,
  //       district: sDistrcts,
  //       mandal: sMandals,
  //       address: address.text,
  //       pincode: pincode.text,
  //       vNum: vNumController.text.isNotEmpty ? vNumController.text : "",
  //       vName: vName.text.isNotEmpty ? vName.text : "",
  //       number: "$cc${phoneTextController.text}",
  //       gender: gender,
  //       isVerified: isVerified,
  //       date: dt.toIso8601String(),
  //       id: uniqueCode.text.isNotEmpty ? uniqueCode.text : "",
  //       scheme: schems,
  //       totalFam: famMembers,
  //       totalFarmers: farmers,
  //       totalStudents: students,
  //       totalUnEmployedYouth: unEMployedYouth,
  //       totalWomen: womenAbv,
  //       fatherNamefield: fatherNamefield.text,
  //       farmersList: fList,
  //       womenList: wList,
  //       studentList: sList,
  //       uEMPList: uEMPList);

  //    //print("${wList.first.toJson()}");
  //   //AppConstants.moveNextstl(context, MyPDF(rModel: rModel));
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

  void registerUser(BuildContext context) {
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

    // print("${wList.first}");
    // print(fList.toList());

    // PersonDetailsList? famdetails = PersonDetailsList(
    //     uList: uEMPList,
    //     womenList: wList,
    //     studentList: sList,
    //     farmerList: fList);

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
        uEMPList: uEMPList);

    _db
        .collection('users')
        .doc("$cc${phoneTextController.text}")
        .set(rModel.toJSON())
        .then((value) {
      showLoader = false;
      Navigator.of(context, rootNavigator: true).pop();
      AppConstants.showSnackBar(context, "Registration Successfully done");
      apiRequest.sendFinalMsg(
          "$cc${phoneTextController.text}", rModel.id ?? "");
      AppConstants.moveNextClearAll(
          context,
          MyPDF(
            rModel: rModel,
          ));
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

  setQRValues(BuildContext context) async {
    final qrResults = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const QRViewExample(), fullscreenDialog: true),
    );
    if (qrResults != null) {
      String qrcode = qrResults.code;
      List<String> uID = qrcode.split("/");
      // print("uid:${uID.last}");
      uniqueCode = TextEditingController(text: uID.last);
      // print(uniqueCode.text);
    }

    notifyListeners();
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

  // searchVolunteer(BuildContext context) async {
  //  // print("number:${FirebaseAuth.instance.currentUser!.phoneNumber}");
  //   showLoader = true;
  //   var body = await _db
  //       .collection('Mahashakti_volunteers')
  //       .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
  //       .get();
  //   if (body.data() != null) {
  //    // print("Mobile:${body.data()}");

  //     //print(body['name']);
  //     //print(data);
  //     VRegistration vRegistration = VRegistration(
  //         name: body['name'] ?? "",
  //         phone: body['phone'],
  //         constituency: body['constituency'] ?? "",
  //         district: body['district'] ?? "",
  //         mandal: body['mandal'] ?? "",
  //         panchayat: body['panchayat'] ?? "");

  //     // AppConstants.moveNextstl(
  //     //     context,
  //     //     VolunteerRegistration(
  //     //       vRegistration: vRegistration,
  //     //     ));

  //   } else {
  //     VRegistration vRegistration = VRegistration(
  //         name: '',
  //         phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? "",
  //         constituency: '',
  //         district: '',
  //         mandal: '',
  //         panchayat: '');
  //     // AppConstants.moveNextstl(
  //     //     context,
  //     //     VolunteerRegistration(
  //     //       vRegistration: vRegistration,
  //     //     ));
  //   }
  //   notifyListeners();
  // }

  // // updateVolunteer(BuildContext context) async {
  //   VRegistration vRegistration = VRegistration(
  //       name: name.text,
  //       phone: FirebaseAuth.instance.currentUser!.phoneNumber,
  //       constituency: selectedConstituency,
  //       district: sDistrcts,
  //       mandal: sMandals,
  //       panchayat: gpController.text);
  //   FirebaseAuth.instance.currentUser!.updateDisplayName(name.text);
  //  // print(vRegistration.toJSON());
  //   showLoader = true;

  //   _db
  //       .collection('Mahashakti_volunteers')
  //       .doc('${FirebaseAuth.instance.currentUser!.phoneNumber}')
  //       .set(vRegistration.toJSON())
  //       .then((value) {
  //     showLoader = false;
  //     AppConstants.showSnackBar(
  //         context, "Volunteer Registration Successfully done");
  //     AppConstants.moveNextClearAll(context, const HomeScreen());
  //   });

  //   notifyListeners();
  // }

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
}


///
///