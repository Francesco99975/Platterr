import 'package:flutter/foundation.dart';
import 'package:platterr/providers/platter.dart';
import 'package:platterr/providers/platter_format.dart';

class PlatterRequest with ChangeNotifier {
  int? id;
  Platter platter = Platter('', '', []);
  PlatterFormat format = PlatterFormat(0, 0);
  int quantity = 0;

  PlatterRequest(this.platter, this.format, this.quantity, {this.id});

  PlatterRequest.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    platter = Platter.fromMap(map['platter']);
    format = PlatterFormat.fromMap(map['format']);
    quantity = map['quantity'];
  }

  Map<String, dynamic> toMapAdd() {
    var map = <String, dynamic>{
      'platterId': platter.id,
      'formatId': format.id,
      'quantity': quantity
    };

    return map;
  }

  Map<String, dynamic> toMapUpdate() {
    var map = <String, dynamic>{
      'id': id,
      'platterId': platter.id,
      'formatId': format.id,
      'quantity': quantity
    };

    return map;
  }
}
