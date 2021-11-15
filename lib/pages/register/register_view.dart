import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_logic.dart';
import 'register_state.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// @author
/// @date: 2021/07/21 08:38:06
/// @description:

class RegisterPage extends StatelessWidget {
  final RegisterLogic logic = Get.put(RegisterLogic());
  final RegisterState state = Get.find<RegisterLogic>().state;
  final FocusNode node1 = FocusNode();
  final FocusNode node2 = FocusNode();
  final FocusNode node3 = FocusNode();
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Material(
       child: Obx(()=> Swiper(scrollDirection: Axis.horizontal,
      itemCount: state.pagWidgets.length,
      autoplay: false,
      loop: false,
      onIndexChanged: (index) {
        print('滚动到：$index');
        state.index = index;
      },
      itemBuilder: (BuildContext context, int index) {   
        return Scaffold(
          body:
            state.pagWidgets[index]
          );
      },

      // 分页指示器
      pagination: SwiperPagination(
          // 位置 Alignment.bottomCenter 底部中间
          alignment: Alignment.bottomCenter,
          // 距离调整
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
          builder: DotSwiperPaginationBuilder(
              space: 5,
              size: state.index == state.pagWidgets.length - 1 ? 0 : 10,
              activeSize: state.index == state.pagWidgets.length - 1 ? 0 : 12,
              color: Colors.grey,
              activeColor: Colors.blue)),
    ))
      ),
    );
    
  }
}
