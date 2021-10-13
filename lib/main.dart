import 'package:flutter/material.dart';
import 'package:platterr/providers/orders.dart';
import 'package:platterr/providers/platters.dart';
import 'package:platterr/providers/theme_changer.dart';
import 'package:platterr/screens/form_order_screen.dart';
import 'package:platterr/screens/form_platter_screen.dart';
import 'package:platterr/screens/orders_screen.dart';
import 'package:platterr/screens/platter_choice_screen.dart';
import 'package:platterr/screens/platters_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Platterr());
}

class Platterr extends StatelessWidget {
  const Platterr({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger(ThemeChanger.dark)),
        ChangeNotifierProvider(create: (_) => Platters()),
        ChangeNotifierProvider(create: (_) => Orders())
      ],
      builder: (context, _) {
        final themeChanger = Provider.of<ThemeChanger>(context);
        return MaterialApp(
            title: 'Platterr',
            theme: themeChanger.theme,
            routes: {
              OrdersScreen.routeName: (_) => const OrdersScreen(),
              FormPlatterScreen.routeName: (_) => const FormPlatterScreen(),
              FormOrderScreen.routeName: (_) => const FormOrderScreen(),
              PlatterChoiceScreen.routeName: (_) => const PlatterChoiceScreen()
            },
            home: const PlattersScreen());
      },
    );
  }
}
