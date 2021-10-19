import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:platterr/providers/orders.dart';
import 'package:platterr/providers/platters.dart';
import 'package:platterr/providers/theme_changer.dart';
import 'package:platterr/screens/error_screen.dart';
import 'package:platterr/screens/form_order_screen.dart';
import 'package:platterr/screens/form_platter_screen.dart';
import 'package:platterr/screens/orders_screen.dart';
import 'package:platterr/screens/platter_choice_screen.dart';
import 'package:platterr/screens/platters_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print("Handling a background message: ${message.messageId}");
  // print("Handling a background message: ${message.notification!.title}");
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.subscribeToTopic("all");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'platterr_channel', // id
        'Main Platterr Channel',
        description: 'Platterr channel used for most notifications', // title
        importance: Importance.high,
        playSound: true);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(const Platterr());
}

class Platterr extends StatefulWidget {
  const Platterr({Key? key}) : super(key: key);

  @override
  State<Platterr> createState() => _PlatterrState();
}

class _PlatterrState extends State<Platterr> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  icon: '@mipmap/ic_launcher',
                  playSound: true,
                  channelDescription: channel.description),
            ));
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   Navigator.of(context).pushReplacementNamed('/');
    // });

    super.initState();
  }

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
              PlatterChoiceScreen.routeName: (_) => const PlatterChoiceScreen(),
              ErrorScreen.routeName: (_) => const ErrorScreen()
            },
            home: const PlattersScreen());
      },
    );
  }
}
