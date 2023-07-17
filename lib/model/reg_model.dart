class RegistrationModel {
  String? name;
  String? age;
  String? constituency;
  String? district;
  String? mandal;
  String? address;
  String? pincode;
  List<String>? demands;
  String? vNum;
  String? number;

  RegistrationModel(
      {required this.name,
      required this.age,
      required this.constituency,
      required this.district,
      required this.mandal,
      required this.address,
      required this.demands,
      required this.pincode,
      required this.vNum,
      required this.number});
    factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
      name: json['name'],
      age: json['age'],
      constituency: json['constituency'],
      district: json['district'],
      mandal: json['mandal'],
      address: json['address'],
      demands: ['demands'],
      pincode: json['pincode'],
      vNum: json['vNum'],
      number: json['number']);
      Map<String, dynamic> toJSON() => {
        'name': name,
        'age':age,
        "constituency":constituency,
        'district':district,
        'mandal':mandal,
        'address':address,
        'demands':demands,
        'pincode':pincode,
        'volunteer_number':vNum,
        "phone": number,
      };
}
