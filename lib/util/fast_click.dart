class FastClick {
  static int defaultTime = 300;
  static int lastClickTime = 0;

  static bool isFastClick() {
    int time = new DateTime.now().millisecondsSinceEpoch;
    if (time - lastClickTime < defaultTime) {
      return true;
    }
    lastClickTime = time;
    return false;
  }
}
