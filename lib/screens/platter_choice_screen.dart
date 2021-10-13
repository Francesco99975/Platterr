import 'package:flutter/material.dart';
import 'package:platterr/providers/order.dart';
import 'package:platterr/providers/platter.dart';
import 'package:platterr/providers/platter_format.dart';
import 'package:platterr/providers/platter_request.dart';
import 'package:platterr/providers/platters.dart';
import 'package:platterr/screens/form_order_screen.dart';
import 'package:platterr/widgets/platter_choice_item.dart';
import 'package:platterr/widgets/sizes_choice_item.dart';
import 'package:provider/provider.dart';

class PlatterChoiceScreen extends StatefulWidget {
  const PlatterChoiceScreen({Key? key}) : super(key: key);
  static const routeName = "/platter-choice";

  @override
  _PlatterChoiceScreenState createState() => _PlatterChoiceScreenState();
}

class _PlatterChoiceScreenState extends State<PlatterChoiceScreen> {
  bool isInit = true;
  late Map<String, dynamic> args;
  late List<bool> _isOpen;

  List<PlatterRequest> _selectedList = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      _isOpen = Provider.of<Platters>(context, listen: false)
          .items
          .map((_) => false)
          .toList();

      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (args['edit']) {
        _selectedList = (args['order'] as Order).platters;
      }
      isInit = false;
    }
    super.didChangeDependencies();
  }

  void _add(Platter platter, PlatterFormat format) {
    var index = _selectedList.indexWhere(
        (el) => el.platter.id == platter.id && el.format.id == format.id);
    if (index >= 0) {
      _selectedList[index].quantity++;
    } else {
      _selectedList.add(PlatterRequest(platter, format, 1));
    }
  }

  void _remove(Platter platter, PlatterFormat format) {
    var index = _selectedList.indexWhere(
        (el) => el.platter.id == platter.id && el.format.id == format.id);
    if (index >= 0) {
      if (_selectedList[index].quantity == 1) {
        _selectedList.removeAt(index);
      } else {
        _selectedList[index].quantity--;
      }
    }
  }

  Future<void> _save(BuildContext context) async {
    if (_selectedList.isNotEmpty) {
      Navigator.of(context).pushNamed(FormOrderScreen.routeName, arguments: {
        'edit': args['edit'],
        'selected': _selectedList,
        'order': args['order']
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Select Platters",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        actions: [
          TextButton.icon(
              label: Text(
                "Continue",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () async => await _save(context),
              icon: Icon(
                Icons.save,
                color: Theme.of(context).colorScheme.secondary,
              ))
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          child: Consumer<Platters>(
            builder: (context, platters, child) {
              return ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    _isOpen[panelIndex] = !isExpanded;
                  });
                },
                animationDuration: const Duration(seconds: 1),
                // dividerColor: Theme.of(context).colorScheme.secondary,
                elevation: 2,
                children: platters.items
                    .map((itm) => ExpansionPanel(
                        isExpanded: _isOpen[
                            platters.items.indexWhere((el) => el.id == itm.id)],
                        canTapOnHeader: false,
                        backgroundColor: Theme.of(context).primaryColor,
                        headerBuilder: (context, isExpanded) =>
                            ChangeNotifierProvider.value(
                              value: itm,
                              child: const PlatterChoiceItem(),
                            ),
                        body: ChangeNotifierProvider.value(
                          value: itm,
                          child: SizesChoiceItem(_add, _remove, _selectedList),
                        )))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
