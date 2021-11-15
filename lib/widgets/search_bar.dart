/*
 * @Author: 凡琛
 * @Date: 2021-07-23 09:13:42
 * @LastEditTime: 2021-07-23 15:28:30
 * @LastEditors: Please set LastEditors
 * @Description: 导航栏搜索框组件
 * @FilePath: /Rocks_Flutter/lib/widgets/search_bar.dart
 */
import 'package:flutter/material.dart';

//定义回调函数
typedef _InputCallBack = void Function(String value);
typedef _CleanCallBack = void Function();

class SearchBar extends StatefulWidget {
  final int tag;
  final String hintText;
  final _InputCallBack inputCallBack;
  final _CleanCallBack cleanCallBack;
  const SearchBar(
      {Key key,
      this.tag = 1,
      this.hintText,
      this.inputCallBack,
      this.cleanCallBack})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Container(
            height: 40.0,
            child: new Padding(
                padding: EdgeInsets.only(
                    left: widget.tag == 0 ? 12 : 0), // 判断是否有放回按钮TODO
                child: new Card(
                    child: new Container(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: TextField(
                            maxLines: 1,
                            autofocus: false,
                            controller: controller,
                            decoration: new InputDecoration(
                                contentPadding: EdgeInsets.only(top: 2.0),
                                hintText: widget.hintText,
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                isCollapsed: true,
                                border: InputBorder.none),
                            onChanged: widget.inputCallBack,
                          ),
                        ),
                      ),
                      new IconButton(
                        icon: new Icon(Icons.cancel),
                        color: Colors.grey,
                        iconSize: 18.0,
                        onPressed: () {
                          widget.cleanCallBack();
                          controller.clear();
                        },
                      ),
                    ],
                  ),
                ))),
          )),
    );
  }
}
