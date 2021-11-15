/// @description:
/// @author 
/// @date: 2021/08/03 15:43:12
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get.dart';
class InfoModifyState {
  String type = Get.parameters['type'];//服务端下发的string类型
  dynamic itemType; //items类的类型
  RxString oldpass; //旧密码
  RxString newpass; //新密码
  RxString repass;  //确认密码
  RxString phone;   //电话
  RxString name;    //姓名
  RxString emial;   //邮箱
  RxBool verify;    //是否滑动滑块
  RxBool tem;       
  RxString code;    //验证码
  RxMap list;      //临时数组
  
  InfoModifyState() {
    list={}.obs;
    list.value=Get.arguments['item'];
    repass=''.obs;
    oldpass=''.obs;
    newpass=''.obs;
    name=''.obs;
    code=''.obs;
    phone=''.obs;
    tem=false.obs;
    verify=false.obs;
    emial=''.obs;
    itemType=getType(type);
    ///Initialize variables
  }
 
}
  
  dynamic getType(String type){
    if(type=='Password')
      return items.Password;
    if(type=='RealName')
      return items.RealName;
    if(type=='PhoneNumber')
      return items.PhoneNumber;
    if(type=='Email')
      return items.Email;
  }
  enum items{
   RealName,
   PhoneNumber,
   Email,
   Password,

  }
