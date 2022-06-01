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

  Slip({
    required this.name,
    required this.cost,
    required this.type,
    required this.date,
  });

  @override
  String toString() {
    return 'Квитанция: "$name" - $cost₽, $type, $date';
  }
}
