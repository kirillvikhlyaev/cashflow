import 'package:flutter/material.dart';
import 'package:flutter_get_x/ui/widgets/slip_widget.dart';

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
      body: ColoredBox(
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SlipWidget(
              restorationId: 'add_new_slip',
            )),
      ),
    );
  }
}
