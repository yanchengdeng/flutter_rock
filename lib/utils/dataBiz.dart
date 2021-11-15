/*
 * @Author: 凡琛
 * @Date: 2021-07-08 14:42:38
 * @LastEditTime: 2021-08-06 16:03:07
 * @LastEditors: Please set LastEditors
 * @Description: 类型处理类
 * @FilePath: /Rocks_Flutter/lib/utils/dataBiz.dart
 */

bool isEmpty(var param) {
  return param == null ? true : false;
}

bool isListEmpty(var param) {
  return param.runtimeType == List ? (param as List).length <= 0 : true;
}

String stringOrEmpty(var param) {
  return param.runtimeType == String
      ? param == null
          ? ''
          : param
      : '';
}

double doubleOrZero(var param) {
  return param.runtimeType == double
      ? param == null
          ? 0.0
          : param
      : 0.0;
}

String doubleOrZeroToString(var param) {
  return param.runtimeType == double
      ? param == null
          ? '0'
          : param.toString()
      : '0';
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
