import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class EventsRequests {
  final String geteventsUrl =
      "https://track-andrew-b967c8424989.herokuapp.com/events";

  Future<List<Event>?> geteventsData({String search = "", int skip = 0}) async {
    String queryParams = "?search=$search&skip=$skip";
    try {
      Uri url = Uri.parse(geteventsUrl + queryParams);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          return data.map((e) => Event.fromJson(e)).toList();
        } else {
          print("Expected a list, but got something else");
          return null;
        }
      } else {
        print("Failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching data: $e");
      return null;
    }
  }
}
