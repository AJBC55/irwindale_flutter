import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:irwindale_flutter/data_models.dart';


class EventsRequests {
  final String geteventsUrl = "https://css-backend-v1-92fa8dcd9de6.herokuapp.com/irwindale/events";
  final String userUrl =  "https://css-backend-v1-92fa8dcd9de6.herokuapp.com/irwindale/users";
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


  Future<UserOut?> createUser(UserIn user_data, String userUrl) async {
    try {
      // Parse the URL from the given userUrl
      Uri url = Uri.parse(userUrl);

      // Prepare the JSON body for the POST request
      Map<String, dynamic> jsonBody = {
        'username': user_data.username,
        'email': user_data.email,
        'password': user_data.password,
        'name_first': user_data.first_name,
        'name_last': user_data.last_name,
      };

      // Send the POST request with the appropriate headers
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode(jsonBody), // Encode the body to JSON
      );

      // Check if the user was created successfully
      if (response.statusCode == 201) { // Status code 201 indicates successful creation
        var data = jsonDecode(response.body); // Decode the response body
        return UserOut.fromJson(data); // Return UserOut object from the decoded JSON
      } else {
        print("Error creating user. Status code: ${response.statusCode}");
        return null; // Return null or throw an exception if preferred
      }
    } catch (e) {
      // Handle exceptions during the HTTP request
      print("Exception occurred while creating user: $e");
      rethrow; // Return null or rethrow the exception depending on your preference
    }
  }
}


