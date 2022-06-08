import 'package:cashflow/ui/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/core/notification_handler.dart';
import 'package:cashflow/model/slip.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    NotificationHandler.init(isSheduled: true);
    listenNotification();
    super.initState();
  }

  
  void listenNotification() => NotificationHandler.onNotification;

  @override
  Widget build(BuildContext context) {
    Box<Slip> box = Hive.box('slips');
    void addSlip() {
      Get.toNamed('/addslip');
    }

    return ColoredBox(
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OutlinedButton(
              child: Text('Добавить платеж', style: Theme.of(context).textTheme.bodyText1),
              onPressed: addSlip,
              style: Theme.of(context).outlinedButtonTheme.style,
            ),
            const Divider(),
            Expanded(
              child: ValueListenableBuilder(valueListenable: box.listenable(), builder: (context, Box<Slip> slipBox, _) {
                return ListView.separated(
                  itemBuilder: (context, index) =>
                      CustomListTile(slip: slipBox.getAt(index) as Slip, index: index),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemCount: slipBox.length);
              },))
          
          ],
        ),
      ),
    );
  }
}

