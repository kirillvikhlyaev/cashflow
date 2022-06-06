import 'package:flutter/material.dart';
import 'package:cashflow/ui/widgets/main_widget.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: Theme.of(context).appBarTheme.titleTextStyle),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [IconButton(onPressed: () {
          Get.toNamed('/settings');
        }, icon: const Icon(Icons.settings_outlined,))],
      ),
      body: MainWidget(),
    );
  }
}
