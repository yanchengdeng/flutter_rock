/*
 * @Author: 凡琛
 * @Date: 2021-06-30 15:25:00
 * @LastEditTime: 2021-08-13 18:11:55
 * @LastEditors: Please set LastEditors
 * @Description: 样本图像发布页面
 * @FilePath: /Rocks_Flutter/lib/pages/publish/publish_view.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'publish_logic.dart';
import 'publish_state.dart';
import '../../utils/jh_image_utils.dart';
import '../../utils/dataBiz.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PublishPage extends StatelessWidget {
  final PublishLogic logic = Get.put(PublishLogic());
  final PublishState state = Get.find<PublishLogic>().state;

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: List.generate(state.assets.length, (index) {
        final AssetEntity asset = state.assets.elementAt(index);
        return InkWell(
            child: selectedAssetWidget(asset, index),
            onTap: () => logic.onTapImageAsset(asset, index));
      }),
    );
  }

  Widget selectedAssetWidget(var asset, int index) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    image: AssetEntityImageProvider(asset, isOriginal: false),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Positioned(top: 5, right: 5, child: selectedAssetDeleteButton(index))
        ],
      ),
    );
  }

  Widget selectedAssetDeleteButton(int index) {
    return GestureDetector(
      onTap: () => logic.onRemoveAsset(index),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.grey[100].withOpacity(0.5),
        ),
        child: const Icon(Icons.close, size: 20.0),
      ),
    );
  }

// 选择组件
  Widget baseSelectItem(String title, String context, Function callBack) {
    return Container(
        margin: EdgeInsets.only(left: 3),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  "$title:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
            Expanded(
                flex: 6,
                child: Container(
                    child: Text("$context",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16),
                        overflow: TextOverflow.ellipsis))),
            Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: callBack,
                    icon: JhLoadAssetImage('icon/project', width: 16))),
          ],
        ));
  }

// 输入组件
  Widget inputTextField(String title, callBack(String text)) {
    return Container(
        margin: EdgeInsets.only(left: 3, right: 10, top: 10, bottom: 8),
        child: Row(children: [
          Expanded(
              flex: 3,
              child: Text(
                "$title:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          Expanded(
              flex: 7,
              child: Container(
                  height: 30,
                  // width: 200,
                  child: TextField(
                      onChanged: callBack,
                      autofocus: false,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.grey[300],
                            textBaseline: TextBaseline.alphabetic,
                          ),
                          // border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[300], width: 1)))))),
        ]));
  }

// 基本信息选择区块
  Widget baseInfoBlock() {
    return Obx(() => Container(
        // margin: EdgeInsets.only(top: 18),
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 10),
                child: Column(children: [
                  baseSelectItem(
                      '*岩石类别',
                      '${stringOrEmpty(state.rockName.value)}',
                      () => {logic.openSelecterPage('rock')}),
                  baseSelectItem(
                      '*风化程度',
                      '${stringOrEmpty(state.weatheringStr.value)}',
                      () => {
                            logic.bottomSheet('风化程度',
                                ['全风化', '强风化', '弱（中风化）', '微风化', '新鲜/未风化'])
                          }),
                  baseSelectItem(
                      '*完整程度',
                      '${stringOrEmpty(state.integrityStr.value)}',
                      () => {
                            logic.bottomSheet(
                                '完整程度', ['完整', '较完整', '较破碎', '破碎', '极破碎'])
                          }),
                  inputTextField(' 岩石颜色', (text) => {state.color.value = text}),
                  inputTextField(
                      ' 岩石产状', (text) => {state.occurrence.value = text}),
                ])))));
  }

  Widget locationBlock() {
    return Obx(() => Container(
        margin: EdgeInsets.only(top: 18),
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Column(children: [
                  baseSelectItem(
                      '*项目选择',
                      '${stringOrEmpty(state.projectName.value)}',
                      () => {logic.openProjectPage()}),
                  baseSelectItem(
                      ' 地址选择',
                      '${stringOrEmpty(state.location.value)}',
                      () => {logic.openLocationPage()}),
                  baseSelectItem(
                      ' 地图选点',
                      (doubleOrZero(state.longitude.value) != 0.0 &&
                              doubleOrZero(state.latitude.value) != 0.0)
                          ? '纬度：${doubleOrZero(state.latitude.value).toStringAsFixed(2)}  经度：${doubleOrZero(state.longitude.value).toStringAsFixed(2)}'
                          : '',
                      () => {logic.openMapPage()}),
                ])))));
  }

// 照片选择区块
  Widget photoBlock() {
    return Obx(() => Container(
            child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          Text(
                            "*上传图片",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${state.assets.length > 0 ? ' (已选${state.assets.length}张)' : ' (单次最多选择${state.maxImages.value}张)'}",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                          )
                        ],
                      )),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {logic.dealWithSelecter(0)},
                          icon: JhLoadAssetImage('icon/gallary', width: 24)),
                      IconButton(
                          onPressed: () => {logic.dealWithSelecter(1)},
                          icon: JhLoadAssetImage('icon/takePhoto', width: 24)),
                    ],
                  )
                ],
              ),
              Container(
                  child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                    padding: EdgeInsets.all(8),
                    height: state.assets.length <= 0
                        ? 0
                        : state.assets.length <= 4
                            ? 95
                            : 185,
                    width: double.infinity,
                    child: state.assets.length > 0 ? buildGridView() : null),
              ))
            ],
          ),
        )));
  }

// 缩略图
  Widget videoSnip() {
    return GestureDetector(
        onTap: logic.playVideo,
        child: Obx(() => Container(
            padding: EdgeInsets.only(left: 12, bottom: 12),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: 120,
                  child: FutureBuilder(
                    //显示缩略图
                    future: state.initializeVideoPlayerFuture.value,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: state.controller.value.value.aspectRatio,
                          child: VideoPlayer(state.controller.value),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                    child: Container(
                        height: 32,
                        width: 32,
                        child: Image.asset('assets/images/icon/play.png')))
              ],
            ))));
  }

// 视频区块
  Widget videoBlock() {
    return Container(
      // margin: EdgeInsets.only(top: 5),
      child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          Text(
                            " 上传视频",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            " (最长拍摄${state.maxDuration}s)",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                          )
                        ],
                      )),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => {logic.dealWithSelecter(2)},
                          icon: JhLoadAssetImage('icon/gallary', width: 24)),
                      IconButton(
                          onPressed: () => {logic.dealWithSelecter(3)},
                          icon: JhLoadAssetImage('icon/camera', width: 28)),
                    ],
                  ),
                ],
              ),
              Obx(() => Offstage(
                  offstage: state.isSelectered.value == 0, child: videoSnip()))
            ],
          )),
    );
  }

//备注信息区块
  Widget extInfoBlock(String title, var tag) {
    return Container(
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  margin: EdgeInsets.only(left: 8, top: 12),
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
              Container(
                  margin: EdgeInsets.all(12),
                  child: Container(
                      child: TextField(
                          onChanged: tag == 0 ? logic.describe : logic.memo,
                          autofocus: false,
                          maxLines: tag == 0 ? 5 : 2,
                          maxLength: tag == 0 ? 500 : 200,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              enabledBorder: OutlineInputBorder(
                                //未选中时候的颜色
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.grey[300],
                                ),
                              ),
                              helperText: tag == 0 ? "详细的信息可以在此描述" : "可以在此备注",
                              helperStyle:
                                  TextStyle(color: Colors.grey[400])))))
            ])));
  }

// 页面主体结构
  Widget pickerBlock(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {FocusScope.of(context).requestFocus(FocusNode())},
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            // 项目选择
            locationBlock(),
            // 岩石选择
            baseInfoBlock(),
            //照片选择区
            photoBlock(),
            //视频附件
            videoBlock(),
            //描述信息
            extInfoBlock(' 描述信息', 0),
            //备注信息
            extInfoBlock(' 备注信息', 1),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('岩矿样本图像发布'),
          actions: [
            InkWell(
              child: Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 15),
                child: Center(
                  child: Text("提交",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                ),
              ),
              onTap: () => {logic.publish(context)},
            ),
          ],
        ),
        body: pickerBlock(context));
  }
}
