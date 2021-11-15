/*
 * @Author: 凡琛
 * @Date: 2021-07-13 11:24:04
 * @LastEditTime: 2021-08-09 15:53:08
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/amap/amap_view.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'amap_logic.dart';
import 'amap_state.dart';
import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'choice_Point.dart';

class AmapPage extends StatelessWidget {
  final AmapLogic logic = Get.put(AmapLogic());
  final AmapState state = Get.find<AmapLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text("地图选择"),
          actions: [
            Offstage(
              offstage: !state.showSave.value,
              child: InkWell(
                child: Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(right: 15),
                  child: Center(
                    child: Text("保存",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                ),
                onTap: () => {logic.submit()},
              ),
            )
          ],
        ),
        body: Container(child: MapChoicePoint((LatLng point) {
          logic.createMark(point.latitude, point.longitude);
        })));
  }
}
