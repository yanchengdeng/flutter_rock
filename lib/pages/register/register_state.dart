import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../register/register_widget.dart';

/// @description:
/// @author
/// @date: 2021/07/21 08:38:06
class RegisterState {
  RxString positionName;
  List pagList;
  RxList<dynamic> pagWidgets;
  Map registerInfo;
  List data;
  List title= [];
  Widget widget1;
  Widget widget2;
  bool agreement=false;
  var index = 0;
  SwiperController swiperController;
  TextEditingController phoneController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  List signUpInfo;
  RegisterState() {
    ///Initialize variables
    pagWidgets = [].obs;
    positionName = ''.obs;
  }
}
