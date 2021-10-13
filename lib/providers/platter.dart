import 'package:flutter/foundation.dart';
import 'package:platterr/providers/platter_format.dart';
import 'dart:convert';

List<PlatterFormat> parseFormats(String enc) {
  var parsedData = json.decode(enc) as List;
  return parsedData.map((el) {
    return PlatterFormat.fromMap(el);
  }).toList();
}

class Platter with ChangeNotifier {
  int? id;
  String name = '';
  String description = '';
  List<PlatterFormat> formats = [];

  Platter(this.name, this.description, this.formats, {this.id});

  Platter.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    formats = parseFormats(json.encode(map['formats']));
  }

  Map<String, dynamic> toMapAdd() {
    var map = <String, dynamic>{
      'name': name,
      'description': description,
      'formats': formats.map((fmt) => fmt.toMapAdd()).toList()
    };

    return map;
  }

  Map<String, dynamic> toMapUpdate() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'formats': formats
          .map((fmt) => fmt.id != null ? fmt.toMapUpdate() : fmt.toMapAdd())
          .toList()
    };

    return map;
  }

  String get summary => formats
      .fold(
          "",
          (String previousValue, element) =>
              previousValue += element.toString() + " ")
      .trim();
}
