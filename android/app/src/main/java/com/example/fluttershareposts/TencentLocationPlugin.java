package com.example.fluttershareposts;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.util.Log;

//import com.lyokone.location.LocationPlugin;
import com.tencent.map.geolocation.TencentLocation;
import com.tencent.map.geolocation.TencentLocationListener;
import com.tencent.map.geolocation.TencentLocationManager;
import com.tencent.map.geolocation.TencentLocationRequest;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class TencentLocationPlugin implements MethodChannel.MethodCallHandler, TencentLocationListener {

    private static final String TAG = "TencentLocationPlugin";
    private static final String METHOD_CHANNEL_NAME = "aduning/tencent_location";

    private static final int REQUEST_PERMISSIONS_REQUEST_CODE = 110;
    private static final int REQUEST_CHECK_SETTINGS = 0x1;
    private static final long UPDATE_INTERVAL_IN_MILLISECONDS = 10000;
    private static final long FASTEST_UPDATE_INTERVAL_IN_MILLISECONDS = UPDATE_INTERVAL_IN_MILLISECONDS / 2;

    //腾讯地图定位manager
    private TencentLocationManager mLocationManager;

    private PluginRegistry.RequestPermissionsResultListener mPermissionsResultListener;

    private final Activity activity;

    private MethodChannel.Result result;

    public TencentLocationPlugin(Activity activity) {
        super();
        this.activity = activity;
        Log.e(TAG, "create function, activity is " + activity.getClass().getName());
        createPermissionsResultListener();
        if (checkPermissions()) {
            setPositionListener();
        }
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL_NAME);
        TencentLocationPlugin locationWithMethodChannel = new TencentLocationPlugin(registrar.activity());
        channel.setMethodCallHandler(locationWithMethodChannel);
        registrar.addRequestPermissionsResultListener(locationWithMethodChannel.getPermissionsResultListener());
    }

    private void setPositionListener() {
        Log.e(TAG, "setPositionListener");
        TencentLocationRequest request = TencentLocationRequest.create();
        request.setRequestLevel(3);
        //间隔5s
        request.setInterval(1000);
        mLocationManager = TencentLocationManager.getInstance(activity.getApplicationContext());
        mLocationManager.requestLocationUpdates(request, this);
        Log.e(TAG, "setPositionListener, mLocationManager is: " + mLocationManager.toString());
    }

    public PluginRegistry.RequestPermissionsResultListener getPermissionsResultListener() {
        return mPermissionsResultListener;
    }

    private void createPermissionsResultListener() {
        mPermissionsResultListener = new PluginRegistry.RequestPermissionsResultListener() {
            @Override
            public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
                Log.e(TAG, "onRequestPermissionsResult " + requestCode);
                if (requestCode == REQUEST_PERMISSIONS_REQUEST_CODE && permissions.length == 1 && permissions[0].equals(Manifest.permission.ACCESS_FINE_LOCATION)) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        if (result != null) {
//                            getLastLocation(result);
                            setPositionListener();
                        }
//                        else if (events != null) {
//                            getLastLocation(null);
//                        }
                    } else {
                        if (!shouldShowRequestPermissionRationale()) {
                            if (result != null) {
                                result.error("PERMISSION_DENIED_NEVER_ASK", "Location permission denied forever- please open app settings", null);
                            }
//                            } else if (events != null) {
//                                events.error("PERMISSION_DENIED_NEVER_ASK", "Location permission denied forever - please open app settings", null);
//                                events = null;
//                            }
                        } else {
                            if (result != null) {
                                result.error("PERMISSION_DENIED", "Location permission denied", null);
                            }
//                            else if (events != null) {
//                                events.error("PERMISSION_DENIED", "Location permission denied", null);
//                                events = null;
//                            }
                        }
                    }
                    return true;
                }
                return false;
            }
        };
    }

    private void getLastLocation(final MethodChannel.Result result) {
        Log.e(TAG, "getLastLocation function");
        TencentLocation location = mLocationManager.getLastKnownLocation();
        if (location == null) {
            Log.e(TAG, "get location is null, mLocationManager: " + mLocationManager.toString());
            return;
        }
        if (result == null) {
            Log.e(TAG, "result is null");
            return;
        }
        Log.e(TAG, "location get success " + location.getAddress());
        result.success(location);
    }

    private boolean shouldShowRequestPermissionRationale() {
        return ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.ACCESS_FINE_LOCATION);
    }

    @Override
    public void onLocationChanged(TencentLocation tencentLocation, int i, String s) {
        Log.i(TAG, "onLocationChanged11: " + tencentLocation.getAddress() + " " + i + " " + s);
        if (i == STATUS_DISABLED) {
//            mLocationManager.removeUpdates(this);
        }
    }

    @Override
    public void onStatusUpdate(String s, int i, String s1) {
        Log.i(TAG, "onLocationChanged22: " + s + " " + s1);
    }

    /**
     * Return the current state of the permissions needed.
     */
    private boolean checkPermissions() {
        int permissionState = ActivityCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_FINE_LOCATION);
        return permissionState == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                REQUEST_PERMISSIONS_REQUEST_CODE);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        Log.e(TAG, "onMethodCall " + methodCall.method);
        if (methodCall.method.equals("getCurrentLocation")) {
            Log.e(TAG, "getCurrentLocation");
            if (!checkPermissions()) {
                Log.e(TAG, "checkPermissions fail");
                this.result = result;
                requestPermissions();
                return;
            }
            Log.e(TAG, "checkPermissions success");
            getLastLocation(result);
        }
    }
}
