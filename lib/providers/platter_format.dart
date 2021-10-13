import 'package:flutter/foundation.dart';

class PlatterFormat with ChangeNotifier {
  int? id;
  int size = 0;
  double price = 0.0;

  PlatterFormat(this.size, this.price, {this.id});

  PlatterFormat.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    size = map['size'];
    price = map['price'].toDouble();
  }

  Map<String, dynamic> toMapAdd() {
    var map = <String, dynamic>{'size': size, 'price': price};

    return map;
  }

  Map<String, dynamic> toMapUpdate() {
    var map = <String, dynamic>{'id': id, 'size': size, 'price': price};

    return map;
  }

  @override
  String toString() {
    return "$size in.";
  }
}
