import 'package:flutter/material.dart';
import 'package:platterr/providers/orders.dart';
import 'package:platterr/providers/platters.dart';
import 'package:platterr/providers/theme_changer.dart';
import 'package:platterr/screens/error_screen.dart';
import 'package:platterr/screens/form_platter_screen.dart';
import 'package:platterr/screens/loading_screen.dart';
import 'package:platterr/widgets/main_drawer.dart';
import 'package:platterr/widgets/platter_list_item.dart';
import 'package:provider/provider.dart';

class PlattersScreen extends StatelessWidget {
  const PlattersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColorDark,
      color: Theme.of(context).colorScheme.secondary,
      onRefresh: () => Navigator.of(context).pushReplacementNamed("/"),
      child: FutureBuilder<List<bool>>(
        future: Future.wait([
          Provider.of<Platters>(context, listen: false).loadPlatters(),
          Provider.of<Orders>(context, listen: false).loadOrders()
        ]),
        builder: (_, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const LoadingScreen()
            : snapshot.data!.any((el) => !el)
                ? const ErrorScreen()
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).primaryColor,
                      title: Text(
                        "Deli Platters",
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
                                context, FormPlatterScreen.routeName,
                                arguments: {'edit': false}),
                            icon: const Icon(Icons.add))
                      ],
                    ),
                    drawer: const MainDrawer(),
                    body: SafeArea(
                      child: Container(
                        color: Theme.of(context).backgroundColor,
                        child: Consumer<Platters>(
                          builder: (context, platters, child) {
                            return platters.size <= 0
                                ? child as Widget
                                : ListView.builder(
                                    itemBuilder: (context, index) =>
                                        ChangeNotifierProvider.value(
                                      value: platters.items[index],
                                      child: const PlatterListItem(),
                                    ),
                                    itemCount: platters.size,
                                  );
                          },
                          child: Center(
                            child: Text(
                              "Press [+] to add a new platter",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ),
                    )),
      ),
    );
  }
}
