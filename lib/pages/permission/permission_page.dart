/*
 * @Author: 凡琛
 * @Date: 2021-07-27 19:09:39
 * @LastEditTime: 2021-08-05 12:14:45
 * @LastEditors: Please set LastEditors
 * @Description: 权限配置页面
 * @FilePath: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:oktoast/oktoast.dart';
import '../../api/system.dart';
import '../../http/http.dart';

class CheckItem {
  String name;
  String detail;
  bool value;
  CheckItem(this.name, this.detail, this.value);
}

class PermissionPage extends StatefulWidget {
  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  EasyRefreshController _controller = EasyRefreshController();
  List list = [];
  bool isChange = false;
  @override
  void initState() {
    getPermission();
    super.initState();
  }

// 获取权限表
  getPermission() {
    HttpRequest.post(SystemApi.getPersmissionList, Get.parameters,
        success: (result) {
      var data = result['data'];
      if (data != null && data['result'] != null) {
        setState(() {
          list = data['result'];
        });
      }
    }, fail: (error) {});
  }

  // 授权
  authorize() {
    var permissionStatus = getPermissionStatus(list);
    var param = {
      'PermissionStatus': permissionStatus,
      'RoleID': Get.parameters['RoleID'] ?? ''
    };
    HttpRequest.post(SystemApi.authorize, param, success: (result) {
      var data = result['data'];
      if (data != null && data['result'] != null) {
        setState(() {
          list = data['result'];
        });
      }
      Get.back();
    }, fail: (error) {
      showToast('授权失败');
    });
  }

  // 多选框
  void checkOnChanged(bool value, int index) {
    isChange = true;
    list[index]['Selected'] = value;
    setState(() {
      list = list;
    });
  }

  // 获取权限选择情况
  Map getPermissionStatus(List arry) {
    var selectedList = [];
    var deletedList = [];
    for (var permission in list) {
      if (permission['Selected'] && permission['PermissionID'] != null) {
        selectedList.add(permission['PermissionID']);
      }
      if (!permission['Selected'] && permission['PermissionID'] != null) {
        deletedList.add(permission['PermissionID']);
      }
    }
    return {'SelectedList': selectedList, 'DeletedList': deletedList};
  }

  // 点击添加
  onTapSave() {
    if (!isChange) {
      showToast('无修改内容，无需保存');
      return;
    }
    Get.defaultDialog(
        title: '${Get.parameters['RoleName'] ?? ''} 权限配置',
        middleText: '是否确认修改？',
        textCancel: '取消',
        textConfirm: '确认',
        barrierDismissible: false,
        confirmTextColor: Colors.white,
        titleStyle: TextStyle(fontSize: 18),
        radius: 6,
        onConfirm: () => {authorize(), Get.back()});
  }

// 复选cell
  Widget cell(var item, int index) {
    return Container(
        child: Column(
      children: [
        ListTile(
            // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            title: Text(list[index]['PermissionName'] ?? ''),
            leading: Checkbox(
              value: list[index]['Selected'] ?? false,
              //选中时的颜色
              activeColor: Colors.blue,
              onChanged: (value) {
                checkOnChanged(value, index);
              },
            ),
            subtitle: Text(list[index]['PermissionDescribe'] ?? '描述'),
            trailing: Text(
              list[index]['Code'] ?? '',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            onTap: () {
              // 点击参看详细信息TODO
            }),
        Divider(
          height: 0.0,
          indent: 0.0,
          color: Color(0x3f333333),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('${Get.parameters['RoleName'] ?? ''} 权限配置'),
        actions: [
          InkWell(
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(left: 2, right: 10),
              child: Center(
                child: Text("保存",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              ),
            ),
            onTap: onTapSave,
          ),
        ],
      ),
      body: EasyRefresh(
          controller: _controller,
          firstRefresh: false,
          onRefresh: () async {
            getPermission();
          },
          onLoad: () async {
            print('上拉加载');
            // 追加数据
          },
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return cell(list[index], index);
              })),
    );
  }
}
