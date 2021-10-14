import 'package:flutter/foundation.dart';
import 'package:platterr/providers/platter_request.dart';
import 'dart:convert';

List<PlatterRequest> parseRequests(String enc) {
  var parsedData = json.decode(enc) as List;
  return parsedData.map((el) {
    return PlatterRequest.fromMap(el);
  }).toList();
}

class Order with ChangeNotifier {
  int? id;
  List<PlatterRequest> platters = [];
  String customerFirstName = '';
  String customerLastName = '';
  String phoneNumber = '';
  String comment = '';
  bool delivery = false;
  bool paid = false;
  DateTime createdAt = DateTime(1999);
  DateTime dueDate = DateTime(1999);

  Order(
      {this.id,
      required this.platters,
      required this.customerFirstName,
      required this.customerLastName,
      required this.phoneNumber,
      required this.comment,
      required this.delivery,
      required this.paid,
      required this.createdAt,
      required this.dueDate});

  Order.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    platters = parseRequests(json.encode(map['platters']));
    customerFirstName = map['customerFirstName'];
    customerLastName = map['customerLastName'];
    phoneNumber = map['phoneNumber'];
    comment = map['comment'];
    delivery = map['delivery'];
    paid = map['paid'];
    createdAt = DateTime.parse(map['createdAt']);
    dueDate = DateTime.parse(map['dueDate']);
  }

  String get fullname => customerFirstName + " " + customerLastName;

  double get total => platters.fold(0.0, (prev, el) => prev + el.format.price);

  Map<String, dynamic> toMapAdd() {
    var map = <String, dynamic>{
      'platters': platters.map((plt) => plt.toMapAdd()).toList(),
      'customerFirstName': customerFirstName,
      'customerLastName': customerLastName,
      'phoneNumber': phoneNumber,
      'comment': comment,
      'delivery': delivery,
      'paid': paid,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String()
    };

    return map;
  }

  Map<String, dynamic> toMapUpdate() {
    var map = <String, dynamic>{
      'id': id,
      'platters': platters
          .map((plt) => plt.id != null ? plt.toMapUpdate() : plt.toMapAdd())
          .toList(),
      'customerFirstName': customerFirstName,
      'customerLastName': customerLastName,
      'phoneNumber': phoneNumber,
      'comment': comment,
      'delivery': delivery,
      'paid': paid,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String()
    };

    return map;
  }
}
