import 'dart:async';

import 'package:ghargharmadoctor/api/api_imports.dart';

class ApiHandlerBloc {
  apiEndpointRepository? _apiRepository;

  StreamController<ApiResponse<dynamic>>? _apiResponseStreamController;

  StreamSink<ApiResponse<dynamic>> get apiListSink =>
      _apiResponseStreamController!.sink;

  Stream<ApiResponse<dynamic>> get apiListStream =>
      _apiResponseStreamController!.stream;

  fetchAPIList(String endpoint, {context}) async {
    _apiResponseStreamController = StreamController<ApiResponse<dynamic>>();
    _apiRepository = apiEndpointRepository();
    apiListSink.add(ApiResponse.loading('Fetching data...'));

    try {
      dynamic apiData =
          await _apiRepository!.getEndpointMethod(context, endpoint);
      apiListSink.add(ApiResponse.completed(apiData));
    } catch (e) {
      apiListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  postAPIList(context, model, String endpoint) async {
    _apiResponseStreamController = StreamController<ApiResponse<dynamic>>();
    _apiRepository = apiEndpointRepository();
    apiListSink.add(ApiResponse.loading('Fetching data...'));

    try {
      dynamic apiData =
          await _apiRepository!.postEndpointMethod(context, model, endpoint);
      apiListSink.add(ApiResponse.completed(apiData));
    } catch (e) {
      apiListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  postAPIListToReturnResp(context, model, String endpoint) async {
    _apiResponseStreamController = StreamController<ApiResponse<dynamic>>();
    _apiRepository = apiEndpointRepository();
    apiListSink.add(ApiResponse.loading('Fetching data...'));

    try {
      dynamic apiData = await _apiRepository!
          .postEndpointMethodToReturnResponse(context, model, endpoint);
      print('apiData $apiData');
      apiListSink.add(ApiResponse.completed(apiData));
      return apiData;
    } catch (e) {
      apiListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchGoogleMapAPIAutoComplete(String input) async {
    print('hit');
    _apiResponseStreamController = StreamController<ApiResponse<dynamic>>();
    _apiRepository = apiEndpointRepository();
    apiListSink.add(ApiResponse.loading('Fetching data...'));
    try {
      dynamic apiData =
          await _apiRepository!.getEndpointMethodForGoogleMap(input);
      apiListSink.add(ApiResponse.completed(apiData));
    } catch (e) {
      apiListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchGoogleMapAPINearByPlaced(double lat, double lng) async {
    _apiResponseStreamController = StreamController<ApiResponse<dynamic>>();
    _apiRepository = apiEndpointRepository();
    apiListSink.add(ApiResponse.loading('Fetching data...'));
    try {
      dynamic apiData = await _apiRepository!.nearbyPlaceInput(lat, lng);
      apiListSink.add(ApiResponse.completed(apiData));
    } catch (e) {
      apiListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _apiResponseStreamController!.close();
  }
}

// ApiHandlerBloc tripStatusBloc = ApiHandlerBloc();
