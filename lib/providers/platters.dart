import 'package:flutter/foundation.dart';
import 'package:platterr/providers/platter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const testUrl = "http://10.0.2.2:5000";
const baseUrl = "https://platterr.dmz.urx.ink";

class Platters with ChangeNotifier {
  List<Platter> _items = [];

  List<Platter> get items => _items;

  int get size => _items.length;

  Future<bool> loadPlatters() async {
    try {
      var res =
          json.decode((await http.get(Uri.parse('$testUrl/platters'))).body);

      List<Platter> temp = [];

      for (var el in res) {
        temp.add(Platter.fromMap(el));
      }

      _items = temp;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPlatter(Platter platter) async {
    try {
      var res = json.decode((await http.post(Uri.parse('$testUrl/platters'),
              headers: {
                'Content-type': 'application/json',
                "Accept": "application/json"
              },
              body: json.encode(platter.toMapAdd())))
          .body);

      _items.add(Platter.fromMap(res));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePlatter(Platter platter) async {
    try {
      var res = json.decode((await http.put(Uri.parse('$testUrl/platters'),
              headers: {
                'Content-type': 'application/json',
                "Accept": "application/json"
              },
              body: json.encode(platter.toMapUpdate())))
          .body);

      final index = _items.indexWhere((itm) => itm.id == platter.id);
      _items[index] = Platter.fromMap(res['result']);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePlatter(int id) async {
    try {
      await http.delete(Uri.parse('$testUrl/platters/$id'));

      _items.removeWhere((itm) => itm.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
