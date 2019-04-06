import 'package:my_mini_app/util/auth_util.dart';
import 'package:rxdart/rxdart.dart';

class AuthProvider {
  AuthProvider._internal() {
    print("AuthProvider 已经创建了");
    _isLogin();
  }

  factory AuthProvider() {
    return _instance;
  }

  static final AuthProvider _instance = new AuthProvider._internal();

  final _fetcher = new PublishSubject<bool>();

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
  }

  PublishSubject<bool> getFetcher() {
    return _fetcher;
  }

  void _isLogin() async {
    bool login = await AuthUtil.isLogin();
    _fetcher.sink.add(login);
  }

  void setLoginState(bool isLogin) {
    _fetcher.sink.add(isLogin);
  }
}
