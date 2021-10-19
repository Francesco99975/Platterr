import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platterr/providers/order.dart';
import 'package:platterr/providers/orders.dart';
import 'package:platterr/screens/error_screen.dart';
import 'package:platterr/screens/order_detail_screen.dart';
import 'package:platterr/screens/platter_choice_screen.dart';
import 'package:provider/provider.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context);
    return Dismissible(
      key: ValueKey(order.id),
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
          Navigator.of(context).pushNamed(PlatterChoiceScreen.routeName,
              arguments: {'edit': true, 'order': order});
        }
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final result = await Provider.of<Orders>(context, listen: false)
              .deleteOrder(order.id!);

          if (!result) {
            Navigator.of(context).pushReplacementNamed(ErrorScreen.routeName,
                arguments: {'home': true});
          }
        }
      },
      child: Card(
        elevation: 3,
        color: Theme.of(context).primaryColor,
        child: ListTile(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderDetailScreen(order),
          )),
          leading: CircleAvatar(
            child: Icon(order.paid ? Icons.monetization_on : Icons.money_off,
                color: Theme.of(context).colorScheme.secondary, size: 26),
          ),
          title: Text(
            "${order.customerLastName} (${order.delivery ? 'Delivery' : 'Pickup'})",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          subtitle: Text(
            "Due Date: ${DateFormat.yMMMMEEEEd().format(order.dueDate)}",
            style:
                Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
