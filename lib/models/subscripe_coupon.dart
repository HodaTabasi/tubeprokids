class SubscribeCoupon {
 String? couponName;
 String? productName;
 String? userId;


 SubscribeCoupon(this.couponName, this.productName, this.userId);

 SubscribeCoupon.fromJson(Map<String, dynamic> json) {
   couponName = json['coupon_name'];
   productName = json['product_name'];
   userId = json['user_id'];
 }

 Map<String, dynamic> toJson() {
   final Map<String, dynamic> data =  Map<String, dynamic>();
   data['coupon_name'] = couponName;
   data['product_name'] = productName;
   data['user_id'] = userId;
   return data;
 }
}