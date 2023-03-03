import 'package:shop/utils/user_prop.dart';

class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? imgpath;

  UserModel({this.id, this.name, this.email, this.password, this.imgpath});

  Map<String, dynamic> userModelToJson() {
    return {
      fid: id,
      fname: name,
      femail: email,
      fpassword: password,
      fimgpath: imgpath
    };
  }

  UserModel.userModelFromJson(Map<String, dynamic> res)
      : id = res[fid],
        name = res[fname],
        email = res[femail],
        password = res[fpassword],
        imgpath = res[fimgpath];
}
