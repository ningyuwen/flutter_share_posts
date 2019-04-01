package com.example.fluttershareposts;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    ToastProviderPlugin.register(this, getFlutterView());
//    GlideUtilPlugin.register(this, getFlutterView());
  }
}
