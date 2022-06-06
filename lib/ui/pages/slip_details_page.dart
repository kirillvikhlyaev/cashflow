import 'dart:developer';

import 'package:cashflow/controller/controller.dart';
import 'package:cashflow/core/notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/core/dateformatter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../model/slip.dart';

class SlipDetails extends StatefulWidget {
  final Slip slip;
  const SlipDetails({Key? key, required this.slip}) : super(key: key);

  @override
  State<SlipDetails> createState() => _SlipDetailsState();
}

class _SlipDetailsState extends State<SlipDetails> {
  bool isEnabledNotification = false;
  FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
  Controller c = Get.put(Controller());

  @override
  void initState() {
    isEnabledNotification = widget.slip.isEnabledNotification;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Детальная информация',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              width: Get.width,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.slip.name,
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                       RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: widget.slip.type,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .color,
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                              text: ' тип оплаты',
                              style: Theme.of(context).textTheme.headline3)
                        ]),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Стоимость платежа: ',
                              style: Theme.of(context).textTheme.headline3),
                          TextSpan(
                              text: '${widget.slip.cost}₽',
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .color,
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Запись создана - ',
                              style: Theme.of(context).textTheme.headline3),
                          TextSpan(
                              text: DateFormatter.dateToDDMMYY(
                                  widget.slip.startSlipDate),
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .color,
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Следующая оплата - ',
                              style: Theme.of(context).textTheme.headline3),
                          TextSpan(
                              text:
                                  DateFormatter.dateToDDMMYY(widget.slip.date),
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .color,
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: Get.width,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Приостановить напоминания',
                        style: Theme.of(context).textTheme.headline3),
                    Switch(
                        value: isEnabledNotification,
                        onChanged: (value) async {
                          setState(() {
                            isEnabledNotification = !isEnabledNotification;
                          });
                          widget.slip.isEnabledNotification =
                              isEnabledNotification;
                          await widget.slip.save();

                          value == false ? await flp.cancel(c.slips.indexOf(widget.slip)) : 
                          NotificationHandler.showScheduledNotification(id: c.slips.indexOf(widget.slip), title: widget.slip.name, body: 'Завтра ожидается оплата в размере ${widget.slip.cost}₽', payload: 'Cashflow', scheduledDate: widget.slip.date.add(const Duration(hours: -4)));

                          log(widget.slip.toString() + ' - индекс элемента/уведомления - ${c.slips.indexOf(widget.slip)}');
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
