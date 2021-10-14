import 'package:flutter/material.dart';
import 'package:platterr/providers/platter.dart';
import 'package:platterr/screens/platter_detail_screen.dart';
import 'package:provider/provider.dart';

class PlatterChoiceItem extends StatefulWidget {
  const PlatterChoiceItem({Key? key}) : super(key: key);

  @override
  _PlatterChoiceItemState createState() => _PlatterChoiceItemState();
}

class _PlatterChoiceItemState extends State<PlatterChoiceItem> {
  @override
  Widget build(BuildContext context) {
    final platter = Provider.of<Platter>(context, listen: false);
    return Card(
      elevation: 3,
      color: Theme.of(context).primaryColor,
      child: ListTile(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlatterDetailScreen(platter),
              )),
          leading: Icon(Icons.dashboard_rounded,
              color: Theme.of(context).colorScheme.secondary, size: 26),
          title: Text(
            platter.name,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          subtitle: Text(
            platter.summary,
            style:
                Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
          )),
    );
  }
}
