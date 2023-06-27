class Copon {
 String? coponId;
 int? coponNum;
 String? coponPer;
 int? beneficiaries_number;


 Copon(this.coponId, this.coponNum, this.coponPer,this.beneficiaries_number);

 Copon.fromJson(Map<String, dynamic> json) {
   coponId = json['coponId'];
   coponNum = json['coponNum'];
   coponPer = json['coponPer'];
   beneficiaries_number = json['beneficiaries_number'];
 }

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
   data['coponId'] = this.coponId;
   data['coponNum'] = this.coponNum;
   data['coponPer'] = this.coponPer;
   data['beneficiaries_number'] = this.beneficiaries_number??"0";
   return data;
 }
}