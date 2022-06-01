import 'package:flutter_get_x/model/slip.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  // RxList slips = [].obs;
  var slips = [].obs;

  void deleteFromList(int index) {
    slips.removeAt(index);
  }
}