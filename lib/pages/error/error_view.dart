import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'error_logic.dart';
import 'error_state.dart';

/// @description:
/// @author 
/// @date: 2021/06/23 16:58:35
class ErrorPage extends StatelessWidget {
  final ErrorLogic logic = Get.put(ErrorLogic());
  final ErrorState state = Get.find<ErrorLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
