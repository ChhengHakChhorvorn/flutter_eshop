import 'package:shop/utils/order_prop.dart';
import 'package:shop/utils/product_prop.dart';

class OrderModel {
  int? orderid;
  int? productId;
  String? productName;
  String? productDesc;
  String? productPrice;
  String? productImgPath;

  int? userId;
  String? userName;
  int? orderQty;
  String? total;
  String? payment;

  OrderModel(
      {this.orderid,
      this.productId,
      this.userId,
      this.orderQty,
      this.payment,
      this.total});

  Map<String, dynamic> OrderModelToJson() {
    return {
      forderid: orderid,
      fproductIdorder: productId,
      fuserId: userId,
      forderqty: orderQty,
      ftotal: total,
      fpayment: payment
    };
  }

  OrderModel.OrderModelFromJson(Map<String, dynamic> res)
      : orderid = res[forderid],
        productId = res[fproductIdorder],
        productName = res[fproductname],
        productPrice = res[fproductprice],
        productDesc = res[fproductdesc],
        productImgPath = res[fproductimgpath],
        userId = res[fuserId],
        orderQty = res[forderqty],
        total = res[ftotal],
        payment = res[fpayment];
}
