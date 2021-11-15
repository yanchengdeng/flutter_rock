/*
 * @Author: 凡琛
 * @Date: 2021-06-24 10:50:45
 * @LastEditTime: 2021-08-16 10:53:03
 * @LastEditors: Please set LastEditors
 * @Description: 网络请求包装类
 * @FilePath: /Rocks_Flutter/lib/http/request.dart
 */
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
// import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import '../api/system.dart';
import 'error.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/projectConfig.dart';
import '../config/routeConfig.dart';
import '../utils/storage/authorStorage.dart';
// import '../../permission/permission.dart';
// import 'dart:convert' as convert;

// 设置网络超时时间
const int _connectTimeout = 15000;
const int _receiveTimeout = 15000;
const int _sendTimeout = 10000;
typedef Success<T> = Function(T data);
// typedef Fail<T> = Function(T error);
typedef Fail = Function(int code, String msg);
typedef Progress = Function(int sent, int total);
//使用：MethodValues[Method.POST]
enum Method { GET, POST, DELETE, PUT, PATCH, HEAD }
const MethodValues = {
  Method.GET: "get",
  Method.POST: "post",
  Method.DELETE: "delete",
  Method.PUT: "put",
  Method.PATCH: "patch",
  Method.HEAD: "head",
};

class Request {
  static Dio _dio;
  static Map setHeaders() {
    var info = ProjectConfig().getCurrentUserInfo();
    var token =
        (info == null || info['token'] == null) ? 'no-token' : info['token'];
    var userId =
        (info == null || info['userId'] == null) ? 'no-userId' : info['userId'];
    // 请求头添加参数
    var httpHeaders = {
      'Accept': 'application/json,*/*',
      'Content-Type': 'application/json',
      'token': token,
      'userid': userId
    };
    return httpHeaders;
  }

  // 创建 dio 实例对象
  static Dio createInstance() {
    // 懒加载
    if (_dio == null) {
      var options = BaseOptions(
        responseType: ResponseType.json,
        validateStatus: (status) {
          return true;
        },
        baseUrl: SystemApi.domain,
        headers: setHeaders(),
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
      );
      _dio = new Dio(options);
      _dio.interceptors.add(PrettyDioLogger());
      // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      //     (client) {
      //   client.badCertificateCallback =
      //       (X509Certificate cert, String host, int port) {
      //     return true;
      //   };
      // };
    }
    return _dio;
  }

  // 清空 dio 对象
  static clear() {
    _dio = null;
  }

// 网络请求方法
  static Future request<T>(Method method, String path, var params,
      {Success success, Fail fail, Progress progress}) async {
    try {
      //没有网络
      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        _onError(ExceptionHandle.net_error, '网络异常，请检查你的网络！', fail);
        return;
      }
      Dio _dio = createInstance();
      _dio.options.headers = setHeaders();
      var data;
      Map<String, dynamic> queryParameters;
      if (method == Method.GET && params.isNotEmpty) {
        queryParameters = params;
      }
      if (method == Method.POST) {
        data = params;
      }
      Response response = await _dio.request(path,
          data: data,
          queryParameters: queryParameters,
          options: Options(method: MethodValues[method]),
          onSendProgress: progress);
      if (response != null) {
        if (success != null) {
          success(response.data);
          // 登录失效处理
          if (response.data != null &&
              response.data['data'] != null &&
              response.data['data']['code'] != null &&
              response.data['data']['code'] == 6000) {
            AuthorStorage.removeAuthorInfo();
            RouteConfig().redirectToLogin();
          }
        }
      } else {
        _onError(ExceptionHandle.unknown_error, '未知错误', fail);
      }
    } on DioError catch (e) {
      final NetError netError = ExceptionHandle.handleException(e);
      _onError(netError.code, netError.msg, fail);
    }
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

void _onError(int code, String msg, Fail fail) {
  if (code == null) {
    code = ExceptionHandle.unknown_error;
    msg = '未知异常';
  }
  // LogUtils.print_('接口请求异常： code: $code, msg: $msg');
  if (fail != null) {
    fail(code, msg);
  }
}
