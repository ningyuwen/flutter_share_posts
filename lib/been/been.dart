
class Been<T> {
  var code;
  var message;
  T data;


  Been(this.code, this.message, this.data);

  Been.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'],
        data = json['data'];

  Map<String, dynamic> toJson() =>
      {
        'code': code,
        'message': message,
        'data': data
      };

}