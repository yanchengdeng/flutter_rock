/*
 * @Author: 凡琛
 * @Date: 2021-06-24 15:00:28
 * @LastEditTime: 2021-08-13 10:38:35
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/login/login_view.dart
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'login_logic.dart';
import 'login_state.dart';
import '../common/form/loginTextField.dart';
import '../common/loginButton.dart';
import '../common/form/form.dart';

class LoginPage extends StatelessWidget {
  final LoginLogic logic = Get.put(LoginLogic());
  final LoginState state = Get.find<LoginLogic>().state;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _node1 = FocusNode();
  final FocusNode _node2 = FocusNode();

  Widget mainBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                SafeArea(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        child: Text("注册", style: TextStyle(fontSize: 18)),
                        onTap: () {
                          Get.toNamed('/registor');
                        },
                      )),
                ),
                SizedBox(height: 50),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: state.avatar.value != ''
                            ? NetworkImage(state.avatar.value)
                            : AssetImage('assets/images/icon/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                      border:
                          new Border.all(color: Colors.grey[300], width: 1)),
                ),
                SizedBox(height: 30),
                JhLoginTextField(
                    text: state.name.value,
                    hintText: "请输入用户名",
                    focusNode: _node1,
                    isName: false,
                    leftWidget: Icon(Icons.person),
                    isShowDeleteBtn: true,
                    controller: _nameController,
                    inputCallBack: (value) => state.name.value = value),
                SizedBox(height: 10),
                JhLoginTextField(
                    hintText: "请输入密码",
                    focusNode: _node2,
                    leftWidget: Icon(Icons.lock),
                    isShowDeleteBtn: true,
                    isPwd: true,
                    isName: false,
                    controller: _passwordController,
                    pwdClose: 'assets/images/icon/ic_pwd_close.png',
                    pwdOpen: 'assets/images/icon/ic_pwd_open.png',
                    inputCallBack: (value) => state.pwd.value = value),
                SizedBox(height: 50),
                JhButton(
                  text: "登 录",
                  onPressed: () => {logic.onTapSubmit(context)},
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      child: GestureDetector(
                          child: Text(
                            '验证码登录',
                          ),
                          onTap: () => {}),
                    ),
                    Container(
                      height: 50.0,
                      child: GestureDetector(
                          child: Text(
                            '忘记密码',
                          ),
                          onTap: () => {logic.onTapForget()}),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardActions(
        config: JhForm.getKeyboardConfig(context, [_node1, _node2]),
        child: Obx(() => mainBody(context)),
      ),
    );
  }
}
