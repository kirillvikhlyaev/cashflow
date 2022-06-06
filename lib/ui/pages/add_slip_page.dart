import 'package:cashflow/ui/widgets/slip_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSlipPage extends StatelessWidget {
  const AddSlipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text('Добавить платеж',
                style: Theme.of(context).appBarTheme.titleTextStyle),
            Text('Заполните форму',
                style: Theme.of(context).textTheme.headline2)
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        width: Get.width,
        height: Get.height,
        child: const SingleChildScrollView(
            padding:  EdgeInsets.all(16.0),
            child: SlipWidget(
              restorationId: 'add_new_slip',
            )),
      ),
    );
  }
}
