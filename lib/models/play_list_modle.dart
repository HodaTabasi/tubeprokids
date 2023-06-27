class PlayListModel {
 String? id;
 String? name;
 String? userid;
 List<String>? vedios;

 PlayListModel({this.id, this.name, this.userid, this.vedios});

 PlayListModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  userid = json['userid'];
  if(json['vedios'] != null)
   vedios = json['vedios'].cast<String>();
 }

 Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['name'] = this.name;
  data['userid'] = this.userid;
  if(this.vedios != null)
   data['vedios'] = this.vedios;

  return data;
 }
}