/*
 * @Author: 凡琛
 * @Date: 2021-08-05 17:08:55
 * @LastEditTime: 2021-08-17 16:44:56
 * @LastEditors: Please set LastEditors
 * @Description: 用户权限统一处理
 * @FilePath: /Rocks_Flutter/lib/utils/userPermission.dart
 */
import '../../../api/system.dart';
import '../../../http/http.dart';
import '../notification/notification.dart';

class PermissionSharedInstance {
  // 单例公开访问点
  factory PermissionSharedInstance() => _sharedInstance();
  // 静态私有成员，没有初始化
  static PermissionSharedInstance _instance;
  static var permissions; //权限列表
  // 私有构造函数
  PermissionSharedInstance._() {
    PermissionSharedInstance.getUserAllPermission();
  }
  // 静态、同步、私有访问点
  static PermissionSharedInstance _sharedInstance() {
    if (_instance == null) {
      _instance = PermissionSharedInstance._();
    }
    return _instance;
  }

  // 更新权限值
  static refreshPermission() {
    _instance = PermissionSharedInstance._();
  }

  // 获取权限列表
  static getpermissions() {
    return permissions;
  }

  // 请求权限列表
  static getUserAllPermission() async {
    HttpRequest.post(SystemApi.userAllPermissions, {}, success: (result) {
      var data = result['data'];
      if (data != null && data['success'] && data['result'] != null) {
        permissions = data['result'];
        // 广播通知页面刷新
        bus.emit(Emit.updatePermission);
      }
    }, fail: (error) {});
  }

  // 系统级权限
  static Future<bool> getSystemAccess(String permissionCode) async {
    bool result = false;
    if (permissions == null || permissions.length <= 0) return result;
    for (var item in permissions) {
      if (item['IsSystem'] == true) {
        for (var i in item['Permissions']) {
          if (i['Code'] == permissionCode) {
            result = true;
            break;
          }
        }
        break;
      }
    }
    return result;
  }

  // 项目级别权限
  static Future<bool> getProjectAccess(
      int projectId, String permissionCode) async {
    bool result = false;
    if (permissions == null || permissions.length <= 0) return result;
    for (var item in permissions) {
      if (item['ProjectID'] == projectId) {
        for (var i in item['Permissions']) {
          if (i['Code'] == permissionCode) {
            result = true;
            break;
          }
        }
        break;
      }
    }
    return result;
  }
}
