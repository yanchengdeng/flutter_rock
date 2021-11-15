/*
 * @Author: 凡琛
 * @Date: 2021-07-23 09:08:50
 * @LastEditTime: 2021-08-17 15:44:51
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/company/company_state.dart
 */

import 'package:get/state_manager.dart';

class CompanyState {
  RxList list;
  String input;
  RxInt tag;
  CompanyState() {
    list = [].obs;
    input = '';
    tag = 0.obs;
  }
}
