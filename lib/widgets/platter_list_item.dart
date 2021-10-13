import 'package:flutter/material.dart';
import 'package:platterr/providers/platter.dart';
import 'package:platterr/providers/platters.dart';
import 'package:platterr/screens/form_platter_screen.dart';
import 'package:provider/provider.dart';

class PlatterListItem extends StatelessWidget {
  const PlatterListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platter = Provider.of<Platter>(context);
    return Dismissible(
      key: ValueKey(platter.id),
      background: Container(
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.secondary,
          size: 40,
        ),
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      // ignore: missing_return
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                "Are you sure ?",
                style: Theme.of(context).textTheme.headline1,
              ),
              content: Text(
                "Do you want to remove this item?",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("No",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child:
                      Text("Yes", style: Theme.of(context).textTheme.bodyText2),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );
        } else if (direction == DismissDirection.startToEnd) {
          Navigator.of(context).pushNamed(FormPlatterScreen.routeName,
              arguments: {'edit': true, 'platter': platter});
        }
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await Provider.of<Platters>(context, listen: false)
              .deletePlatter(platter.id!);
        }
      },
      child: Card(
        elevation: 3,
        color: Theme.of(context).primaryColor,
        child: ListTile(
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
          ),
        ),
      ),
    );
  }
}
