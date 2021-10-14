import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platterr/providers/order.dart';
import 'package:platterr/providers/orders.dart';
import 'package:platterr/providers/platter_request.dart';
import 'package:platterr/providers/theme_changer.dart';
import 'package:platterr/screens/loading_screen.dart';
import 'package:platterr/screens/orders_screen.dart';
import 'package:provider/provider.dart';

class FormOrderScreen extends StatefulWidget {
  const FormOrderScreen({Key? key}) : super(key: key);
  static const routeName = "/add_order";

  @override
  _FormOrderScreenState createState() => _FormOrderScreenState();
}

class _FormOrderScreenState extends State<FormOrderScreen> {
  bool _isInit = true;
  late Map<String, dynamic> args;
  late Size deviceSize;

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;

  late int _updateId;
  late String _customerFirstName;
  late String _customerLastName;
  late String _phoneNumber;
  String _comment = 'No Comment';
  bool _delivery = false;
  bool _paid = false;
  DateTime _dueDate = DateTime.now();
  List<PlatterRequest> _platters = [];

  Future<void> _save() async {
    if (_formKey.currentState!.validate() && _platters.isNotEmpty) {
      setState(() {
        _isLoading = !_isLoading;
      });
      _formKey.currentState!.save();

      if (!args['edit']) {
        await Provider.of<Orders>(context, listen: false).addOrder(Order(
            platters: _platters,
            customerFirstName: _customerFirstName,
            customerLastName: _customerLastName,
            phoneNumber: _phoneNumber,
            comment: _comment,
            delivery: _delivery,
            paid: _paid,
            createdAt: DateTime.now(),
            dueDate: _dueDate));
      } else {
        await Provider.of<Orders>(context, listen: false).updateOrder(Order(
            id: _updateId,
            platters: _platters,
            customerFirstName: _customerFirstName,
            customerLastName: _customerLastName,
            phoneNumber: _phoneNumber,
            comment: _comment,
            delivery: _delivery,
            paid: _paid,
            createdAt: (args['order'] as Order).createdAt,
            dueDate: _dueDate));
      }

      Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
    }
  }

  _toggleDelivery(bool value) {
    setState(() {
      _delivery = value;
    });
  }

  _togglePaid() {
    setState(() {
      _paid = !_paid;
    });
  }

  Future<void> _presentDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Theme.of(context).colorScheme.secondary,
                onPrimary: Colors.white,
                surface: Theme.of(context).primaryColor,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor:
                  Provider.of<ThemeChanger>(context, listen: false).isDark
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context).primaryColorDark,
            ),
            child: child!,
          );
        },
        firstDate: DateTime(2020),
        lastDate: DateTime(2090));

    if (pickedDate == null) return;

    setState(() {
      _dueDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
          _dueDate.hour, _dueDate.minute, 0);
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Theme.of(context).colorScheme.secondary,
                onPrimary: Colors.white,
                surface: Theme.of(context).primaryColor,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor:
                  Provider.of<ThemeChanger>(context, listen: false).isDark
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context).primaryColorDark,
            ),
            child: child!,
          );
        },
        initialTime: const TimeOfDay(hour: 7, minute: 0));

    if (pickedTime == null) return;

    setState(() {
      _dueDate = DateTime(_dueDate.year, _dueDate.month, _dueDate.day,
          pickedTime.hour, pickedTime.minute, 0);
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      deviceSize = MediaQuery.of(context).size;
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      _platters = args['selected'] as List<PlatterRequest>;

      if (args['edit']) {
        final order = args['order'] as Order;
        _updateId = order.id!;
        _customerFirstName = order.customerFirstName;
        _customerLastName = order.customerLastName;
        _phoneNumber = order.phoneNumber;
        _comment = order.comment;
        _delivery = order.delivery;
        _paid = order.paid;
        _dueDate = order.dueDate;
      }

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      foregroundColor: Theme.of(context).primaryColor,
      title: Text(
        "${!args['edit'] ? 'Add' : 'Update'} Order",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: [
        TextButton.icon(
            icon: Icon(
              _paid ? Icons.monetization_on : Icons.money_off,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: _togglePaid,
            label: Text(
              _paid ? "PAID" : "UNPAID",
              style: Theme.of(context).textTheme.bodyText2,
            ))
      ],
    );
    return _isLoading
        ? const LoadingScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: appBar,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: deviceSize.height / 1.4,
                      width: deviceSize.width,
                      color: Theme.of(context).backgroundColor,
                      margin: const EdgeInsets.all(18.0),
                      padding: const EdgeInsets.all(5.0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextFormField(
                                autocorrect: false,
                                initialValue:
                                    args['edit'] ? _customerFirstName : null,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                decoration: InputDecoration(
                                  labelText: "Customer Firstname",
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 16),
                                  hintText: 'Enter firstname',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                validator: (value) => value!.trim().isEmpty
                                    ? "Enter firstname please"
                                    : null,
                                onSaved: (newValue) =>
                                    _customerFirstName = newValue!,
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              TextFormField(
                                autocorrect: false,
                                initialValue:
                                    args['edit'] ? _customerLastName : null,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                decoration: InputDecoration(
                                  labelText: "Customer Lastname",
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 16),
                                  hintText: 'Enter lastname',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                validator: (value) => value!.trim().isEmpty
                                    ? "Enter lastname please"
                                    : null,
                                onSaved: (newValue) =>
                                    _customerLastName = newValue!,
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              TextFormField(
                                autocorrect: false,
                                initialValue:
                                    args['edit'] ? _phoneNumber : null,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                decoration: InputDecoration(
                                  labelText: "Customer Phone Number",
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 16),
                                  hintText: 'Enter phone number',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                validator: (value) => value!.trim().isEmpty
                                    ? "Enter phone number please"
                                    : null,
                                onSaved: (newValue) => _phoneNumber = newValue!,
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              TextFormField(
                                autocorrect: false,
                                initialValue: _comment,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                decoration: InputDecoration(
                                  labelText: "Order Comment",
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 16),
                                  hintText: 'Comment order',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                validator: (value) => value!.trim().isEmpty
                                    ? "Enter a comment please"
                                    : null,
                                onSaved: (newValue) => _comment = newValue!,
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: !_delivery
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .primaryColorDark,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Pickup",
                                          style: !_delivery
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondaryVariant)),
                                    ),
                                    onTap: () => _toggleDelivery(false),
                                  ),
                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: _delivery
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .primaryColorDark,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Delivery",
                                          style: _delivery
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondaryVariant)),
                                    ),
                                    onTap: () => _toggleDelivery(true),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Text("Due Date",
                                  style: Theme.of(context).textTheme.bodyText1),
                              const SizedBox(
                                height: 25.0,
                              ),
                              TextButton.icon(
                                  onPressed: () async =>
                                      await _presentDatePicker(context),
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: Text(
                                    DateFormat.yMMMMEEEEd().format(_dueDate),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  )),
                              const SizedBox(
                                height: 25.0,
                              ),
                              TextButton.icon(
                                  onPressed: () async =>
                                      await _selectTime(context),
                                  icon: Icon(Icons.access_time,
                                      color: Theme.of(context).primaryColor),
                                  label: Text(DateFormat.Hm().format(_dueDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).backgroundColor),
                        onPressed: _isLoading ? () {} : _save,
                        child: Text(
                          "${!args['edit'] ? 'Add' : 'Update'} Order",
                          style: Theme.of(context).textTheme.bodyText2,
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
