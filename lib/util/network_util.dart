import 'package:connectivity/connectivity.dart';

class NetworkUtil {
  static final String NO_NETWORK = "当前暂未打开网络，请打开网络重试";
  static final String UNKOWN_ERROR = "网络出了点问题，请稍后重试";
  static final String CONNECT_TIMEOUT = "网络出了点问题，请稍后重试";

  static Future<bool> hasNetwork() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
