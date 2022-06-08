import 'dart:developer';

import 'package:cashflow/core/appcolors.dart';
import 'package:cashflow/core/dateformatter.dart';
import 'package:cashflow/model/slip.dart';
import 'package:cashflow/ui/pages/slip_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../controller/controller.dart';

// ignore: must_be_immutable
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
    log('Count: ${c.slips.length}');
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
