import 'package:flutter/material.dart';
import 'package:platterr/providers/platter.dart';
import 'package:intl/intl.dart';

class PlatterDetailScreen extends StatelessWidget {
  final Platter platter;
  const PlatterDetailScreen(this.platter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final appBar = AppBar(
      centerTitle: true,
      title: Text(platter.name),
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).colorScheme.secondary,
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
                Text("Description",
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
                    child: Text(platter.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("Formats",
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
                      children: platter.formats
                          .map(
                            (fmt) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    "${fmt.size}\" / ${NumberFormat.simpleCurrency().format(fmt.price)}",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ),
                            ),
                          )
                          .toList(),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
