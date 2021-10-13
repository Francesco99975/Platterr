import 'package:flutter/material.dart';
import 'package:platterr/providers/orders.dart';
import 'package:platterr/providers/platter.dart';
import 'package:platterr/providers/platter_format.dart';
import 'package:platterr/providers/platters.dart';
import 'package:platterr/screens/loading_screen.dart';
import 'package:platterr/widgets/double_field.dart';
import 'package:provider/provider.dart';

class FormPlatterScreen extends StatefulWidget {
  const FormPlatterScreen({Key? key}) : super(key: key);
  static const routeName = "/add_platter";

  @override
  _FormPlatterScreenState createState() => _FormPlatterScreenState();
}

class _FormPlatterScreenState extends State<FormPlatterScreen> {
  bool _isInit = true;
  late Map<String, dynamic> args;
  late Size deviceSize;

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;

  late int _updateId;
  late String _name;
  late String _description;
  final List<PlatterFormat> _formats = [];

  final List<int> _formatsIds = [];
  final List<TextEditingController> _sizeControllers = [];
  final List<TextEditingController> _priceControllers = [];

  final List<Widget> _formatInputs = [];

  void _refreshInputs() {
    for (var i = 0; i < _formatInputs.length; ++i) {
      _formatInputs[i] = DoubleField(
        index: i,
        isOne: _formatInputs.length < 2,
        isUsed: args['edit']
            ? Provider.of<Orders>(context, listen: false)
                .formatUsed()
                .contains(_formatsIds[i])
            : false,
        keyControllers: _sizeControllers,
        valueControllers: _priceControllers,
        deviceSize: deviceSize,
        fn: _setInputs,
      );
    }
  }

  void _setInputs(int index) {
    setState(() {
      _formatInputs.removeAt(index);
      _sizeControllers.removeAt(index);
      _priceControllers.removeAt(index);

      _refreshInputs();
    });
  }

  Widget _getCredentialInput(int index, {String size = '', String price = ''}) {
    _sizeControllers.add(TextEditingController(text: size));
    _priceControllers.add(TextEditingController(text: price));
    return DoubleField(
      index: index,
      isOne: _formatInputs.length + 1 < 2,
      isUsed: args['edit'] && size != '' && price != ''
          ? Provider.of<Orders>(context, listen: false)
              .formatUsed()
              .contains(_formatsIds[index])
          : false,
      keyControllers: _sizeControllers,
      valueControllers: _priceControllers,
      deviceSize: deviceSize,
      fn: _setInputs,
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate() && _formatInputs.isNotEmpty) {
      setState(() {
        _isLoading = !_isLoading;
      });
      _formKey.currentState!.save();

      if (!args['edit']) {
        for (var i = 0; i < _formatInputs.length; ++i) {
          _formats.add(PlatterFormat(int.parse(_sizeControllers[i].text),
              double.parse(_priceControllers[i].text)));
        }

        await Provider.of<Platters>(context, listen: false)
            .addPlatter(Platter(_name, _description, _formats));
      } else {
        for (var i = 0; i < _formatInputs.length; ++i) {
          if (i < _formatsIds.length) {
            _formats.add(PlatterFormat(int.parse(_sizeControllers[i].text),
                double.parse(_priceControllers[i].text),
                id: _formatsIds[i]));
          } else {
            _formats.add(PlatterFormat(int.parse(_sizeControllers[i].text),
                double.parse(_priceControllers[i].text)));
          }
        }

        await Provider.of<Platters>(context, listen: false).updatePlatter(
            Platter(_name, _description, _formats, id: _updateId));
      }

      Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      deviceSize = MediaQuery.of(context).size;
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      if (!args['edit']) {
        _formatInputs.add(_getCredentialInput(0));
      } else {
        Platter plt = args['platter'] as Platter;
        _updateId = plt.id!;
        _name = plt.name;
        _description = plt.description;

        for (var i = 0; i < plt.formats.length; i++) {
          _formatsIds.add(plt.formats[i].id!);
          _formatInputs.add(_getCredentialInput(i,
              size: plt.formats[i].size.toString(),
              price: plt.formats[i].price.toString()));
        }
      }
      _refreshInputs();
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
        "${!args['edit'] ? 'Add' : 'Update'} Platter",
        style: Theme.of(context).textTheme.bodyText1,
      ),
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
                      height: deviceSize.height / 1.3,
                      width: deviceSize.width,
                      color: Theme.of(context).backgroundColor,
                      margin: const EdgeInsets.all(18.0),
                      padding: const EdgeInsets.all(5.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              autocorrect: false,
                              initialValue: args['edit'] ? _name : null,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              decoration: InputDecoration(
                                labelText: "Platter Name",
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 16),
                                hintText: 'Enter platter name',
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
                                  ? "Enter a name for the platter please"
                                  : null,
                              onSaved: (newValue) => _name = newValue!,
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                            TextFormField(
                              autocorrect: false,
                              initialValue: args['edit'] ? _description : null,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              decoration: InputDecoration(
                                labelText: "Platter Description",
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 16),
                                hintText: 'Enter platter description',
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
                                  ? "Enter a description for the platter please"
                                  : null,
                              onSaved: (newValue) => _description = newValue!,
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                            Text("Platter Formats",
                                style: Theme.of(context).textTheme.bodyText2),
                            const SizedBox(
                              height: 25.0,
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _formatInputs.add(_getCredentialInput(
                                        _formatInputs.length));

                                    for (var i = _formatInputs.length - 2;
                                        i >= 0;
                                        --i) {
                                      _formatInputs[i] = DoubleField(
                                        index: i,
                                        isOne: _formatInputs.length + 1 < 2,
                                        isUsed: args['edit']
                                            ? Provider.of<Orders>(context,
                                                    listen: false)
                                                .formatUsed()
                                                .contains(_formatsIds[i])
                                            : false,
                                        keyControllers: _sizeControllers,
                                        valueControllers: _priceControllers,
                                        deviceSize: deviceSize,
                                        fn: _setInputs,
                                      );
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).primaryColor,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).backgroundColor),
                                label: Text(
                                  "Add Format",
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                            SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  itemCount: _formatInputs.length,
                                  itemBuilder: (context, index) =>
                                      _formatInputs[index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).backgroundColor),
                        onPressed: _isLoading ? () {} : _save,
                        child: Text(
                          "${!args['edit'] ? 'Add' : 'Update'} Platter",
                          style: Theme.of(context).textTheme.bodyText2,
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
