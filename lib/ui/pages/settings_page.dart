import 'package:flutter/material.dart';
import 'package:flutter_get_x/core/appcolors.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Настройки',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SettingsWidget(),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: OutlinedButton(
          child: Text('Сменить тему', style: Theme.of(context).textTheme.bodyText1),
          onPressed: () => Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark()),
          style: Theme.of(context).outlinedButtonTheme.style
          ),
        ),
      ),
    );
  }
}
