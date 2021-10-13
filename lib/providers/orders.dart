import 'package:flutter/foundation.dart';
import 'package:platterr/providers/order.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:platterr/providers/platter_request.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => _items;

  int get size => _items.length;

  List<int?> formatUsed() {
    final requests = _items
        .fold(<PlatterRequest>[], (prev, el) => [...el.platters]).toList();
    return requests.map((e) => e.format.id).toList();
  }

  Future<void> loadOrders() async {
    var res = json.decode(
        (await http.get(Uri.parse('http://10.0.2.2:5000/orders'))).body);

    List<Order> temp = [];

    for (var el in res) {
      temp.add(Order.fromMap(el));
    }

    _items = temp;
  }

  Future<void> addOrder(Order order) async {
    var res = json.decode((await http.post(
            Uri.parse('http://10.0.2.2:5000/orders'),
            headers: {
              'Content-type': 'application/json',
              "Accept": "application/json"
            },
            body: json.encode(order.toMapAdd())))
        .body);

    _items.add(Order.fromMap(res['result']));
    notifyListeners();
  }

  Future<void> updateOrder(Order order) async {
    var res = json.decode((await http.put(
            Uri.parse('http://10.0.2.2:5000/orders'),
            headers: {
              'Content-type': 'application/json',
              "Accept": "application/json"
            },
            body: json.encode(order.toMapUpdate())))
        .body);

    final index = _items.indexWhere((itm) => itm.id == order.id);
    _items[index] = Order.fromMap(res);
    notifyListeners();
  }

  Future<void> deleteOrder(int id) async {
    await http.delete(Uri.parse('http://10.0.2.2:5000/orders/$id'));

    _items.removeWhere((itm) => itm.id == id);
  }
}
