import 'package:ghargharmadoctor/api/api.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class apiEndpointRepository {
  final API _api = API();
  final LocationService locationService = LocationService();
  Future<dynamic> getEndpointMethod(context, String endpoint) async {
    final response = await _api.getData(context, endpoint);
    return response;
  }

  Future<dynamic> postEndpointMethod(context, model, String endpoint) async {
    final response = await _api.postData(context, model, endpoint);
    return response;
  }

  Future<dynamic> postEndpointMethodToReturnResponse(
      context, model, String endpoint) async {
    final response = await _api.getPostResponseData(context, model, endpoint);
    return response;
  }

  Future<dynamic> getEndpointMethodForGoogleMap(String endpoint) async {
    final response = await locationService.getAutoCompletedData(endpoint);
    return response;
  }

  Future<dynamic> nearbyPlaceInput(double lat, double lng) async {
    final response = await locationService.getNearByPlacesData(lat, lng);
    return response;
  }
}
