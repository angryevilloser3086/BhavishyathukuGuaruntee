class VRegistration {
  String? name;
  String? phone;
  String? constituency;
  String? district;
  String? mandal;
  String? panchayat;
  VRegistration(
      {required this.name,
      required this.phone,
      required this.constituency,
      required this.district,
      required this.mandal,
      required this.panchayat});
  factory VRegistration.fromJson(Map<String, dynamic> json) => VRegistration(
      name: json['name'],
      phone: json['phone'],
      constituency: json['constituency'],
      district: json['district'],
      mandal: json['mandal'],
      panchayat: json['panchayat']);

  Map<String, dynamic> toJSON() => {
        'name': name,
        "phone": phone,
        "constituency": constituency,
        'district': district,
        'mandal': mandal,
        "panchayat": panchayat
      };
}
