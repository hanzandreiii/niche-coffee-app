import 'package:the_end/mapkey.dart';
import 'package:the_end/nearby.dart';
import 'package:the_end/geopoint.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyLocationApi {
  static NearbyLocationApi _instance = _instance;

  NearbyLocationApi._();

  static NearbyLocationApi get instance {
    _instance ??= NearbyLocationApi._();
    return _instance;
  }

  Future<List<Nearby>> getNearby(
      {required GeoPoint userLocation,
      required double radius,
      required String type,
      required String keyword}) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${userLocation.latitude},${userLocation.longitude}&radius=$radius&type=$type&keyword=$keyword&key=${MapKey.GOOGLE_MAPS_API_KEY}';
    http.Response response = await http.get(url as Uri);
    final values = jsonDecode(response.body);
    final List result = values['results'];
    print(result);
    return result.map((e) => Nearby.fromJson(e)).toList();
  }
}
