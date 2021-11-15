/*
 * @Author: 凡琛
 * @Date: 2021-08-17 17:06:29
 * @LastEditTime: 2021-08-17 18:03:56
 * @LastEditors: Please set LastEditors
 * @Description: 系统配置
 * @FilePath: /Rocks_Flutter/lib/config/systemConfig.dart
 */
import '../../../api/system.dart';
import '../../../http/http.dart';
import '../notification/notification.dart';

class SystemConfigInstance {
  factory SystemConfigInstance() => _sharedInstance();
  static SystemConfigInstance _instance;
  static var systemConfig = {}; //系统配置
  SystemConfigInstance._() {
    SystemConfigInstance.getSystemConfigRequest();
  }
  static SystemConfigInstance _sharedInstance() {
    if (_instance == null) {
      _instance = SystemConfigInstance._();
    }
    return _instance;
  }

  static refreshPermission() {
    _instance = SystemConfigInstance._();
  }

  // 获取系统配置
  static getSystemConfig() {
    return systemConfig;
  }

  // 请求权限列表
  static getSystemConfigRequest() async {
    HttpRequest.post(SystemApi.systemConfig, {}, success: (result) {
      var data = result['data'];
      if (data != null && data['success'] && data['result'] != null) {
        systemConfig = data['result'];
        // 广播通知页面刷新
        bus.emit(Emit.updateSystemConfig);
      }
    }, fail: (error) {});
  }
}
