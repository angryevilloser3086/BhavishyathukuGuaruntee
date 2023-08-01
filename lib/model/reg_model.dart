class RegistrationModel {
  String? name;
  String? age;
  String? id;
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

  RegistrationModel(
      {required this.name,
      required this.age,
      required this.id,
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
      required this.scheme});
  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      RegistrationModel(
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
          isVerified: json['isVerified'], id: json['id'],
          scheme: json['scheme']);
  Map<String, dynamic> toJSON() => {
        'id':id,
        'name': name,
        'gender': gender,
        'age': age,
        'district': district,
        "constituency": constituency,
        'mandal': mandal,
        'address': address,
        'pincode': pincode,
        'volunteer_number': vNum,
        'volunteer_name':vName,
        "phone": number,
        "isVerified":isVerified,
        "date":date,
        'scheme':scheme
      };
}
