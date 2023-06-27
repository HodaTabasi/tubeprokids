class Users {
  late String id;
  late String name;
  late String email;
  late String accountTypeEN;
  late String accountTypeAR;
  late String image;
  late String country;
  late bool isVisible;
  late String date;
  late String videosNumber;
  String? password;
  bool? subscraption;
  String? subscraption_duration;
  String? phoneNumber;
  String? couponId;

  //anitgone
  Users();

  Users.fromMap(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    if(json['name'] != null){
      name = json['name'];
    }else {
      name = "no Name";
    }

    email = json['email'];
    accountTypeEN = json['account_type_en'];
    accountTypeAR = json['account_type_ar'];
    phoneNumber = json['phone_number'];
    country = json['country'];
    print(json['image']);
    if(json['image'] != null || json['image'] != "" ){
      print("fdfdfd");
      image = json['image'];
    }else {
      print("fdfdfddgdsg");
      image = "https://e7.pngegg.com/pngimages/906/448/png-clipart-silhouette-person-person-with-helmut-animals-logo.png";
    }

    isVisible = json['is_visible'];
    date = json['date'];
    videosNumber = json['videos_number'];
    subscraption = json['subscraption'];
    subscraption_duration = json['subscraption_duration'];
    couponId = json['coponId'];

  }

  toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'account_type_en': accountTypeEN,
      'account_type_ar': accountTypeAR,
      'image': image,
      'country': country,
      'is_visible': isVisible,
      'date': date,
      'videos_number': videosNumber,
      'subscraption': subscraption,
      'subscraption_duration': subscraption_duration,
      'phone_number': phoneNumber,
      'coponId':couponId

    };
  }
}
