class RegistrationModel {
  String? name;
  String? age;
  String? gender;
  String? constituency;
  String? district;
  String? mandal;
  String? address;
  String? pincode;
  String? vNum;
  String? vName;
  String? number;
  bool isVerified;

  RegistrationModel(
      {required this.name,
      required this.age,
      required this.constituency,
      required this.district,
      required this.mandal,
      required this.address,
      required this.gender,
      required this.pincode,
      this.vNum,
      this.vName,
      required this.number,
      required this.isVerified});
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
          isVerified: json['isVerified']);
  Map<String, dynamic> toJSON() => {
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
        "isVerified":isVerified
      };
}
