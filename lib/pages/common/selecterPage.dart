import 'package:flutter/material.dart';
import '../../api/system.dart';
import '../../http/http.dart';
import 'package:get/get.dart';

class NameBean {
  String name;
  double level;
  String code;
  List<NameBean> children;

  // children 默认初始化
  NameBean(this.name, this.level, this.code,
      [this.children = const <NameBean>[]]);
}

class SelecterPage extends StatefulWidget {
  @override
  _SelecterPageState createState() => _SelecterPageState();
}

class _SelecterPageState extends State<SelecterPage> {
  List<NameBean> rockData = <NameBean>[];
  @override
  void initState() {
    super.initState();
    loadData();
  }

// 加载json 并递归解析
  void loadData() async {
    //请求项目列表
    HttpRequest.get(SystemApi.getRockClassToJson, {}, success: (result) {
      var data = result['data'];
      List list = data['rock'];
      List<NameBean> resultList = decodeItem(list, rockData);
      setState(() {
        rockData = resultList;
      });
    }, fail: (error) {});
  }

// 递归遍历打印
  List<NameBean> decodeItem(List list, List<NameBean> data) {
    List<NameBean> resultList = <NameBean>[];
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      //设置缩进
      double level = ((item['level'] == null ? 1.0 : item['level']) - 1.0) * 8;
      if (item['child'] != null) {
        List<NameBean> subList = <NameBean>[];
        NameBean itemBean = new NameBean(item['name'], level, item['code'],
            decodeItem(item['child'], subList));
        resultList.add(itemBean);
      } else {
        NameBean itemBean = new NameBean(item['name'], level, item['code']);
        resultList.add(itemBean);
      }
    }
    return resultList;
  }

// 1、需要根据大类来优化图标颜色，从数据源标志位做区分
// 2、如果有图片区分就更好
  Widget _buildItem(NameBean bean) {
    if (bean.children.isEmpty) {
      return Container(
          margin: EdgeInsets.only(left: bean.level),
          child: ListTile(
            title: Text(bean.name),
            trailing: Container(
                child: Text(
              "相关介绍",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )),
            onTap: () {
              Get.back(result: bean);
            },
          ));
    }
    return ExpansionTile(
      key: PageStorageKey<NameBean>(bean),
      title: Text(bean.name),
      iconColor: Colors.blue,
      textColor: Colors.blue,
      children: bean.children.map<Widget>(_buildItem).toList(),
      leading: Container(
        margin: EdgeInsets.only(left: bean.level),
        child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              bean.name.substring(0, 1),
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }

  Widget nameItemWidget(NameBean bean) {
    return ListTile(
      title: _buildItem(bean),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('类别选择'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            nameItemWidget(rockData[index]),
        itemCount: rockData.length,
      ),
    );
  }
}
