class Country {
  String? code;
  String? name;
  String? dialCode;

  Country({this.code, this.name, this.dialCode});

  Country.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    dialCode = json['dialCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['dialCode'] = this.dialCode;
    return data;
  }
}
