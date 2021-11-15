import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'info_modify_logic.dart';
import 'info_modify_state.dart';
import '../common/form/loginTextField.dart';

/// @description:
/// @author
/// @date: 2021/08/03 15:43:12
class InfoModifyPage extends StatelessWidget {
  final InfoModifyLogic logic = Get.put(InfoModifyLogic());
  final InfoModifyState state = Get.find<InfoModifyLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑信息'),
        actions: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: InkWell(
                  child: Text("修改",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  onTap: () {
                    logic.makeSure(state.itemType);

                    // Navigator.pop(context);
                  }),
            ),
          ),
        ],
      ),
      //点击空白收起键盘
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: page(
            context,
            state.itemType,
          )),
    );
  }

  //公共页面
  Widget page(
    BuildContext context,
    dynamic item,
  ) {
    switch (item) {
      case items.Password:
        return Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                JhLoginTextField(
                    leftWidget: Icon(Icons.lock),
                    hintText: "请输入旧密码",
                    labelText: '旧密码',
                    isShowDeleteBtn: true,
                    isPwd: true,
                    pwdClose: 'assets/images/icon/ic_pwd_close.png',
                    pwdOpen: 'assets/images/icon/ic_pwd_open.png',
                    inputCallBack: (value) => {state.oldpass.value = value}),
                JhLoginTextField(
                    leftWidget: Icon(Icons.lock),
                    hintText: "请输入新密码",
                    labelText: '新密码',
                    isShowDeleteBtn: true,
                    isPwd: true,
                    pwdClose: 'assets/images/icon/ic_pwd_close.png',
                    pwdOpen: 'assets/images/icon/ic_pwd_open.png',
                    inputCallBack: (value) => {state.newpass.value = value}),
                JhLoginTextField(
                    leftWidget: Icon(Icons.lock),
                    hintText: "请输入确认密码",
                    labelText: '确认密码',
                    isShowDeleteBtn: true,
                    isPwd: true,
                    pwdClose: 'assets/images/icon/ic_pwd_close.png',
                    pwdOpen: 'assets/images/icon/ic_pwd_open.png',
                    inputCallBack: (value) => {state.repass.value = value}),
              ],
            ));
        break;
      case items.RealName:
        return Padding(
            padding: EdgeInsets.all(15),
            child: Obx(
              () => Column(
                children: [
                  JhLoginTextField(
                      leftWidget: Icon(Icons.person),
                      hintText: "请输入姓名",
                      labelText:
                          state.list.length == 0 ? '' : '${state.list['name']}',
                      isShowDeleteBtn: true,
                      isName: true,
                      inputCallBack: (value) => {state.name.value = value})
                ],
              ),
            ));

      case items.Email:
        return Padding(
            padding: EdgeInsets.all(15),
            child: Obx(
              () => Column(
                children: [
                  JhLoginTextField(
                      leftWidget: Icon(Icons.email),
                      maxLength: 30,
                      hintText: "请输入邮箱",
                      labelText: state.list.length == 0
                          ? ''
                          : '${state.list['detail']}',
                      isShowDeleteBtn: true,
                      inputCallBack: (value) => {state.emial.value = value})
                ],
              ),
            ));

      case items.PhoneNumber:
        return Padding(
          padding: EdgeInsets.all(15),
          child: Obx(() => Column(
                children: [
                  JhLoginTextField(
                      maxLength: 11,
                      leftWidget: Icon(Icons.phone_iphone),
                      hintText: "请输入新的手机号",
                      labelText: state.list.length == 0
                          ? ''
                          : '${state.list['detail']}',
                      isShowDeleteBtn: true,
                      inputCallBack: (value) => {state.phone.value = value}),
                  //验证码及滑块
                  // JhLoginTextField(
                  //     leftWidget: Icon(Icons.message),
                  //     hintText: "请输入验证码",
                  //     labelText: '验证码',
                  //     show: state.tem.value, //是否点击获取验证码，未点击不可以输入
                  //     maxLength: 6,
                  //     keyboardType: TextInputType.number,
                  //     //倒计时
                  //     rightWidget: JhCountDownBtn(
                  //         callBack: (value) {
                  //           state.tem.value = value;
                  //         },
                  //         //是否滑动滑块
                  //         verify: state.verify.value,
                  //         showBorder: true,
                  //         getVCode: () async {
                  //           return true;
                  //         }),
                  //     inputCallBack: (value) => {state.code.value = value}),
                  // // : Text(''),
                  // SizedBox(height: 40),
                  // //滑块
                  // SlideVerifyWidget(
                  //     callback: () => {state.verify.value = true}),
                ],
              )),
        );
      default:
    }
  }

  //结果数据处理

}
