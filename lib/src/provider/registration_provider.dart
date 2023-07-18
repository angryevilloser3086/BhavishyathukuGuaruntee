// ignore_for_file: use_build_context_synchronously

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/checkbox.dart';
import '../../model/reg_model.dart';
import '../../model/v_reg_model.dart';
import '../../utils/app_utils.dart';

import '../view/home_screen.dart';

class RegistrationProvider extends ChangeNotifier {
  String selectedConstituency = '';
  bool showSubmit = false;
  int selectedRadio = 0;
  int selectedGRadio = 0;
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
  bool showLoader = false;
  String gender = '';

  String cc = "91";
  String sDistrcts = '';
  String sMandals = '';
  bool showLoaderOTP =false;
  List<String> sendList(String value) {
    if (value.isNotEmpty && value != 'Select the district') {
      if (value == 'Alluri Sitharama Raju') {
        return asRaju;
      } else if (value == 'Anakapalli') {
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

  List<String> mandals = [
    "Mandal",
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
    'please select the District',
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
    'Gannavaram',
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

  ///What are the concerns that you expect the upcoming TDP government to address on priority.

// 1. Rising essential commodity prices
// 2. Drinking water issues
// 3. Electricity prices
// 4. Women's safety
// 5. Employment opportunities
// 6. Financial empowerment
// 7. Maternity Benefits
// 8. Others

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
    notifyListeners();
  }

  verifyPhone(BuildContext context, String phone) async {
    showLoaderOTP = true;
    //var credential = PhoneAuthProvider.credential(verificationId: , smsCode: smsCodeController.text);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+$cc$phone",
        verificationCompleted: (credential) async {
          PhoneAuthProvider.credential(
              verificationId: credential.verificationId!,
              smsCode: credential.smsCode!);
        },
        verificationFailed: (FirebaseAuthException e) {
          // print(e);
          showLoaderOTP = false;
          AppConstants.showSnackBar(context, "Failed to login$e");
        },
        codeSent: (String verficationID, int? resendToken) async {
          //getStorage.write("verificationID", verficationID);
          enableOTPtext = true;
          showLoaderOTP= false;
          // print("${resendToken} resendToken");
          // print("$verficationID codesent");
          verificatioID = verficationID;
          notifyListeners();
          //showLoader = false;
          // AppConstants.showSnackBar(context, "$verficationID codesent");
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          //print(verificationID);
          verificatioID = verificationID;
          // Get.showSnackbar(GetSnackBar(message: verificationID));
          // Get.offAllNamed(Routes.OTPSCREEN);
        },
        timeout: const Duration(seconds: 120));
    notifyListeners();
  }

  otpVerify(BuildContext context) async {
    showLoader = true;
    // print("e.toString()");
    // print(verificatioID);
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificatioID, smsCode: otpTextController.text))
          .then((value) async {
        if (value.user != null) {
          showLoader = false;
          AppConstants.showSnackBar(
              context, "User numer verified Successfully");
          isVerified = true;
          showSubmit = true;
          FirebaseAuth.instance.signOut();

          // AppConstants.moveNextClearAll(context, const ProfileScreen());
        }
      });
    } catch (e) {
      showLoader = false;
      AppConstants.showSnackBar(context, e.toString());
      verifyPhone(context, phoneTextController.text);
      // print(e.toString());
    }
    notifyListeners();
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
    }
    notifyListeners();
  }

  void registerUser(BuildContext context) {
    showLoader = true;
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
        isVerified: isVerified);

    _db
        .collection('users')
        .doc("$cc${phoneTextController.text}")
        .set(rModel.toJSON())
        .then((value) {
      showLoader = false;
      AppConstants.showSnackBar(context, "Registration Successfully done");
      AppConstants.moveNextClearAll(context, const HomeScreen());
    }).catchError((err) {
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

  setSelectedRadio(int? val) {
    selectedRadio = val!;
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