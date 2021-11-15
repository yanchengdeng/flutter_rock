import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdec_flutter/pages/medeia/LoadingPage.dart';
import 'medeia_logic.dart';
import 'medeia_state.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:toast/toast.dart';

/// @description:
/// @王梓豪
/// @date: 2021/07/12 15:40:38

class MedeiaPage extends StatelessWidget {
  final MedeiaLogic logic = Get.put(MedeiaLogic());
  final MedeiaState state = Get.find<MedeiaLogic>().state;
  @override
  Widget build(BuildContext context) {
    //
    return Container(
        child: GestureDetector(
            onTap: () {
              Get.back();
            },
            onLongPress: () {},
            child: Material(
                color: Colors.black,
                child: Stack(
                  children: [
                    Obx(
                      () => PhotoViewGallery.builder(
                        itemCount: state.files.length,
                        backgroundDecoration: null,
                        pageController: logic.pageController,
                        scrollPhysics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          state.temIndex.value = index;
                        },
                        builder: (BuildContext context, int index) {
                          var _imgURL = state.files[index];
                          ImageProvider picture = logic.isNetWorkImg(_imgURL)
                              ? NetworkImage(_imgURL)
                              : FileImage(_imgURL);
                          return PhotoViewGalleryPageOptions(
                            heroAttributes: PhotoViewHeroAttributes(
                                tag: 'state.files[index]'),
                            imageProvider: picture,
                            initialScale: PhotoViewComputedScale.contained,
                            //最小缩放
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            maxScale: PhotoViewComputedScale.covered * 2,
                          );
                        },

                        //loading页面
                        loadingBuilder: (context, event) {
                          return LoadingPage();
                        },
                      ),
                    ),
                    Positioned(
                      //右上角关闭按钮
                      left: 10,
                      top: MediaQuery.of(context).padding.top,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    Positioned(
                      //图片index显示
                      top: MediaQuery.of(context).padding.top + 15,
                      width: MediaQuery.of(context).size.width,
                      child: Obx(() => Center(
                          child: Text(
                              "${state.temIndex.value + 1}/${state.files.length}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)))),
                    ),
                    logic.flag
                        ? Positioned(
                            top: MediaQuery.of(context).padding.top,
                            right: 10,
                            child: PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 40,
                              ),
                              itemBuilder: (BuildContext context) {
                                return state.menuList;
                              },
                              onSelected: (Object objects) {
                                if (objects == 1001) {
                                  saveImg();
                                } else if (objects == 1002) {
                                  saveHDImg();
                                } else {
                                  for (int i = 0; i < state.title.length; i++) {
                                    if (objects == state.value[i]) {}
                                  }
                                }
                              },
                              onCanceled: () {},
                            ),
                          )
                        : Text('')
                  ],
                ))));
  }

  //保存图片
  saveImg() async {
    var response = await Dio().get(state.files[state.temIndex.value],
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
    );
    Toast.show('保存成功', Get.overlayContext,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        textColor: Colors.white);
  }

  //保存原图
  saveHDImg() async {
    var response = await Dio().get(state.files[state.temIndex.value],
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
    );
    Toast.show('保存成功', Get.overlayContext,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        textColor: Colors.white);
  }
}
