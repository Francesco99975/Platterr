import 'package:flutter/material.dart';
import 'package:platterr/screens/orders_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Widget _buildRoute(
      BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title),
      onTap: () => Navigator.of(context).pushReplacementNamed(route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).primaryColor,
              title: Text(
                "Platterr",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              automaticallyImplyLeading: false,
            ),
            _buildRoute(context, "Platters", Icons.food_bank_rounded, "/"),
            _buildRoute(context, "Orders", Icons.document_scanner_sharp,
                OrdersScreen.routeName),
          ],
        ),
      ),
    );
  }
}
