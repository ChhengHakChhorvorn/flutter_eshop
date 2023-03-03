import 'package:shop/utils/product_prop.dart';

class ProductModel {
  int? id;
  String? name;
  String? description;
  String? price;
  String? qty;
  String? category;
  String? imgpath;

  ProductModel(
      {this.id,
      this.name,
      this.description,
      this.imgpath,
      this.category,
      this.price,
      this.qty});

  Map<String, dynamic> ProductModelToJson() {
    return {
      fproductid: id,
      fproductname: name,
      fproductdesc: description,
      fproductprice: price,
      fproductqty: qty,
      fproductcategory: category,
      fproductimgpath: imgpath
    };
  }

  ProductModel.ProductModelFromJson(Map<String, dynamic> res)
      : id = res[fproductid],
        name = res[fproductname],
        description = res[fproductdesc],
        price = res[fproductprice],
        qty = res[fproductqty],
        category = res[fproductcategory],
        imgpath = res[fproductimgpath];
}
