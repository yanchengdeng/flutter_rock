/*
 * @Author: 凡琛
 * @Date: 2021-06-24 12:00:39
 * @LastEditTime: 2021-08-11 18:10:35
 * @LastEditors: Please set LastEditors
 * @Description: http请求
 * @FilePath: /Rocks_Flutter/lib/http/http.dart
 */

import 'request.dart';

typedef Success<T> = Function(T result);
typedef Fail = Function(int code);
typedef Progress = Function(int sent, int total);

class HttpRequest {
  // GET 请求
  static void get<T>(String url, params,
      {Success success, Fail fail, Progress progress}) {
    _request(Method.GET, url, params,
        success: success, fail: fail, progress: progress);
  }

  // POST 请求
  static Future post<T>(String url, params,
      {Success success, Fail fail, Progress progress}) async {
    await _request(Method.POST, url, params,
        success: success, fail: fail, progress: progress);
  }

  // 请求封装
  static Future _request<T>(Method method, String url, params,
      {Success success, Fail fail, Progress progress}) async {
    await Request.request(method, url, params, success: (result) {
      if (result['code'] == 200) {
        if (success != null) {
          success(result);
        }
      } else {
        //其他状态，弹出错误提示信息
        // JhProgressHUD.showText(result['msg']);
      }
    }, fail: (code, msg) {
      //  JhProgressHUD.showError(msg);
      if (fail != null) {
        fail(code);
      }
    }, progress: progress);
  }
}
