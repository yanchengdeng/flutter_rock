/*
 * @Author: 凡琛
 * @Date: 2021-07-23 09:08:50
 * @LastEditTime: 2021-07-23 17:48:41
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/company/company_state.dart
 */

import 'package:get/state_manager.dart';

class PersonState {
  RxList list;
  PersonState() {
    list = [1, 2, 3, 4, 5, 6].obs;
  }
}
