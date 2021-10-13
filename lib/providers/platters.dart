import 'package:flutter/foundation.dart';
import 'package:platterr/providers/platter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Platters with ChangeNotifier {
  List<Platter> _items = [];

  List<Platter> get items => _items;

  int get size => _items.length;

  Future<void> loadPlatters() async {
    var res = json.decode(
        (await http.get(Uri.parse('http://10.0.2.2:5000/platters'))).body);

    List<Platter> temp = [];

    for (var el in res) {
      temp.add(Platter.fromMap(el));
    }

    _items = temp;
  }

  Future<void> addPlatter(Platter platter) async {
    var res = json.decode((await http.post(
            Uri.parse('http://10.0.2.2:5000/platters'),
            headers: {
              'Content-type': 'application/json',
              "Accept": "application/json"
            },
            body: json.encode(platter.toMapAdd())))
        .body);

    _items.add(Platter.fromMap(res));
    notifyListeners();
  }

  Future<void> updatePlatter(Platter platter) async {
    var res = json.decode((await http.put(
            Uri.parse('http://10.0.2.2:5000/platters'),
            headers: {
              'Content-type': 'application/json',
              "Accept": "application/json"
            },
            body: json.encode(platter.toMapUpdate())))
        .body);

    final index = _items.indexWhere((itm) => itm.id == platter.id);
    _items[index] = Platter.fromMap(res['result']);
    notifyListeners();
  }

  Future<void> deletePlatter(int id) async {
    await http.delete(Uri.parse('http://10.0.2.2:5000/platters/$id'));

    _items.removeWhere((itm) => itm.id == id);
  }
}
