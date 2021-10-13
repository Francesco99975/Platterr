import 'package:flutter/material.dart';
import 'package:platterr/providers/platter.dart';
import 'package:platterr/providers/platter_request.dart';
import 'package:provider/provider.dart';

class SizesChoiceItem extends StatefulWidget {
  final Function add;
  final Function remove;
  final List<PlatterRequest> sel;
  const SizesChoiceItem(this.add, this.remove, this.sel, {Key? key})
      : super(key: key);

  @override
  _SizesChoiceItemState createState() => _SizesChoiceItemState();
}

class _SizesChoiceItemState extends State<SizesChoiceItem> {
  bool _isInit = true;

  late List<int> quantities = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final formats = Provider.of<Platter>(context, listen: false).formats;
      if (widget.sel.isEmpty) {
        quantities = formats.map((_) => 0).toList();
      } else {
        for (var i = 0; i < formats.length; i++) {
          final index =
              widget.sel.indexWhere((el) => el.format.id == formats[i].id);
          if (index >= 0) {
            quantities.add(widget.sel[index].quantity);
          } else {
            quantities.add(0);
          }
        }
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final platter = Provider.of<Platter>(context, listen: false);
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: platter.formats.map((format) {
        var index = platter.formats.indexWhere((el) => el.id == format.id);
        return InkWell(
          onLongPress: () {
            setState(() {
              if (quantities[index] > 0) {
                quantities[index]--;
              }
            });
            widget.remove(platter, format);
          },
          child: ActionChip(
              backgroundColor: Theme.of(context).backgroundColor,
              avatar: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                child: Text("x${quantities[index]}"),
              ),
              label: Text(
                "${format.size}\"",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onPressed: () {
                setState(() {
                  quantities[index]++;
                });
                widget.add(platter, format);
              }),
        );
      }).toList(),
    );
  }
}
