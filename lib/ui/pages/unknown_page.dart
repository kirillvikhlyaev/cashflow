import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Стоп...что?'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ColoredBox(
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, color: Theme.of(context).iconTheme.color, size: 80),
              Text('Хьюстон, мы потерялись!',
                  style: Theme.of(context).textTheme.headline1),
            ],
          ),
        ),
      ),
    );
  }
}
