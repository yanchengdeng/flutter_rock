/*
 * @Author: 凡琛
 * @Date: 2021-07-26 11:06:05
 * @LastEditTime: 2021-08-06 14:23:32
 * @LastEditors: Please set LastEditors
 * @Description: 公司主页
 * @FilePath: /Rocks_Flutter/lib/pages/company/company_home/company_home_state.dart
 */
import 'package:get/state_manager.dart';

class CompanyHomeState {
  RxList<dynamic> list;
  Map company;
  int companyID;
  String companyName;
  CompanyHomeState() {
    list = [].obs;
  }
}
