class AMapLocation {
  double latitude;
  double longitude;
  String province;
  String coordType;
  String city;
  String district;
  String cityCode;
  String adCode;
  String address;
  String country;
  String road;
  String poiName;
  String street;
  String streetNum;
  String aoiName;
  String poiid;
  String floor;
  int errorCode;
  String errorInfo;
  String locationDetail;
  String csid;
  String description;
  int locationType;

  AMapLocation(
      {this.latitude,
      this.longitude,
      this.province,
      this.coordType,
      this.city,
      this.district,
      this.cityCode,
      this.adCode,
      this.address,
      this.country,
      this.road,
      this.poiName,
      this.street,
      this.streetNum,
      this.aoiName,
      this.poiid,
      this.floor,
      this.errorCode,
      this.errorInfo,
      this.locationDetail,
      this.csid,
      this.description,
      this.locationType});

  AMapLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    province = json['province'];
    coordType = json['coordType'];
    city = json['city'];
    district = json['district'];
    cityCode = json['cityCode'];
    adCode = json['adCode'];
    address = json['address'];
    country = json['country'];
    road = json['road'];
    poiName = json['poiName'];
    street = json['street'];
    streetNum = json['streetNum'];
    aoiName = json['aoiName'];
    poiid = json['poiid'];
    floor = json['floor'];
    errorCode = json['errorCode'];
    errorInfo = json['errorInfo'];
    locationDetail = json['locationDetail'];
    csid = json['csid'];
    description = json['description'];
    locationType = json['locationType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['province'] = this.province;
    data['coordType'] = this.coordType;
    data['city'] = this.city;
    data['district'] = this.district;
    data['cityCode'] = this.cityCode;
    data['adCode'] = this.adCode;
    data['address'] = this.address;
    data['country'] = this.country;
    data['road'] = this.road;
    data['poiName'] = this.poiName;
    data['street'] = this.street;
    data['streetNum'] = this.streetNum;
    data['aoiName'] = this.aoiName;
    data['poiid'] = this.poiid;
    data['floor'] = this.floor;
    data['errorCode'] = this.errorCode;
    data['errorInfo'] = this.errorInfo;
    data['locationDetail'] = this.locationDetail;
    data['csid'] = this.csid;
    data['description'] = this.description;
    data['locationType'] = this.locationType;
    return data;
  }
}
