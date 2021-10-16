import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platterr/providers/order.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final appBar = AppBar(
      centerTitle: true,
      title: Text(order.customerLastName),
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(order.delivery ? Icons.delivery_dining : Icons.store),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(order.paid ? Icons.monetization_on : Icons.money_off),
        )
      ],
    );
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Customer",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 22)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: deviceSize.width / 1.5,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(order.fullname,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("Phone Number",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 22)),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    try {
                      if (await canLaunch("tel:${order.phoneNumber}")) {
                        await launch("tel:${order.phoneNumber}");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Cannot call this number",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.red),
                          ),
                          backgroundColor: Theme.of(context).backgroundColor,
                        ));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Something went wrong",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.red),
                        ),
                        backgroundColor: Theme.of(context).backgroundColor,
                      ));
                    }
                  },
                  child: Container(
                    width: deviceSize.width / 1.5,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(order.phoneNumber,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("Comment",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 22)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: deviceSize.width / 1.5,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      order.comment,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("Order Date",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 22)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: deviceSize.width / 1.5,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(DateFormat.yMMMMEEEEd().format(order.createdAt),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("Due Date",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 22)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: deviceSize.width / 1.5,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(DateFormat.yMMMMEEEEd().format(order.dueDate),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("Platters",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 22)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    width: deviceSize.width / 1.5,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: order.platters
                          .map(
                            (req) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    "${req.platter.name} - ${req.format.size}\" / ${NumberFormat.simpleCurrency().format(req.format.price)}",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ),
                            ),
                          )
                          .toList(),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Text("Total",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 22)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: deviceSize.width / 1.5,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                        NumberFormat.simpleCurrency().format(order.total),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
