class RegistrationModel {
  String? name;
  String? age;
  String? id;
  String? fatherNamefield;
  String? gender;
  String? constituency;
  String? district;
  String? mandal;
  String? address;
  String? pincode;
  List<String> scheme;
  String? vNum;
  String? vName;
  String? number;
  String? date;
  bool isVerified;
  int totalFam;
  int totalFarmers;
  int totalWomen;
  int totalStudents;
  int totalUnEmployedYouth;
//  PersonDetailsList? famdetails;
  List<Map<String,dynamic>>? farmersList;
  List<Map<String,dynamic>>? studentList;
  List<Map<String,dynamic>>? womenList;
  List<Map<String,dynamic>>? uEMPList;

  RegistrationModel(
      {required this.name,
      required this.age,
      required this.id,
      required this.fatherNamefield,
      required this.constituency,
      required this.district,
      required this.mandal,
      required this.address,
      required this.gender,
      required this.pincode,
      this.vNum,
      this.vName,
      required this.number,
      required this.date,
      required this.isVerified,
      required this.scheme,
      required this.totalFam,
      required this.totalFarmers,
      required this.totalWomen,
      required this.totalStudents,
      required this.totalUnEmployedYouth,
      this.farmersList,
      this.studentList,
      this.uEMPList,
      this.womenList});
  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    List<Map<String,dynamic>>? farmerList = [];
    List<Map<String,dynamic>>? womenList = [];
    List<Map<String,dynamic>>? studentList = [];
    List<Map<String,dynamic>>? uList = [];
    if (json['farmers_List'] != null) {
      json['farmers_List'].forEach((v) {
        farmerList.add(PersonDetails.fromJson(v) as Map<String, dynamic>);
      });
    }
    if (json['women_list'] != null) {
      json['women_list'].forEach((v) {
        womenList.add(PersonDetails.fromJson(v) as Map<String, dynamic>);
      });
    }
    if (json['student_list'] != null) {
      json['student_list'].forEach((v) {
        studentList.add(PersonDetails.fromJson(v) as Map<String, dynamic>);
      });
    }
    if (json['unEmployeed_list'] != null) {
      json['unEmployeed_list'].forEach((v) {
        uList.add(PersonDetails.fromJson(v) as Map<String, dynamic>);
      });
    }
    RegistrationModel rModel = RegistrationModel(
      name: json['name'],
      gender: json['gender'],
      age: json['age'],
      constituency: json['constituency'],
      district: json['district'],
      mandal: json['mandal'],
      address: json['address'],
      vName: json['volunteer_name'],
      pincode: json['pincode'],
      vNum: json['volunteer_number'],
      number: json['number'],
      date: json['date'],
      isVerified: json['isVerified'],
      id: json['id'],
      scheme: json['scheme'],
      totalFam: json['total_fam'],
      totalFarmers: json['total_farmers'],
      totalStudents: json['total_students'],
      totalUnEmployedYouth: json['total_unempyouth'],
      totalWomen: json['total_women'],
      fatherNamefield: json['fatherName'],
      farmersList: farmerList,
      womenList: womenList,
      studentList: studentList,
      uEMPList: uList,
    );
    return rModel;
  }
  Map<String, dynamic> toJSON() => {
        'id': id,
        'name': name,
        'gender': gender,
        'age': age,
        'district': district,
        "constituency": constituency,
        'mandal': mandal,
        'address': address,
        'pincode': pincode,
        'volunteer_number': vNum,
        'volunteer_name': vName,
        "phone": number,
        "isVerified": isVerified,
        "date": date,
        'scheme': scheme,
        'total_fam': totalFam,
        'total_farmers': totalFarmers,
        'total_students': totalStudents,
        'total_unempyouth': totalUnEmployedYouth,
        'total_women': totalWomen,
        'fatherName': fatherNamefield,
        'farmers_List': farmersList,
        'women_list': womenList,
        'student_list': studentList,
        'unEmployeed_List': uEMPList
      };
}

class PersonDetails {
  String? name;
  int? age;

  PersonDetails({required this.name, required this.age});

  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    return PersonDetails(name: json['name'], age: json['age']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'age': age};
}