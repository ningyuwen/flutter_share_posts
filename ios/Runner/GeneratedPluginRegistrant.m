//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <amap_location/AmapLocationPlugin.h>
#import <connectivity/ConnectivityPlugin.h>
#import <flutter_qq/FlutterQqPlugin.h>
#import <fluttertoast/FluttertoastPlugin.h>
#import <image_picker/ImagePickerPlugin.h>
#import <mmkv_flutter/MmkvFlutterPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <share/SharePlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <simple_permissions/SimplePermissionsPlugin.h>
#import <sqflite/SqflitePlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AmapLocationPlugin registerWithRegistrar:[registry registrarForPlugin:@"AmapLocationPlugin"]];
  [FLTConnectivityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTConnectivityPlugin"]];
  [FlutterQqPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterQqPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [MmkvFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"MmkvFlutterPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SimplePermissionsPlugin registerWithRegistrar:[registry registrarForPlugin:@"SimplePermissionsPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
}

@end
