class LatestTrackLatLng {
  String? lon;
  String? lat;
  String? time;

  LatestTrackLatLng({this.lon, this.lat, this.time});

  LatestTrackLatLng.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
    data['time'] = time;
    return data;
  }
}
