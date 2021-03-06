import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

typedef CallBack = void Function(String value);

class SlideVerifyWidget extends StatefulWidget {
  /// 背景色
  final Color backgroundColor;

  /// 滑动过的颜色
  final Color slideColor;

  /// 边框颜色
  final Color borderColor;

  final double height;
  final double width;
  final Callback callback;
  final VoidCallback verifySuccessListener;
  
  const SlideVerifyWidget({
    Key key,
    this.backgroundColor = Colors.grey,
    this.slideColor = Colors.blue,
    this.borderColor = Colors.grey,
    this.height = 60,
    this.width = 350,
    this.verifySuccessListener,
    this.callback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SlideVerifyState();
  }
}

class SlideVerifyState extends State<SlideVerifyWidget>
    with TickerProviderStateMixin {
  double height;
  double width;
  String _image = 'assets/images/icon/test.png';
  double sliderDistance = 0;

  double initial = 0.0;

  /// 滑动块宽度
  double sliderWidth = 67;

  /// 验证是否通过，滑动到最右方为通过
  bool verifySuccess = false;

  /// 是否允许拖动
  bool enableSlide = true;

  AnimationController _animationController;
  Animation _curve;

  @override
  void initState() {
    super.initState();
    this.width = widget.width;
    this.height = widget.height;
    _initAnimation();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        if (!enableSlide) {
          return;
        }
        initial = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!enableSlide) {
          return;
        }
        sliderDistance = details.globalPosition.dx - initial;
        if (sliderDistance < 0) {
          sliderDistance = 0;
        }

        /// 当滑动到最右边时，通知验证成功，并禁止滑动
        if (sliderDistance > width - sliderWidth) {
          _image = 'assets/images/icon/safe.png';
            widget.callback();
          sliderDistance = width - sliderWidth;
          enableSlide = false;
          verifySuccess = true;
          
          if (widget.verifySuccessListener != null) {
            widget.verifySuccessListener();
          }
          
        }
        setState(() {
            
          });
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        /// 滑动松开时，如果未达到最右边，启动回弹动画
        if (enableSlide) {
          enableSlide = false;
          _animationController.forward();
        }
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: widget.backgroundColor,

            /// 圆角实现
            borderRadius: BorderRadius.all(new Radius.circular(8))),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: height,
                /// 当slider滑动到距左边只有两三像素距离时，已滑动背景会有一点点渲染出边框范围，
                /// 因此当滑动距离小于1时，直接将宽度设置为0，解决滑动块返回左边时导致的绿色闪动，但如果是缓慢滑动到左边该问题仍没解决
                width:
                    sliderDistance < 1 ? 0 : sliderDistance + sliderWidth / 2,
                decoration: BoxDecoration(
                    color: widget.slideColor,

                    /// 圆角实现
                    borderRadius: BorderRadius.all(new Radius.circular(8))),
              ),
            ),
            Center(
              child: Text(
                verifySuccess ? "验证成功" : "请按住滑块，拖动到最右边",
                style: TextStyle(
                    color: verifySuccess ? Colors.white : Colors.white,
                    fontSize: 14),
              ),
            ),
            Positioned(
              top: 0,

              /// 此处将sliderDistance距离往左偏2是解决当滑动块滑动到最右边时遮挡外部边框
              left: sliderDistance > sliderWidth
                  ? sliderDistance 
                  : sliderDistance,
              child: Container(
                width: sliderWidth,
                height: height ,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: widget.borderColor),

                    /// 圆角实现
                    borderRadius: BorderRadius.all(new Radius.circular(8))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 6,
                    ),
                    Image.asset(
                      _image,
                      height: 35,
                      width: 35,
                    ),
                    // Image.asset("assets/images/icon/safty.png", height: 16, width: 16,),
                    /// 因为向右箭头有透明边距导致两个箭头间隔过大，因此将第二个箭头向左偏移，如果切图无边距则不用偏移
                    // Transform(
                    //   transform: Matrix4.translationValues(-8, 0, 0),
                    //   child: Image.asset("assets/images/icon/saftysurance.png", height: 30, width: 30,),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 回弹动画
  void _initAnimation() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _curve.addListener(() {
      setState(() {
        sliderDistance = sliderDistance - sliderDistance * _curve.value;
        if (sliderDistance <= 0) {
          sliderDistance = 0;
        }
      });
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        enableSlide = true;
        _animationController.reset();
      }
    });
  }
}
