import 'dart:developer';

import 'package:cashflow/core/notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/controller/controller.dart';
import 'package:cashflow/core/appcolors.dart';
import 'package:cashflow/model/slip.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

enum TypeOfSlip { once, mountly }

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class SlipWidget extends StatefulWidget {
  const SlipWidget({Key? key, required this.restorationId}) : super(key: key);
  final String? restorationId;
  @override
  State<SlipWidget> createState() => _SlipWidgetState();
}

class _SlipWidgetState extends State<SlipWidget> with RestorationMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TypeOfSlip? _typeOfSlip = TypeOfSlip.once;
  DateTime slipDate = DateTime.now();
  final Controller c = Get.put(Controller());

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    DateTime _firstDate = DateTime(DateTime.now().year);
    DateTime _lastDate = DateTime(DateTime.now().year + 1);

    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: _firstDate,
          lastDate: _lastDate,
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        slipDate = newSelectedDate;
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Выбрано: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      Slip slip = Slip(
          name: nameController.text,
          cost: int.parse(costController.text),
          type: _typeOfSlip == TypeOfSlip.once ? 'Единоразовый' : 'Ежемесячный',
          date: slipDate,
          startSlipDate: DateTime.now(),
          isEnabledNotification: true);

      c.slips.add(slip);
      if (_typeOfSlip == TypeOfSlip.once) {
        NotificationHandler.showOnceScheduledNotification(
            id: c.slips.indexOf(slip),
            title: slip.name,
            body: 'Завтра ожидается оплата в размере ${slip.cost}₽',
            payload: 'Cashflow',
            requiredDate: slipDate);
      } else {
        NotificationHandler.scheduleMonthlyTenAMNotification(
          id: c.slips.indexOf(slip),
          title: slip.name,
          body: 'Завтра ожидается оплата в размере ${slip.cost}₽',
          payload: 'Cashflow',
          requiredDate: slipDate,
        );
      }
      log('Добавление под индексом ${c.slips.indexOf(slip)}');

      var box = Hive.box<Slip>('slips');
      box.add(slip);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите название платежа';
              }
              return null;
            },
            decoration: InputDecoration(
              border: Theme.of(context).inputDecorationTheme.border,
              enabledBorder:
                  Theme.of(context).inputDecorationTheme.enabledBorder,
              focusedBorder:
                  Theme.of(context).inputDecorationTheme.focusedBorder,
              labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
              labelText: 'Название платежа',
              filled: Theme.of(context).inputDecorationTheme.filled,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            ),
            controller: nameController,
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Radio(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: TypeOfSlip.once,
                groupValue: _typeOfSlip,
                onChanged: (TypeOfSlip? value) {
                  setState(() {
                    _typeOfSlip = value;
                  });
                }),
            title:
                Text('Один раз', style: Theme.of(context).textTheme.bodyText1),
          ),
          ListTile(
            leading: Radio(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: TypeOfSlip.mountly,
                groupValue: _typeOfSlip,
                onChanged: (TypeOfSlip? value) {
                  setState(() {
                    _typeOfSlip = value;
                  });
                }),
            title: Text('Ежемесячно',
                style: Theme.of(context).textTheme.bodyText1),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
              onPressed: () {
                _restorableDatePickerRouteFuture.present();
              },
              child: Text('Выбрать дату',
                  style: Theme.of(context).textTheme.bodyText1),
              style: Theme.of(context).outlinedButtonTheme.style),
          const SizedBox(height: 10),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите стоимость платежа';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: Theme.of(context).inputDecorationTheme.border,
              enabledBorder:
                  Theme.of(context).inputDecorationTheme.enabledBorder,
              focusedBorder:
                  Theme.of(context).inputDecorationTheme.focusedBorder,
              labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
              labelText: 'Сколько нужно заплатить?',
              filled: Theme.of(context).inputDecorationTheme.filled,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            ),
            controller: costController,
            maxLines: 1,
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: submitForm,
            child: Text('Готово', style: Theme.of(context).textTheme.bodyText2),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
                minimumSize: MaterialStateProperty.all(Size(Get.width, 45)),
                overlayColor:
                    MaterialStateProperty.all(AppColors.overlayColor)),
          ),
        ],
      ),
    );
  }
}
