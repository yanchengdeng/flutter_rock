/*
 * @Author: your name
 * @Date: 2021-07-27 19:09:39
 * @LastEditTime: 2021-08-06 14:43:31
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: 
 */
import 'package:flutter/material.dart';
import '../../widgets/search_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../api/system.dart';
import '../../http/http.dart';

class CheckItem {
  String name;
  String detail;
  bool value;
  CheckItem(this.name, this.detail, this.value);
}

class SelectedPage extends StatefulWidget {
  @override
  _SelectedPageState createState() => _SelectedPageState();
}

class _SelectedPageState extends State<SelectedPage> {
  EasyRefreshController _controller = EasyRefreshController();
  List list = [];
  var params;
  @override
  void initState() {
    request();
    super.initState();
  }

// 获取人员列表
  request() {
    HttpRequest.get(SystemApi.getUserList, Get.parameters, success: (result) {
      var data = result['data'];
      if (data != null && data['success'] && data['result'] != null) {
        setState(() {
          list = data['result'];
        });
      }
    }, fail: (error) {});
  }
  // 获取角色项目下角色列表

  // 多选框
  void checkOnChanged(bool value, int index) {
    list[index]['Selected'] = value;
    setState(() {
      list = list;
    });
  }

  List getSelectedList(List arry) {
    var selectedList = [];
    for (var user in list) {
      if (user['Selected']) {
        selectedList.add(user);
      }
    }
    return selectedList;
  }

  // 点击添加
  onTapAdd() {
    Get.back(result: getSelectedList(list));
  }

  // 输入框回调
  void onSearchTextChanged(String context) => {};
  // 清除输入框回调
  void onCleanSearch() => {};

// 复选cell
  Widget cell(var item, int index) {
    return Container(
        child: Column(
      children: [
        ListTile(
            // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            title: Text(list[index]['Name'] ?? ''),
            leading: Checkbox(
              value: list[index]['Selected'] ?? false,
              //选中时的颜色
              activeColor: Colors.blue,
              onChanged: (value) {
                checkOnChanged(value, index);
              },
            ),
            subtitle: Text(list[index]['UserName'] ?? '描述'),
            trailing: Text(
              list[index]['PhoneNumber'] ?? '',
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
        title: SearchBar(
            hintText: '输入人名进行搜索',
            inputCallBack: onSearchTextChanged,
            cleanCallBack: onCleanSearch),
        actions: [
          InkWell(
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(left: 2, right: 2),
              child: Center(
                child: Text("搜索",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              ),
            ),
            onTap: () {},
          ),
          InkWell(
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 12, left: 2),
              child: Center(
                child: Text("添加",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              ),
            ),
            onTap: onTapAdd,
          )
        ],
      ),
      body: EasyRefresh(
          controller: _controller,
          firstRefresh: false,
          onRefresh: () async {
            request();
          },
          onLoad: () async {
            print('上拉加载');
            // 追加数据
          },
          child: list.length > 0
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return cell(list[index], index);
                  })
              : Container(
                  height: 100,
                  child: Center(
                      child: Text('请先加人员至项目',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey[400]))),
                )),
    );
  }
}
