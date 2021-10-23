import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platterr/providers/order.dart';
import 'package:platterr/providers/orders.dart';
import 'package:platterr/screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final appBar = AppBar(
      centerTitle: true,
      title: Text(widget.order.customerLastName),
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Icon(widget.order.delivery ? Icons.delivery_dining : Icons.store),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Icon(widget.order.paid ? Icons.monetization_on : Icons.money_off),
        )
      ],
    );
    return _isLoading
        ? const LoadingScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            bottomNavigationBar: InkWell(
              onTap: _isLoading
                  ? () {}
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      final res =
                          await Provider.of<Orders>(context, listen: false)
                              .generatePDF(widget.order.id!);
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: res ? Colors.green : Colors.red,
                          duration: const Duration(seconds: 3),
                          elevation: 5,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            res
                                ? "Successfully generated PDF!"
                                : "Failed to generate PDF...",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          )));
                    },
              child: Container(
                height: 55,
                width: double.infinity,
                color: Colors.red,
                child: Center(
                  child: Text(
                    "CREATE PDF",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(letterSpacing: 1.2, color: Colors.white),
                  ),
                ),
              ),
            ),
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
                          child: Text(widget.order.fullname,
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
                            if (await canLaunch(
                                "tel:${widget.order.phoneNumber}")) {
                              await launch("tel:${widget.order.phoneNumber}");
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "Cannot call this number",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.red),
                                ),
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
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
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
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
                            child: Text(widget.order.phoneNumber,
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
                            widget.order.comment,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text("Extra Fee",
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
                            NumberFormat.simpleCurrency()
                                .format(widget.order.extraFee),
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
                          child: Text(
                              DateFormat.yMMMMEEEEd()
                                  .format(widget.order.createdAt),
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
                          child: Text(
                              DateFormat.yMMMMEEEEd()
                                  .format(widget.order.dueDate),
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
                            children: widget.order.platters
                                .map(
                                  (req) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                          "${req.platter.name} - ${req.format.size}\" / ${NumberFormat.simpleCurrency().format(req.format.price)}",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
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
                              NumberFormat.simpleCurrency()
                                  .format(widget.order.total),
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
