import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:toast/toast.dart';
import '../../widgets/jh_count_down_btn.dart';
import 'package:flutter/gestures.dart';
import '../common/form/loginTextField.dart';
import 'register_state.dart';
import 'package:get/get.dart';
import 'register_logic.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/SlideVerifyWidget.dart';
import '../common/form/form_select_cell.dart';
import '../../http/http.dart';
import '../../api/system.dart';

String _phone;
String _code;
String _pass;
String _repass;
String _username;
String _realname;
int _num = 0;
bool _verify = false;
typedef _InputCallBack = void Function(String value);

class RegisterWidget extends StatefulWidget {
  final bool hasData; //是否需要职业信息页面，如果不需要，第一个页面hasButton必须设置为true
  final bool isverify; //职业信息页面逻辑需要，勿改
  final List items; //服务端数据
  final bool agreement; //服务协议
  final bool hasButton; //第一个页面是否展示注册按钮，默认不展示
  final _InputCallBack inputCallBack; //输入回调
  final List title;
  const RegisterWidget({
    Key key,
    this.items,
    this.agreement: false,
    this.title,
    this.isverify: false,
    this.hasButton: false,
    this.hasData: false,
    this.inputCallBack,
  }) : super(key: key);
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  final RegisterState state = Get.find<RegisterLogic>().state;
  bool _flag = false;
  int _id;
  bool _tem = false;
  String weatheringStr;
  Map<String, String> _result = {};
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant RegisterWidget oldWidget) {
    _verify = false;

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    //重置变量
    _verify = false;
    _phone = null;
    _pass = null;
    _code = null;
    _repass = null;
    _realname = null;
    _username = null;
    _num = 0;
    _result = null;
    super.dispose();
  }

  void bottomSheet(String title, List<String> dataList) {
    HdBottomSheet.showText(Get.context,
        dataArr: dataList, title: title, clickCallback: (index, text) {});
  }

  //去掉头部keys，将values变为新数组 ex：{data:{List<Map>}=>{List<Map>}
  dynamic getValue(Object keys, Map map) {
    var values;
    map.forEach((key, value) {
      if (keys == key) values = value;
    });

    return values;
  }

  //提取List<Map>中keys对应的每一个value
  List<String> getValues(Object keys, List maps) {
    List<String> results = [];
    for (int i = 0; i < maps.length; i++) {
      results.add(getValue(keys, maps[i]));
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: MaterialApp(
          home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                actions: <Widget>[
                  widget.hasButton
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(7, 10, 10, 7),
                          child: InkWell(
                            child: Text('注册',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                            onTap: () =>
                                widget.hasData ? infoVerify() : outinfoVerify(),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        )
                      : Text('')
                ],
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  '注册账号',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: IndexedStack(
                children: <Widget>[
                  widget.hasData == false
                      //基础信息页面
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                JhLoginTextField(
                                    leftWidget: Icon(Icons.person),
                                    isName: true,
                                    hintText: "请设置用户名",
                                    labelText: '用户名',
                                    inputCallBack: (value) =>
                                        {_username = value}),
                                JhLoginTextField(
                                    leftWidget: Icon(Icons.person),
                                    isName: true,
                                    hintText: "请输入真实姓名",
                                    labelText: '真实姓名',
                                    inputCallBack: (value) =>
                                        {_realname = value}),
                                JhLoginTextField(
                                    leftWidget: Icon(Icons.lock),
                                    hintText: "请设置密码",
                                    labelText: '密码',
                                    isShowDeleteBtn: true,
                                    isPwd: true,
                                    pwdClose:
                                        'assets/images/icon/ic_pwd_close.png',
                                    pwdOpen:
                                        'assets/images/icon/ic_pwd_open.png',
                                    inputCallBack: (value) => {_pass = value}),
                                JhLoginTextField(
                                    leftWidget: Icon(Icons.lock),
                                    hintText: "确认密码",
                                    labelText: '确认密码',
                                    isShowDeleteBtn: true,
                                    isPwd: true,
                                    pwdClose:
                                        'assets/images/icon/ic_pwd_close.png',
                                    pwdOpen:
                                        'assets/images/icon/ic_pwd_open.png',
                                    inputCallBack: (value) => {
                                          setState(() {
                                            _repass = value;
                                          })
                                        }),
                                JhLoginTextField(
                                    leftWidget: Icon(Icons.phone_iphone),
                                    hintText: '请输入手机号',
                                    labelText: '手机号',
                                    maxLength: 11,
                                    keyboardType: TextInputType.number,
                                    inputCallBack: (value) => {
                                          setState(() {
                                            _phone = value;
                                          })
                                        }),
                                SizedBox(height: 10),
                                //验证码
                                JhLoginTextField(
                                    leftWidget: Icon(Icons.message),
                                    hintText: "请输入验证码",
                                    labelText: '验证码',
                                    show: _tem, //是否点击获取验证码，未点击不可以输入
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    //倒计时
                                    rightWidget: JhCountDownBtn(
                                        callBack: (value) {
                                          setState(() {
                                            _tem = value;
                                          });
                                        },
                                        //是否滑动滑块
                                        verify: _verify,
                                        showBorder: true,
                                        getVCode: () async {
                                          return true;
                                        }),
                                    inputCallBack: (value) => {
                                          setState(() {
                                            _code = value;
                                          })
                                        }),
                                // : Text(''),
                                SizedBox(height: 40),
                                //滑块
                                SlideVerifyWidget(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    callback: () => {
                                          setState(() {
                                            _verify = true;
                                          })
                                        }),
                                SizedBox(height: 40),
                                //没有数据不展示服务协议
                                widget.hasButton
                                    ? RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                            children: [
                                              widget.agreement
                                                  ? TextSpan(
                                                      text: '注册即视为同意《华东院服务协议》',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                      recognizer:
                                                          new TapGestureRecognizer()
                                                            //点击跳转
                                                            ..onTap = () => {})
                                                  : TextSpan(text: ''),
                                            ]),
                                      )
                                    : Text(''),
                              ],
                            ),
                          ),
                        )
                      //职业信息页面
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                baseSelectItem(
                                    getValues('title', widget.items),
                                    (number) => {
                                          HdBottomSheet.showText(Get.context,
                                              dataArr: getValues(
                                                  'title',
                                                  getValue('items',
                                                      widget.items[number])),
                                              title:
                                                  '${getValue('title', widget.items[number])}',
                                              clickCallback: (index, text) {
                                            if (text == '取消') {
                                              if (_result.containsValue(widget
                                                  .items[number]['type'])) {
                                                _result.remove(widget
                                                    .items[number]['type']);
                                              }
                                              print(widget.items);
                                              setState(() {
                                                widget.title[number] = '';
                                                _id = index;
                                                _flag = false;
                                              });
                                            } else {
                                              //点击获取底部弹窗的数据
                                              _result.putIfAbsent(
                                                  widget.items[number]['type'],
                                                  () =>
                                                      '${widget.items[number]['items'][index - 1]}');
                                              setState(() {
                                                widget.title[number] = text;
                                                _id = index;
                                                _flag = false;
                                              });
                                            }
                                          }),
                                        }),
                                SizedBox(height: 20),
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                      children: <InlineSpan>[
                                        widget.agreement
                                            ? TextSpan(
                                                text: '注册即视为同意《华东院服务协议》',
                                                style: TextStyle(
                                                    color: Colors.red),
                                                recognizer:
                                                    new TapGestureRecognizer()
                                                      ..onTap = () => print(
                                                          'Tap Here onTap'),
                                              )
                                            : TextSpan(text: ''),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              )),
        ));
  }

  //底部弹窗组件
  Widget baseSelectItem(List items, Function callBack) {
    //回调返回number确定用户点击的是哪一个弹窗内部数据
    int number = 0;
    List<Widget> _getData() {
      List<Widget> list = new List();
      for (int i = 0; i < widget.items.length; i++) {
        var listTile = HDFormSelectCell(
          cellHeight: 70,
          space: 110,
          hintTextStyle: TextStyle(color: Colors.blue),
          bgColor: Colors.transparent,
          leftWidget: Icon(Icons.person),
          title: "${items[i]}:",
          hintText: '${widget.title[i]}',
          clickCallBack: () {
            number = i;
            callBack(number);
            setState(() {
              _flag = true;
            });
          },
        );
        list.add(listTile);
      }
      return list;
    }

    return Container(
      child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: _getData()),
    );
  }

  //基础信息+职业信息双页面校验
  void infoVerify() {
    if (_username == null) {
      Toast.show('请输入用户名', context);
      return;
    }
    if (_realname == null) {
      Toast.show('请输入真实姓名', context);
      return;
    }
    if (_pass == null) {
      Toast.show('请输入密码', context);
      return;
    }
    if (_pass.length < 8) {
      Toast.show('密码不能低于8位数', context);
      return;
    }
    if (_repass == null) {
      Toast.show('请输入确认密码', context);
      return;
    }
    if (_repass != _pass) {
      Toast.show('两次输入密码不一致', context);
      return;
    }
    if (_phone == null) {
      Toast.show('请输入手机号', context);
      return;
    }
    if (_phone.length != 11) {
      Toast.show('手机号格式不正确', context);
      return;
    }
    if (_code != null && widget.isverify != false) {
      Toast.show('请输入验证码', context);
      return;
    }
    if (_code.length != 4 && widget.isverify != false) {
      Toast.show('验证码格式不正确', context);
      return;
    }
    if (_verify == false) {
      Toast.show('请滑动滑块', context);
      return;
    }
    for (int i = 0; i < widget.title.length; i++) {
      print(widget.title[i]);
      if (widget.title[i] == '') {
        showToast('${(getValues('title', widget.items)[i])}不能为空!');
        return;
      }
    }
    //组装发送数据
    dataMakeUp();
    HttpRequest.post(SystemApi.createUser, _result, success: (result) {
      showToast('$result');
    }, fail: (error) {
      showToast('$error');
    });
    Navigator.pop(context);
  }

  //基础信息单页面校验
  void outinfoVerify() {
    if (_username == null) {
      Toast.show('请输入用户名', context);
      return;
    }
    if (_realname == null) {
      Toast.show('请输入真实姓名', context);
      return;
    }
    if (_pass == null) {
      Toast.show('请输入密码', context);
      return;
    }
    if (_pass.length < 8) {
      Toast.show('密码不能低于8位数', context);
      return;
    }
    if (_repass == null) {
      Toast.show('请输入确认密码', context);
      return;
    }
    if (_repass != _pass) {
      Toast.show('两次输入密码不一致', context);
      return;
    }
    if (_phone == null) {
      Toast.show('请输入手机号', context);
      return;
    }
    if (_phone.length != 11) {
      Toast.show('手机号格式不正确', context);
      return;
    }
    if (_code != null && widget.isverify != false) {
      Toast.show('请输入验证码', context);
      return;
    }
    if (_code.length != 4 && widget.isverify != false) {
      Toast.show('验证码格式不正确', context);
      return;
    }
    if (_verify == false) {
      Toast.show('请滑动滑块', context);
      return;
    }
    dataMakeUp();
    HttpRequest.post(SystemApi.createUser, _result, success: (result) {
      showToast('$result');
    }, fail: (error) {
      showToast('$error');
    });
    Navigator.pop(context);
  }

  //组装数据
  void dataMakeUp() {
    _result.putIfAbsent("UserName", () => "$_username");
    _result.putIfAbsent("Password", () => "$_pass");
    _result.putIfAbsent("RealName", () => "$_realname");
    _result.putIfAbsent("PhoneNumber", () => "$_phone");
    _result.putIfAbsent("Captcha", () => "$_code");
  }
}
