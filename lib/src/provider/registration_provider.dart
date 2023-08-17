// ignore_for_file: use_build_context_synchronously

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../src/network/api_request.dart';
import '../../src/view/registration/qr.dart';
import '../../src/utils/loading_indicator.dart';
import '../model/checkbox.dart';
import '../model/reg_model.dart';
import '../model/v_reg_model.dart';
import '../utils/app_utils.dart';

import '../view/home_screen.dart';

class RegistrationProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String selectedConstituency = '';
  bool showSubmit = false;
  int selectedRadio = 0;
  int selectedURadio = 0;
  int selectedGRadio = 0;
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
  //TextEditingController vNUM = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController uniqueCode = TextEditingController();
  bool showLoader = false;
  String gender = '';

  String cc = "91";
  String sDistrcts = '';
  String sMandals = '';
  int famMembers = 0;
  int farmers = 0;
  int womenAbv = 0;
  int unEMployedYouth = 0;
  int students = 0;
  bool showLoaderOTP = false;

  List<int> famMem = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  setFamMembers(int value) {
    famMembers = value;
    notifyListeners();
  }

  setFarmers(int value) {
    farmers = value;
    notifyListeners();
  }

  setunEMployed(int value) {
    unEMployedYouth = value;
    notifyListeners();
  }

  setStudents(int value) {
    students = value;
    notifyListeners();
  }

  setNoOFWomen(int value) {
    womenAbv = value;
    notifyListeners();
  }

  List<String> sendList(String value) {
    if (value.isNotEmpty && value != 'Select the district') {
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
        return ['please select the District'];
      }
    } else {
      return ['please select the District'];
    }
  }

  List<String> sendMandalList(String value) {
    if (value.isNotEmpty && value != 'please select the District' ||
        value != 'please select the Assembly Constituency') {
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
        return ['please select the Assembly Constituency'];
      }
    } else {
      return ['please select the Assembly Constituency'];
    }
  }

  List<String> mandals = [
    "please select the mandal",
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
    'Select the district',
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
    'please select the Assembly Constituency',
    'Araku Valley',
    'Paderu',
    'Rampachodavaram'
  ];

  List<String> anakapalli = [
    'please select the Assembly Constituency',
    'Chodavaram',
    'Madugula',
    'Anakapalle',
    'Pendurthi',
    'Elamanchili',
    'Payakaraopet',
    'Narsipatnam'
  ];

  List<String> anatapur = [
    'please select the Assembly Constituency',
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
    'please select the Assembly Constituency',
    'Vemuru',
    'Repalle',
    'Bapatla',
    'Parchur',
    'Addanki',
    'Chirala'
  ];

  List<String> annamayya = [
    'please select the Assembly Constituency',
    'Rajampeta',
    'Kodur',
    'Rayachoti',
    'Thamballapalle',
    'Pileru',
    'Madanapalle'
  ];

  List<String> chittoor = [
    'please select the Assembly Constituency',
    'Punganur',
    'Nagari',
    'Gangadhara Nellore',
    'Chittoor',
    'Puthalapattu',
    'palamaner',
    'Kuppam'
  ];

  List<String> eastGodavari = [
    'please select the Assembly Constituency',
    'Anaparthy',
    'Rajanagaram',
    'Rajamundry City',
    'Rajahmundry Rural',
    'Kovvur',
    'Nidadavole',
    'Gopalapuram'
  ];
  List<String> eluru = [
    'please select the Assembly Constituency',
    'Unguturu',
    'Denduluru',
    'Eluru',
    'Polavaram',
    'Chintalapudi',
    'Nuzvid',
    'Kaikalur'
  ];

  List<String> guntur = [
    'please select the Assembly Constituency',
    'Tadikonda',
    'Mangalagiri',
    'Ponnuru',
    'Tenali',
    'Prathipadu',
    'Guntur West',
    'Guntur East'
  ];

  List<String> westGodavari = [
    'please select the Assembly Constituency',
    'Achanta',
    'Palakollu',
    'Narasapuram',
    'Bhimavaram',
    'Undi',
    'Tanuku',
    'Tadepalligudem'
  ];

  List<String> vizianagaram = [
    'please select the Assembly Constituency',
    'Rajam',
    'Bobbili',
    'Cheepurupalli',
    'Gajapathinagaram',
    'Nellimarla',
    'Vizianagaram',
    'Srungavarapukota'
  ];

  List<String> vishakapatnam = [
    'please select the Assembly Constituency',
    'Bhimili',
    'Vishakapatnam East',
    'Vishakapatnam West',
    'Vishakapatnam South',
    'Vishakapatnam North',
    'Gajuwaka'
  ];

  List<String> tirupati = [
    'please select the Assembly Constituency',
    'Gudur',
    'Sullurupeta',
    'Venkatagiri',
    'Chandragiri',
    'Tirupati',
    'Srikalahasti',
    'Sathyavedu'
  ];

  List<String> srikakulam = [
    'please select the Assembly Constituency',
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
    'please select the Assembly Constituency',
    'Madakasira',
    'Hindupur',
    'Penukonda',
    'Puttaparthi',
    'Dharmavaram',
    'Kadiri'
  ];

  List<String> prakasam = [
    'please select the Assembly Constituency',
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
    'please select the Assembly Constituency',
    'Pedakurapadu',
    'Chilakaluripeta',
    'Narasaraopet',
    'Sattenapalle',
    'Vinukonda',
    'Gurajala',
    'Macherla'
  ];

  List<String> ntr = [
    'please select the Assembly Constituency',
    'Tiruvuru',
    'Vijayawada West',
    'Vijayawada Central',
    'Vijayawada East',
    'Mylavaram',
    'Nandigama',
    'Jaggayyapeta'
  ];

  List<String> nellore = [
    'please select the Assembly Constituency',
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
    'please select the Assembly Constituency',
    'Allagadda',
    'Srisailam',
    'Nandikotkur',
    'Panyam',
    'Nandyal',
    'Banaganapalle',
    'Dhone'
  ];

  List<String> kadapa = [
    'please select the Assembly Constituency',
    'Badvel',
    'Kadapa',
    'Pulivendla',
    'Kamalapuram',
    'Jammalamadugu',
    'Proddatur',
    'Mydukur'
  ];
  List<String> kakinada = [
    'please select the Assembly Constituency',
    'Tuni',
    'Prathipadu',
    'Pithapuram',
    'Kakinada Rural',
    'Peddapuram',
    'Kakinada City',
    'Jaggampeta'
  ];
  List<String> konaseema = [
    'please select the Assembly Constituency',
    'Ramachandrapuram',
    'Mummidivaram',
    'Amalapuram',
    'Razole',
    'Gannavaram (konaseema)',
    'Kothapeta',
    'Mandapeta'
  ];
  List<String> krishna = [
    'please select the Assembly Constituency',
    'Gannavaram',
    'Gudivada',
    'Pedana',
    'Machilipatnam',
    'Avanigadda',
    'Pamarru',
    'Penamaluru'
  ];
  List<String> kurnool = [
    'please select the Assembly Constituency',
    'Kurnool',
    'Pattikonda',
    'Kodumur',
    'Yemmiganur',
    'Mantralayam',
    'Adoni',
    'Alur'
  ];
  List<String> manyam = [
    'please select the Assembly Constituency',
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
    "please select the mandal",
    "Munchingi Puttu",
    "Peda Bayalu",
    "Dumbriguda",
    "Araku Valley",
    "Ananthagiri",
    "Hukumpeta"
  ];

  List<String> kurupamMandals = [
    "please select the mandal",
    "Komarada",
    "Gummalakshmipuram",
    "Kurupam",
    "Jiyyammavalasa",
    "Garugubilli"
  ];
  List<String> paderuMandals = [
    "please select the mandal",
    "Paderu",
    "G.Madugula",
    "Chintapalle",
    "Gudem Kotha Veedhi",
    "Koyyuru"
  ];
  List<String> palakondaMandals = [
    "please select the mandal",
    "Veeraghattam",
    "Seethampeta",
    "Bhamini",
    "Palakonda",
    "Palakonda Town"
  ];
  List<String> parvathipuramMandals = [
    "please select the mandal",
    "Parvathipuram",
    "Seethanagaram",
    "Balijipeta",
    "Parvathipuram Town"
  ];
  List<String> rampochodavaramMandals = [
    "please select the mandal",
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
    "please select the mandal",
    "Makkuva",
    "Salur",
    "Pachipenta",
    "Mentada",
    "Salur Town"
  ];
  List<String> amadalavalsaMandals = [
    "please select the mandal",
    "Sarubujjili",
    "Burja",
    "Amadalavalasa",
    "Ponduru",
    "Amadalavalasa Town"
  ];
  List<String> icchapuramMandals = [
    "please select the mandal",
    "Kanchili",
    "Ichchapuram",
    "Kaviti",
    "Sompeta",
    "Ichchapuram Town"
  ];
  List<String> narasannapetaMandals = [
    "please select the mandal",
    "Saravakota"
        "Jalumuru"
        "Narasannapeta"
        "Polaki"
  ];
  List<String> palasaMandals = [
    "please select the mandal",
    "Palasa",
    "Mandasa",
    "Vajrapukothuru",
    "Palasa Kasibugga Town"
  ];
  List<String> pathapatnamMandals = [
    "please select the mandal",
    "Kothuru",
    "Pathapatnam",
    "Meliaputti",
    "Hiramandalam",
    "Lakshminarsupeta"
  ];
  List<String> srikakulamMandals = [
    "please select the mandal",
    "Gara",
    "Srikakulam",
    "Srikakulam Town"
  ];
  List<String> tekkaliMandals = [
    "please select the mandal",
    "Nandigam",
    "Tekkali",
    "Santhabommali",
    "Kotabommali"
  ];
  List<String> bobbiliMandals = [
    "please select the mandal",
    "Bobbili",
    "Ramabhadrapuram",
    "Badangi",
    "Therlam",
    "Bobbili Town"
  ];
  List<String> chepurupalliMandals = [
    "please select the mandal",
    "Merakamudidam",
    "Garividi",
    "Cheepurupalle",
    "Gurla"
  ];
  List<String> etcherlaMandals = [
    "please select the mandal",
    "Ganguvarisigadam",
    "Laveru",
    "Ranastalam",
    "Etcherla"
  ];
  List<String> gajapathinagaramMandals = [
    "please select the mandal",
    "Dattirajeru",
    "Gajapathinagaram",
    "Bondapalle",
    "Gantyada",
    "Jami"
  ];
  List<String> nellimarlaMandals = [
    "please select the mandal",
    "Nellimarla",
    "Pusapatirega",
    "Denkada",
    "Bhogapuram",
    "NELLIMARLA Town"
  ];
  List<String> rajamMandals = [
    "please select the mandal",
    "Vangara",
    "Regidi Amadalavalasa",
    "Santhakaviti",
    "Rajam",
    "RAJAM Town"
  ];
  List<String> vizianagaramMandals = [
    "please select the mandal",
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
    "please select the mandal",
    "Anandapuram",
    "Padmanabham",
    "Bheemunipatnam",
  ];
  List<String> gajuwakaMandals = [
    "please select the mandal",
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
    "please select the mandal",
    "Srungavarapukota",
    "Vepada",
    "Lakkavarapukota",
    "Kothavalasa",
    "Jami-2"
  ];
  List<String> vizagEastMandals = [
    "please select the mandal",
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
    "please select the mandal",
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
    "please select the mandal",
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
    "please select the mandal",
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
    "please select the mandal",
    "Anakapalle",
    "Kasimkota",
    "GVMC,WARD-80",
    "GVMC,WARD-81",
    "GVMC,WARD-82",
    "GVMC,WARD-83",
    "GVMC,WARD-84",
  ];
  List<String> chodavaramMandals = [
    "please select the mandal",
    "Rolugunta",
    "Ravikamatham",
    "Chodavaram",
    "Butchayyapeta"
  ];
  List<String> elamanchiliMandals = [
    "please select the mandal",
    "Yelamanchili Town",
    "Munagapaka",
    "Atchutapuram",
    "Yelamanchili",
    "Rambilli"
  ];
  List<String> madugulaMandals = [
    "please select the mandal",
    "Madugula",
    "Cheedikada",
    "Devarapalle",
    "K.Kotapadu"
  ];
  List<String> narsipatnamMandals = [
    "please select the mandal",
    "NARSIPATNAM Town",
    "Nathavaram",
    "Golugonda",
    "Narsipatnam",
    "Makavarapalem"
  ];
  List<String> payakaroapetMandals = [
    "please select the mandal",
    "Kotauratla",
    "Nakkapalle",
    "Payakaraopeta",
    "S.Rayavaram"
  ];
  List<String> pendurthiMandals = [
    "please select the mandal",
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
    "please select the mandal",
    "Gokavaram",
    "Jaggampeta",
    "Kirlampudi",
    "Gandepalle",
  ];
  List<String> kkdCityMandals = ["please select the mandal", "Kakinada Town"];
  List<String> kkdRuralMandals = [
    "please select the mandal",
    "Kakinada (Rural)",
    "Karapa"
  ];
  List<String> peddapuramMandals = [
    "please select the mandal",
    "Peddapuram",
    "Samalkota",
    "Peddapuram Town",
    "Samalkota Town"
  ];
  List<String> pithapuramMandals = [
    "please select the mandal",
    "Gollaprolu",
    "Pithapuram",
    "Kothapalle",
    "Pithapuram Town",
    "Gollaproplu Town"
  ];
  List<String> prathipaduMandals = [
    "please select the mandal",
    "Sankhavaram",
    "Yeleswaram",
    "Prathipadu",
    "Rowthulapudi",
    "Yeleshwaram Town"
  ];
  List<String> tuniMandals = [
    "please select the mandal",
    "Kotananduru",
    "Tuni",
    "Thondangi",
    "Tuni Town"
  ];
  List<String> amalapuramMandals = [
    "please select the mandal",
    "Allavaram",
    "Amalapuram",
    "Uppalaguptam",
    "Amalapuram Town"
  ];
  List<String> gannavaramKSMandals = [
    "please select the mandal",
    "Ainavilli",
    "P.Gannavaram",
    "Ambajipeta"
  ];
  List<String> kothapetaMandals = [
    "please select the mandal",
    "Atreyapuram",
    "Alamuru",
    "Ravulapalem",
    "Kothapeta"
  ];
  List<String> mandapetaMandals = [
    "please select the mandal",
    "Mandapeta",
    "Rayavaram",
    "Kapileswarapuram",
    "Mandapeta Town"
  ];
  List<String> mummidivaramMandals = [
    "please select the mandal",
    "Thallarevu",
    "I. Polavaram",
    "Mummidivaram",
    "Katrenikona"
  ];
  List<String> rcpmMandals = [
    "please select the mandal",
    "Kajuluru",
    "Ramachandrapuram",
    "K.gangavaram",
    "Ramachandrapuram Town"
  ];
  List<String> razoleMandals = [
    "please select the mandal",
    "Mamidikuduru",
    "Razole",
    "Malikipuram",
    "Sakhinetipalle"
  ];
  List<String> anaparthyMandals = [
    "please select the mandal",
    "Rangampeta",
    "Pedapudi",
    "Biccavolu",
    "Anaparthy"
  ];
  List<String> gopalapuramMandals = [
    "please select the mandal",
    "Gopalapuram",
    "Dwarakatirumala",
    "Nallajerla",
    "Devarapalle"
  ];
  List<String> kovvurMandals = [
    "please select the mandal",
    "Tallapudi",
    "Kovvur",
    "Chagallu",
    "Kovvur Town"
  ];
  List<String> nidadavoleMandals = [
    "please select the mandal",
    "Nidadavole",
    "Undrajavaram",
    "Peravali",
    "Nidadavole Town"
  ];
  List<String> rjyCityMandals = [
    "please select the mandal",
    "Rajahmundry Town"
  ];
  List<String> rjyRuralMandals = [
    "please select the mandal",
    "Rajahmundry Rural",
    "Kadiam"
  ];
  List<String> rajanagaramMandals = [
    "please select the mandal",
    "Seethanagaram",
    "Korukonda",
    "Rajanagaram"
  ];
  List<String> achantaMandals = [
    "please select the mandal",
    "Penumantra",
    "Penugonda",
    "Achanta",
    "Poduru"
  ];
  List<String> bhimavaramMandals = [
    "please select the mandal",
    "Veeravasaram",
    "Bhimavaram",
    "Bhimavaram Town"
  ];
  List<String> narsapurMandals = [
    "please select the mandal",
    "Mogalthur",
    "Narasapuram",
    "Narsapur Town"
  ];
  List<String> palakolluMandals = [
    "please select the mandal",
    "Palacole",
    "Yelamanchili",
    "Palacole Town"
  ];
  List<String> tadepalligudemMandals = [
    "please select the mandal",
    "Tadepalligudem",
    "Pentapadu",
    "Tadepalligudem Town"
  ];
  List<String> tanukuMandals = [
    "please select the mandal",
    "Tanuku",
    "Attili",
    "Iragavaram",
    "Tanuku Town"
  ];
  List<String> undiMandals = [
    "please select the mandal",
    "Akividu",
    "Undi",
    "Palacoderu",
    "Kalla",
    "Akividu Town"
  ];
  List<String> chintalapudiMandals = [
    "please select the mandal",
    "Chintalapudi",
    "Lingapalem",
    "Jangareddigudem",
    "Kamavarapukota",
    "JANGAREDDIGUDEM Town",
    "Chintalapudi Town"
  ];
  List<String> dendulurMandals = [
    "please select the mandal",
    "Pedavegi",
    "Pedapadu",
    "Denduluru",
    "Eluru"
  ];
  List<String> eluruMandals = ["please select the mandal", 'Eluru Town'];

  List<String> vjyCentralMandals = [
    "please select the mandal",
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
    "please select the mandal",
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
    "please select the mandal",
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
    "please select the mandal",
    "Mandavalli",
    "Kaikalur",
    "Kalidindi",
    "Mudinepalle"
  ];
  List<String> nuzvidMandals = [
    "please select the mandal",
    "Chatrai",
    "Musunuru",
    "Nuzvid",
    "Agiripalle",
    "Nuzvid Town"
  ];
  List<String> polavaramMandals = [
    "please select the mandal",
    "Velairpadu",
    "Kukunoor",
    "T.Narasapuram",
    "Jeelugu Milli",
    "Buttayagudem",
    "Polavaram",
    "Koyyalagudem"
  ];
  List<String> unguturuMandals = [
    "please select the mandal",
    "Unguturu",
    "Bhimadole",
    "Nidamarru",
    "Ganapavaram"
  ];
  List<String> avanigaddaMandals = [
    "please select the mandal",
    "Ghantasala",
    "Challapalle",
    "Mopidevi",
    "Avanigadda",
    "Nagayalanka",
    "Koduru"
  ];
  List<String> gannavaramMandals = [
    "please select the mandal",
    "Bapulapadu",
    "Vijayawada (Rural)",
    "Gannavaram",
    "Unguturu"
  ];
  List<String> gudivadaMandals = [
    "please select the mandal",
    "Nandivada",
    "Gudivada",
    "Gudlavalleru",
    "Gudivada Town"
  ];
  List<String> machilipatnamMandals = [
    "please select the mandal",
    "Machilipatnam",
    "Machilipatnam Town"
  ];
  List<String> pamarruMandals = [
    "please select the mandal",
    "Pedaparupudi",
    "Thotlavalluru",
    "Pamidimukkala",
    "Pamarru",
    "Movva"
  ];
  List<String> pedanaMandals = [
    "please select the mandal",
    "Kruthivennu",
    "Bantumilli",
    "Pedana",
    "Guduru",
    "Pedana Town"
  ];
  List<String> penamaluruMandals = [
    "please select the mandal",
    "Kankipadu",
    "Penamaluru",
    "Vuyyuru",
    "Vuyyuru Town",
    "YSR Tadigadapa"
  ];
  List<String> jaggayyapetMandals = [
    "please select the mandal",
    "Vatsavai",
    "Jaggayyapeta",
    "Penuganchiprolu",
    "Jaggayyapeta Town"
  ];
  List<String> mylavaramMandals = [
    "please select the mandal",
    "Mylavaram",
    "Reddigudem",
    "G.Konduru",
    "Ibrahimpatnam",
    "Kondapalli"
  ];
  List<String> nandigamaMandals = [
    "please select the mandal",
    "Nandigama",
    "Veerullapadu",
    "Kanchikacherla",
    "Chandarlapadu",
    "Nandigama Town"
  ];
  List<String> tiruvuruMandals = [
    "please select the mandal",
    "Gampalagudem",
    "Tiruvuru",
    "A.Konduru",
    "Vissannapet",
    "Tiruvuru Town"
  ];
  List<String> gunturEastMandals = ["please select the mandal", "Guntur East"];
  List<String> gunturWestMandals = ["please select the mandal", "Guntur West"];
  List<String> mangalagiriMandals = [
    "please select the mandal",
    "Tadepalle",
    "Mangalagiri",
    "Duggirala",
    "Mangalagiri Town"
  ];
  List<String> ponnurMandals = [
    "please select the mandal",
    "Pedakakani",
    "Chebrolu",
    "Ponnur",
    "Ponnur Town"
  ];
  List<String> prathipaduGMandals = [
    "please select the mandal",
    "Guntur Rural mandal",
    "Kakumanu",
    "Prathipadu",
    "Pedanandipadu",
    "Vatticherukuru"
  ];
  List<String> tadikondaMandals = [
    "please select the mandal",
    "Thullur",
    "Tadikonda",
    "Phirangipuram",
    "Medikonduru"
  ];
  List<String> tenaliMandals = [
    "please select the mandal",
    "Kollipara",
    "Tenali",
    "Tenali Town"
  ];
  List<String> chilakaluripetaMandals = [
    "please select the mandal",
    "Nadendla",
    "Purushotha Patnam",
    "Edlapadu"
  ];
  List<String> gurajalaMandals = [
    "please select the mandal",
    "Gurazala",
    "Dachepalle",
    "Piduguralla",
    "Machavaram",
    "Piduguralla Town",
    "Gurazala Town",
    "Dachepalle Town"
  ];
  List<String> macherlaMandals = [
    "please select the mandal",
    "Macherla",
    "Veldurthi",
    "Durgi",
    "Rentachintala",
    "Karempudi",
    "Macherla Town"
  ];
  List<String> narasaraopetMandals = [
    "please select the mandal",
    "Rompicherla",
    "Narasaraopet",
    "Narasaraopet"
  ];
  List<String> pedakurapaduMandals = [
    "please select the mandal",
    "Bellamkonda",
    "Atchampet",
    "Krosuru",
    "Amaravathi",
    "Pedakurapadu"
  ];
  List<String> sattenapalliMandals = [
    "please select the mandal",
    "Sattenapalle",
    "Rajupalem",
    "Nekarikallu",
    "Muppalla",
    "Sattenapalle Town"
  ];
  List<String> vinkuondaMandals = [
    "please select the mandal",
    "Bollapalle",
    "Vinukonda",
    "Nuzendla",
    "Savalyapuram HO Kanamarlapudi",
    "Ipur",
    "Vinukonda"
  ];
  List<String> addankiMandals = [
    "please select the mandal",
    "Santhamaguluru",
    "Ballikurava",
    "Janakavarampanguluru",
    "Addanki",
    "Korisapadu",
    "Addanki Town"
  ];
  List<String> baptlaMandals = [
    "please select the mandal",
    "Pittalavanipalem",
    "Karlapalem",
    "Bapatla",
    "Bapatla Town"
  ];
  List<String> chiralaMandals = [
    "please select the mandal",
    "Chirala",
    "Vetapalem",
    "Chirala Town"
  ];
  List<String> parchurMandals = [
    "please select the mandal",
    "Martur",
    "Yeddana Pudi",
    "Parchur",
    "Karamchedu",
    "Inkollu",
    "Chinaganjam"
  ];
  List<String> repalleMandals = [
    "please select the mandal",
    "Cherukupalle HO Arumbaka",
    "Nizampatnam",
    "Nagaram",
    "Repalle",
    "Repalle Town"
  ];
  List<String> snathanuthalapaduMandals = [
    "please select the mandal",
    "Naguluppala Padu",
    "Maddipadu",
    "Chimakurthi",
    "Santhanuthala Padu",
    "Chimakurthy"
  ];
  List<String> vemuruMandals = [
    "please select the mandal",
    "Tsundur",
    "Amruthalur",
    "Vemuru",
    "Kollur",
    "Bhattiprolu"
  ];
  List<String> darsiMandals = [
    "please select the mandal",
    "Donakonda",
    "Kurichedu",
    "Mundlamuru",
    "Darsi",
    "Thallur",
    "Darsi Town"
  ];
  List<String> giddaluruMandals = [
    "please select the mandal",
    "Ardhaveedu",
    "Cumbum",
    "Bestawaripeta",
    "Racherla",
    "Giddalur",
    "Komarolu",
    "GIDDALUR TOWN"
  ];
  List<String> kanigiriMandals = [
    "please select the mandal",
    "Hanumanthuni Padu",
    "Veligandla",
    "Kanigiri",
    "Pedacherlo Palle",
    "Chandra Sekhara Puram",
    "Pamur",
    "KANIGIRI TOWN"
  ];
  List<String> kondepiMandals = [
    "please select the mandal",
    "Marripudi",
    "Kondapi",
    "Tangutur",
    "Zarugumilli",
    "Ponnaluru",
    "Singarayakonda",
  ];
  List<String> markapurMandals = [
    "please select the mandal",
    "Markapur",
    "Tarlupadu",
    "Konakanamitla",
    "Podili",
    "Markapur Town",
    "Podili Town"
  ];
  List<String> ongoleMandals = [
    "please select the mandal",
    "Ongole",
    "Kotha Patnam",
    "Ongole Town"
  ];
  List<String> yerragondapalemMandals = [
    "please select the mandal",
    "Yerragondapalem",
    "Pullalacheruvu",
    "Tripuranthakam",
    "Dornala",
    "Peda Araveedu"
  ];
  List<String> allagaddaMandals = [
    "please select the mandal",
    "Sirvel",
    "Rudravaram",
    "Allagadda",
    "Dornipadu",
    "Uyyalawada",
    "Chagalamarri",
    "ALLAGADDA Town"
  ];
  List<String> banaganapalleMandals = [
    "please select the mandal",
    "Banaganapalle",
    "Owk",
    "Koilkuntla",
    "Sanjamala",
    "Kolimigundla"
  ];
  List<String> dhoneMandals = [
    "please select the mandal",
    "Bethamcherla",
    "Dhone",
    "Peapally",
    "Dhone Town",
    "Bethamcherla Town"
  ];
  List<String> nandikotkuruMandals = [
    "please select the mandal",
    "Nandikotkur",
    "Pagidyala",
    "Jupadu Bungalow",
    "Kothapalle",
    "Pamulapadu",
    "Midthur",
    "NANDIKOTKUR TOWN"
  ];
  List<String> nandyalMandals = [
    "please select the mandal",
    "Nandyal",
    "Gospadu",
    "Nandyal Town"
  ];
  List<String> panyamMandals = [
    "please select the mandal",
    "Kallur",
    "Orvakal",
    "Panyam",
    "Gadivemula"
  ];
  List<String> srisailamMandals = [
    "please select the mandal",
    "Srisailam",
    "Atmakur",
    "Velgode",
    "Bandi Atmakur",
    "Mahanandi",
    "Atmakuru Town"
  ];
  List<String> adoniMandals = [
    "please select the mandal",
    "Adoni",
    "Adoni Town"
  ];
  List<String> alurMandals = [
    "please select the mandal",
    "Holagunda",
    "Halaharvi",
    "Alur",
    "Aspari",
    "Devanakonda",
    "Chippagiri"
  ];
  List<String> kodumurMandals = [
    "please select the mandal",
    "C.Belagal",
    "C Belagala Town",
    "Gudur",
    "Kurnool",
    "Kodumur",
    "GUDUR Town"
  ];
  List<String> kurnoolMandals = ["please select the mandal", "Kurnool Town"];
  List<String> matralayamMandals = [
    "please select the mandal",
    "Mantralayam",
    "Kosigi",
    "Kowthalam",
    "Pedda Kadubur"
  ];
  List<String> pattikondaMandals = [
    "please select the mandal",
    "Krishnagiri",
    "Veldurthi",
    "Pattikonda",
    "Maddikera (East)",
    "Tuggali"
  ];
  List<String> yemmiagnurMandals = [
    "please select the mandal",
    "Yemmiganur",
    "Nandavaram",
    "Gonegandla",
    "Yemmiganur Town"
  ];
  List<String> anatapurUrbanMandals = ["please select the mandal", "Anatapur"];
  List<String> guntakalMandals = [
    "please select the mandal",
    "Guntakal",
    "Gooty",
    "Pamidi",
    "Guntakal Town",
    "GOOTY Town",
    "Pamidi"
  ];
  List<String> kalyandurgMandals = [
    "please select the mandal",
    "Brahmasamudram",
    "Brahmasamudram Town",
    "Kalyandurg",
    "Settur",
    "Kundurpi",
    "Kambadur",
    "KALYANDURG Town"
  ];
  List<String> rayadurgMandals = [
    "please select the mandal",
    "D.Hirehal",
    "Rayadurg",
    "Kanekal",
    "Bommanahal",
    "Gummagatta",
    "Rayadurg Town"
  ];
  List<String> singanamalaMandals = [
    "please select the mandal",
    "Garladinne",
    "Singanamala",
    "Putlur",
    "Yellanur",
    "Narpala",
    "B.K. Samudram"
  ];
  List<String> tadipatriMandals = [
    "please select the mandal",
    "Peddavadugur",
    "Yadiki",
    "Tadpatri",
    "Peddapappur",
    "Tadpatri Town"
  ];
  List<String> uravakondaMandals = [
    "please select the mandal",
    "Vidapanakal",
    "Vajrakarur",
    "Uravakonda",
    "Beluguppa",
    "Kudair"
  ];
  List<String> dharmavaramMandals = [
    "please select the mandal",
    "Dharmavaram",
    "Bathalapalle",
    "Tadimarri",
    "Mudigubba",
    "Dharmavaram Town"
  ];
  List<String> hindupurMandals = [
    "please select the mandal",
    "Hindupur",
    "Lepakshi",
    "Chilamathur",
    "Hindupur Town"
  ];
  List<String> kadiriMandals = [
    "please select the mandal",
    "Talupula",
    "Nambulipulikunta",
    "Gandlapenta",
    "Kadiri",
    "Nallacheruvu",
    "Tanakal",
    "Kadiri Town"
  ];
  List<String> madakasiraMandals = [
    "please select the mandal",
    "Madakasira",
    "Amarapuram",
    "Gudibanda",
    "Rolla",
    "Agali",
    "Madakasira"
  ];
  List<String> penukondaMandals = [
    "please select the mandal",
    "Roddam",
    "Parigi",
    "Penukonda",
    "Gorantla",
    "Somandepalle",
    "Penukonda Town"
  ];
  List<String> puttaparthiMandals = [
    "please select the mandal",
    "Nallamada",
    "Bukkapatnam",
    "Kothacheruvu",
    "Puttaparthi",
    "Obuladevaracheruvu",
    "Amadagur",
    "Puttaparthi Town"
  ];
  List<String> raptaduMandals = [
    "please select the mandal",
    "Atmakur",
    "Anantapur Rural",
    "Raptadu",
    "Kanaganapalle",
    "Chennekothapalle",
    "Ramagiri"
  ];
  List<String> badvelMandals = [
    "please select the mandal",
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
  List<String> kadapaMandals = ["please select the mandal", "Cuddapah"];
  List<String> kamalapuramMandals = [
    "please select the mandal",
    "Veerapunayunipalle",
    "Kamalapuram",
    "Vallur",
    "Chennur",
    "Chinthakommadinne",
    "Pendlimarri",
    "Kamalapuram Town"
  ];
  List<String> mydukurMandals = [
    "please select the mandal",
    "Duvvur",
    "S.Mydukur",
    "Brahmamgarimattam",
    "Khajipet",
    "Chapad",
    "Mydukur Town"
  ];
  List<String> proddaturMandals = [
    "please select the mandal",
    "Rajupalem",
    "Proddatur",
    "Proddatur Town"
  ];
  List<String> pulivendulaMandals = [
    "please select the mandal",
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
    "please select the mandal",
    "Marripadu",
    "Atmakur",
    "Anumasamudrampeta",
    "Sangam",
    "Chejerla",
    "Ananthasagaram",
    "Atmakur Town"
  ];
  List<String> kandukurMandals = [
    "please select the mandal",
    "Voletivaripalem",
    "Kandukur",
    "Lingasamudram",
    "Gudluru",
    "Ulavapadu",
    "KANDUKUR TOWN"
  ];
  List<String> kavaliMandals = [
    "please select the mandal",
    "Kavali",
    "Bogole",
    "Dagadarthi",
    "Allur",
    "Kavali Town",
    "Allur Town"
  ];

  List<String> kovurMandals = [
    "please select the mandal",
    "Vidavalur",
    "Kodavalur",
    "Buchireddipalem",
    "Kovur",
    "Indukurpet",
    "Buchireddipalem Town"
  ];
  List<String> nelloreCityMandals = [
    "please select the mandal",
    "Nellore City"
  ];
  List<String> nelloreRuralMandals = [
    "please select the mandal",
    "Nellore rural"
  ];
  List<String> udayagiriMandals = [
    "please select the mandal",
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
    "please select the mandal",
    "Gudur",
    "Chillakur",
    "Kota",
    "Vakadu",
    "Chittamur",
    "Gudur Town"
  ];
  List<String> sarvepalliMandals = [
    "please select the mandal",
    "Podalakur",
    "Thotapalligudur",
    "Muthukur",
    "Venkatachalam",
    "Manubolu"
  ];
  List<String> satyaveduMandals = [
    "please select the mandal",
    "Buchinaidu Kandriga",
    "Varadaiahpalem",
    "K.V.B.Puram",
    "Narayanavanam",
    "Pichatur",
    "Satyavedu",
    "Nagalapuram"
  ];
  List<String> srikalahasthiMandals = [
    "please select the mandal",
    "Renigunta",
    "Yerpedu",
    "Srikalahasti",
    "Thottambedu",
    "Srikalahasti Town"
  ];
  List<String> sullurpetMandals = [
    "please select the mandal",
    "Ojili",
    "Naidupet",
    "Pellakur",
    "Doravarisatram",
    "Sullurpeta",
    "Tada",
    "Naidupeta Town",
    "Sullurpet Town"
  ];
  List<String> tirupatiMandals = ["please select the mandal", "Tirupati"];
  List<String> venkatagiriMandals = [
    "please select the mandal",
    "Kaluvoya",
    "Rapur",
    "Sydapuram",
    "Dakkili",
    "Venkatagiri",
    "Balayapalle",
    "Venkatagiri Town"
  ];
  List<String> kodurMandals = [
    "please select the mandal",
    "Penagalur",
    "Chitvel",
    "Pullampeta",
    "Obulavaripalle",
    "Kodur"
  ];
  List<String> madanepalleMandals = [
    "please select the mandal",
    "Madanapalle",
    "Nimmanapalle",
    "Ramasamudram",
    "Madanapalle Town"
  ];
  List<String> pileruMandals = [
    "please select the mandal",
    "Gurramkonda",
    "Kalakada",
    "Kambhamvaripalle",
    "Pileru",
    "Kalikiri",
    "Valmikipuram"
  ];
  List<String> punganurMandals = [
    "please select the mandal",
    "Rompicherla",
    "Sodam",
    "Pulicherla",
    "Somala",
    "Chowdepalle",
    "Punganur",
    "Punganur Town"
  ];
  List<String> rajampetMandals = [
    "please select the mandal",
    "Vontimitta",
    "Sidhout",
    "T Sundupalle",
    "Veeraballe",
    "Nandalur",
    "Rajampet",
    "Rajampet Town"
  ];
  List<String> rayachotiMandals = [
    "please select the mandal",
    "Galiveedu",
    "Chinnamandem",
    "Sambepalle",
    "Rayachoti",
    "Lakkireddipalle",
    "Ramapuram",
    "Rayachoti Town"
  ];
  List<String> thamballapalleMandals = [
    "please select the mandal",
    "Mulakalacheruvu",
    "Thamballapalle",
    "Peddamandyam",
    "Kurabalakota",
    "Pedda Thippasamudram",
    "B.Kothakota",
    "B.Kothakota Town"
  ];
  List<String> chandragiriMandals = [
    "please select the mandal",
    "Yerravaripalem",
    "Tirupati (Rural)",
    "Chandragiri",
    "Chinnagottigallu",
    "Pakala",
    "Ramachandrapuram"
  ];
  List<String> chittoorMandals = [
    "please select the mandal",
    "Chittoor",
    "Gudipala",
    "Chittoor Town"
  ];
  List<String> gangadharaNelloreMandals = [
    "please select the mandal",
    "Vedurukuppam",
    "Karvetinagar",
    "Penumuru",
    "Srirangarajapuram",
    "Gangadhara Nellore",
    "Palasamudram"
  ];
  List<String> kuppamMandals = [
    "please select the mandal",
    "Santhipuram",
    "Gudupalle",
    "Kuppam",
    "Ramakuppam",
    "Kuppam Town"
  ];
  List<String> nagariMandals = [
    "please select the mandal",
    "Vadamalapeta",
    "Nindra",
    "Vijayapuram",
    "Nagari",
    "Puttur Town",
    "Nagari Town",
    "Puttur"
  ];
  List<String> palamanerMandals = [
    "please select the mandal",
    "Peddapanjani",
    "Gangavaram",
    "Palamaner",
    "Baireddipalle",
    "Venkatagirikota",
    "Palamaner Town"
  ];
  List<String> puthalapattuMandals = [
    "please select the mandal",
    "Puthalapattu",
    "Irala",
    "Thavanampalle",
    "Bangarupalem",
    "Yadamarri"
  ];
  HashMap<String, CheckBox> optionSelected = HashMap();

  String verificatioID = '';

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
      return "please Select the role";
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
      return "please Select the district";
    } else {
      sDistrcts = value;
      selectedConstituency = '';
      sMandals = '';
      //sendList(value);
    }
    notifyListeners();
  }

  setMandals(String value) {
    print(value);
    //formKey.currentState!.validate();
    if (value == "Select Mandal") {
      sMandals = '';
      return "please Select the Mandal";
    } else {
      sMandals = value;
    }
    print(sMandals);
    notifyListeners();
  }

  verifyPhone(BuildContext context, String phone) async {
    if (formKey.currentState!.validate()) {
      DialogBuilder(context)
          .showLoadingIndicator("Please wait while we are sending UID to Registered Number");
      // print(showLoaderOTP);
      Future.delayed(const Duration(seconds: 1));
      //var credential = PhoneAuthProvider.credential(verificationId: , smsCode: smsCodeController.text);
      try {
        
        notifyListeners();
      } catch (e) {
        showLoaderOTP = false;
        Navigator.of(context, rootNavigator: true).pop();
        AppConstants.showSnackBar(context, e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  otpVerify(BuildContext context) async {
    DialogBuilder(context)
        .showLoadingIndicator("Please wait while we verifying the OTP ");
    // print("e.toString()");
    // print(verificatioID);
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificatioID, smsCode: otpTextController.text))
          .then((value) async {
        if (value.user != null) {
          showLoader = false;
          Navigator.of(context, rootNavigator: true).pop();
          AppConstants.showSnackBar(
              context, "User number verified Successfully");
          isVerified = true;
          showSubmit = true;
          FirebaseAuth.instance.signOut();

          // AppConstants.moveNextClearAll(context, const ProfileScreen());
        }
      });
    } catch (e) {
      showLoader = false;
      Navigator.of(context, rootNavigator: true).pop();
      AppConstants.showSnackBar(context, e.toString());
      //verifyPhone(context, phoneTextController.text);
      // print(e.toString());
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
        id: uniqueCode.text.isNotEmpty?uniqueCode.text:"",
        scheme: schems,
        totalFam: famMembers,
        totalFarmers: farmers,
        totalStudents: students,
        totalUnEmployedYouth: unEMployedYouth,
        totalWomen: womenAbv);

    _db
        .collection('users')
        .doc("$cc${phoneTextController.text}")
        .set(rModel.toJSON())
        .then((value) {
      showLoader = false;
      Navigator.of(context, rootNavigator: true).pop();
      AppConstants.showSnackBar(context, "Registration Successfully done");
      AppConstants.moveNextClearAll(context, const HomeScreen());
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
      print(uniqueCode.text);
    }

    notifyListeners();
  }

  setSelectedRadio(int? val) {
    selectedRadio = val!;
    // print("${val}selected");

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