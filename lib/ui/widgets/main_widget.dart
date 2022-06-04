import 'package:flutter/material.dart';
import 'package:flutter_get_x/controller/controller.dart';
import 'package:flutter_get_x/core/appcolors.dart';
import 'package:flutter_get_x/core/dateformatter.dart';
import 'package:flutter_get_x/model/slip.dart';
import 'package:flutter_get_x/ui/pages/slip_details_page.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

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

class CustomListTile extends StatelessWidget {
  final Slip slip;
  final int index;
  CustomListTile({Key? key, required this.slip, required this.index})
      : super(key: key);

  final Controller c = Get.put(Controller());
  Box<Slip> box = Hive.box('slips');

  void onDeleteTap() {
    Get.defaultDialog(
      title: 'Удаление из списка',
      middleText: 'Вы уверенны, что хотите удалить элемент?',
      textCancel: 'Отменить',
      textConfirm: 'Удалить',
      onConfirm: () {
        box.deleteAt(index);
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(SlipDetails(slip: slip)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Theme.of(context).listTileTheme.tileColor,
            border: Border.all(width: 0.5, color: AppColors.overlayColor)),
        child: ListTile(
          minLeadingWidth: 0,
          leading: SizedBox(
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${slip.cost}₽', style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ),
          title: Text(slip.name, style: Theme.of(context).textTheme.bodyText1),
          subtitle: Text('${DateFormatter.dateToDDMMYY(slip.date)} - ${slip.type}', style: Theme.of(context).textTheme.headline2),
          trailing: SizedBox(
            height: double.infinity,
            child: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDeleteTap,
            ),
          ),
        ),
      ),
    );
  }
}
