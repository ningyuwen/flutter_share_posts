package aduning.com.flutter_amap_plugin;

import android.util.Log;

// import com.amap.api.location.AMapLocation;
// import com.amap.api.location.AMapLocationClient;
// import com.amap.api.location.AMapLocationClientOption;
// import com.amap.api.location.AMapLocationListener;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterAmapPlugin
 */
public class FlutterAmapPlugin implements MethodCallHandler {

    // //声明AMapLocationClient类对象
    // private AMapLocationClient mLocationClient = null;
    // //声明AMapLocationClientOption对象
    // private AMapLocationClientOption mLocationOption = null;
    //
    private Registrar mRegistrar = null;

    private FlutterAmapPlugin(Registrar registrar) {
        mRegistrar = registrar;
    }

    // private AMapLocation mAMapLocation = null;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_amap_plugin");
        channel.setMethodCallHandler(new FlutterAmapPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("getPlatformVersion")) {
            showLocation(result);
            // result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }

    private void showLocation(final Result result) {
        // //初始化定位
        // mLocationClient = new AMapLocationClient(mRegistrar.context());
        // //设置定位回调监听
        // mLocationClient.setLocationListener(new AMapLocationListener() {
        //     @Override
        //     public void onLocationChanged(AMapLocation aMapLocation) {
        //         Log.e("MainActivity", "地理位置是1： " + aMapLocation.getAddress() + " 经纬度是：" +
        //                 aMapLocation.getLatitude() + " " + aMapLocation.getLongitude());
        //         Log.e("MainActivity", aMapLocation.toString());
        //         result.success("地理位置是： " + aMapLocation.getAddress());
        //     }
        // });
        //
        // //初始化AMapLocationClientOption对象
        // mLocationOption = new AMapLocationClientOption();
        // mLocationOption.setNeedAddress(true);
        // mLocationOption.setOnceLocation(true);
        //
        // mLocationClient.setLocationOption(mLocationOption);
        // mLocationClient.startLocation();
    }
}
