import 'package:hive/hive.dart';

part 'slip.g.dart';

@HiveType(typeId: 0)
class Slip extends HiveObject{
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int cost;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final DateTime startSlipDate;
  @HiveField(5)
  bool isEnabledNotification;

  Slip({
    required this.name,
    required this.cost,
    required this.type,
    required this.date,
    required this.startSlipDate,
    required this.isEnabledNotification,
  });

  @override
  String toString() {
    String notification = isEnabledNotification == true ? 'включено' : 'отключено';
    return 'Квитанция: "$name" - $cost₽, $type, $date, напоминание $notification';
  }
}
