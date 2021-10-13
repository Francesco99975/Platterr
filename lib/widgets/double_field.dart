import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DoubleField extends StatelessWidget {
  final int index;
  final bool isOne;
  final bool isUsed;
  final List<TextEditingController> keyControllers;
  final List<TextEditingController> valueControllers;
  final Size deviceSize;
  final Function fn;

  const DoubleField(
      {Key? key,
      required this.index,
      required this.isOne,
      required this.isUsed,
      required this.keyControllers,
      required this.valueControllers,
      required this.deviceSize,
      required this.fn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ValueKey(index),
      children: <Widget>[
        SizedBox(
          width: deviceSize.width / 2 - 70,
          child: TextFormField(
            controller: keyControllers[index],
            style: TextStyle(color: Theme.of(context).primaryColor),
            decoration: InputDecoration(
              labelText: "Size",
              labelStyle:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
              hintText: 'Enter a size',
              hintStyle:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            autocorrect: false,
            keyboardType: TextInputType.number,
            validator: (value) => value!.trim().isEmpty
                ? "Please Enter a size"
                : int.tryParse(value) == null
                    ? "Only numbers allowed"
                    : null,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        SizedBox(
          width: deviceSize.width / 2 - 70,
          child: TextFormField(
            controller: valueControllers[index],
            style: TextStyle(color: Theme.of(context).primaryColor),
            decoration: InputDecoration(
              labelText: "Price",
              labelStyle:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
              hintText: 'Enter a price',
              hintStyle:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            autocorrect: false,
            keyboardType: TextInputType.number,
            validator: (value) => value!.trim().isEmpty
                ? "Please Enter a price"
                : double.tryParse(value) == null
                    ? "Only numbers allowed"
                    : null,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.remove,
            color: isOne || isUsed ? Colors.grey : Colors.red,
          ),
          onPressed: isOne || isUsed ? null : () => fn(index),
        )
      ],
    );
  }
}
