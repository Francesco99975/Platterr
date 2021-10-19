import 'package:flutter/material.dart';
import 'package:platterr/providers/orders.dart';
import 'package:platterr/providers/platters.dart';
import 'package:platterr/providers/theme_changer.dart';
import 'package:platterr/screens/error_screen.dart';
import 'package:platterr/screens/loading_screen.dart';
import 'package:platterr/screens/platter_choice_screen.dart';
import 'package:platterr/widgets/main_drawer.dart';
import 'package:platterr/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColorDark,
      color: Theme.of(context).colorScheme.secondary,
      onRefresh: () => Navigator.of(context).pushReplacementNamed(routeName),
      child: FutureBuilder<List<bool>>(
        future: Future.wait([
          Provider.of<Platters>(context, listen: false).loadPlatters(),
          Provider.of<Orders>(context, listen: false).loadOrders()
        ]),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const LoadingScreen()
              : snapshot.data!.any((el) => !el)
                  ? const ErrorScreen()
                  : Scaffold(
                      appBar: AppBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).primaryColor,
                        title: Text(
                          "Orders",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        actions: [
                          Consumer<ThemeChanger>(
                            builder: (context, themeChanger, child) =>
                                Switch.adaptive(
                              value: themeChanger.isDark,
                              onChanged: (value) => themeChanger.toggle(),
                            ),
                          ),
                          IconButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, PlatterChoiceScreen.routeName,
                                  arguments: {'edit': false}),
                              icon: const Icon(Icons.add))
                        ],
                      ),
                      drawer: const MainDrawer(),
                      body: SafeArea(
                        child: Container(
                          color: Theme.of(context).backgroundColor,
                          child: Consumer<Orders>(
                            builder: (context, orders, child) {
                              return orders.size <= 0
                                  ? child as Widget
                                  : ListView.builder(
                                      itemBuilder: (context, index) =>
                                          ChangeNotifierProvider.value(
                                        value: orders.items[index],
                                        child: const OrderListItem(),
                                      ),
                                      itemCount: orders.size,
                                    );
                            },
                            child: Center(
                              child: Text(
                                "Press [+] to take a new order",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ),
                      ));
        },
      ),
    );
  }
}
