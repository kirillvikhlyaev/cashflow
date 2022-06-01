import 'package:flutter/material.dart';
import 'package:flutter_get_x/controller/controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    Future.delayed(const Duration(seconds: 1), () async {
      

    }).then((_) => Get.offAndToNamed('/main'));



    return Scaffold(
      body: ColoredBox(
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: Icon(FontAwesomeIcons.moneyCheckDollar, size: 80, color: Theme.of(context).iconTheme.color),
        ),
      ),
    );
  }
}