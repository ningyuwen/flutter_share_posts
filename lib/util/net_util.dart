import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/src/codec/json.dart';
import 'package:my_mini_app/been/login_been.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

@GenApiClient(path: "user")
abstract class TestApi extends ApiClient {

  final resty.Route base;

  final JsonRepo jsonConverter;

  TestApi({this.base, this.jsonConverter});


//  @GetReq
//  Future<LoginBeen>

}
