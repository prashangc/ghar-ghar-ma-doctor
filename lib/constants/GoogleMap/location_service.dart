import 'dart:io';

import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyAn5wsAeXtYd97DyBHgnW2DariNEfKEevQ';
  String baseURL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    print(url);
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    print('my placeId $placeId');
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key&components=country:NP';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    return results;
  }

  Future<dynamic> getAutoCompletedData(String input) async {
    String mybaseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    var resp;
    try {
      final response = await http.get(
        Uri.parse('$mybaseURL?input=$input&key=$key&components=country:NP'),
      );

      resp = convert.jsonDecode(response.body.toString())['predictions'];
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return resp;
  }

  Future<dynamic> getNearByPlacesData(lat, lng) async {
    var resp;
    try {
      final response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$key&location=$lat,$lng&radius=30'),
      );

      resp = convert.jsonDecode(response.body.toString())['results'];
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return resp;
  }
}
