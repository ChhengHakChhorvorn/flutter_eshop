import 'package:shop/utils/categories_prop.dart';

class CategoryModel {
  int? id;
  String? name;
  String? description;
  String? imgpath;

  CategoryModel({this.id, this.name, this.description, this.imgpath});

  Map<String, dynamic> CategoryModelToJson() {
    return {
      fcategoryid: id,
      fcategoryName: name,
      fdesc: description,
      fcategoryimgpath: imgpath
    };
  }

  CategoryModel.CategoryModelFromJson(Map<String, dynamic> res)
      : id = res[fcategoryid],
        name = res[fcategoryName],
        description = res[fdesc],
        imgpath = res[fcategoryimgpath];
}
