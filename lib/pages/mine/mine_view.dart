import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mine_logic.dart';
import 'mine_state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../utils/jh_image_utils.dart';

class MinePage extends StatelessWidget {
  final MineLogic logic = Get.put(MineLogic());
  final MineState state = Get.find<MineLogic>().state;
  Widget item(BuildContext context, Map item, int index, int last) {
    if (index == 0) {
      return header(item);
    } else if (index == last - 1) {
      return Container(
        margin: EdgeInsets.only(top: 20),
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ElevatedButton(
            onPressed: () => {logic.onTapExit()},
            child: Text('退出登录', style: new TextStyle(fontSize: 18))),
      );
    } else {
      return InkWell(
        onTap: () {
          logic.onTapCell(item);
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Column(
              children: [
                Row(children: [
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item['icon'] != null
                            ? item['icon']
                            : 'assets/images/icon/more.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(item['itemName'] == null ? '' : item['itemName'],
                      style: new TextStyle(fontSize: 18)),
                  Flexible(fit: FlexFit.tight, child: SizedBox()),
                  Text(item['detail'] == null ? '' : item['detail'],
                      style:
                          new TextStyle(fontSize: 16, color: Colors.grey[400])),
                ]),
                // SizedBox(height: 15),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(left: 5, right: 5, top: 15),
                  color: Color(0x0f333333),
                )
              ],
            )),
      );
    }
  }

  Widget header(Map item) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: item['Avatar'] != null
                            ? NetworkImage(item['Avatar'])
                            : AssetImage('assets/images/icon/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(item['name'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                logic.onTapCell(item);
                              },
                              child: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(item['departmant'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontSize: 16,
                                color: Color(0xffb1b1b1),
                                fontWeight: FontWeight.normal))
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyRefreshController _controller = EasyRefreshController();
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text("我的"),
          actions: [
            Offstage(
                offstage: true,
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: InkWell(
                    child: IconButton(
                      icon: JhLoadAssetImage('icon/setting_w', width: 28),
                      onPressed: () => {},
                    ),
                  ),
                ))
          ],
        ),
        body: Obx(() => EasyRefresh(
            controller: _controller,
            firstRefresh: true,
            onRefresh: () async {
              logic.getPersonInfo();
            },
            onLoad: () async {
              print('上拉加载');
            },
            child: ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  return item(
                      context, state.list[index], index, state.list.length);
                }))));
  }
}
