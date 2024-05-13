import 'dart:convert';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:http/http.dart' as http;
import 'package:irwindale_flutter/data_models.dart';

// add a banner that says please log in, set jwt token to empty string, and set value to no

class Requests {
  final String geteventsUrl =
      "https://css-backend-v1-92fa8dcd9de6.herokuapp.com/irwindale/events";
  final String userUrl =
      "https://css-backend-v1-92fa8dcd9de6.herokuapp.com/irwindale/users";
  final String loginUrl =
      "https://css-backend-v1-92fa8dcd9de6.herokuapp.com/irwindale/login";

  Future<List<Event>?> geteventsData({String search = "", int skip = 0}) async {
    String queryParams = "?search=$search&skip=$skip";
    try {
      Uri url = Uri.parse(geteventsUrl + queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Event.fromJson(e)).toList();
        } else {
          //print("Expected a list, but got something else");
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
      if (response.statusCode == 409) {
        throw "USERNAME OR EMAIL ALREADY IN USE";
      }
      // Check if the user was created successfully
      if (response.statusCode == 201) {
        // Status code 201 indicates successful creation
        var data = jsonDecode(response.body); // Decode the response body
        return UserOut.fromJson(
            data); // Return UserOut object from the decoded JSON
      } else {
        print("Error creating user. Status code: ${response.statusCode}");
        throw "Could not create user"; // Return null or throw an exception if preferred
      }
    } catch (e) {
      // Handle exceptions during the HTTP request
      print("Exception occurred while creating user: $e");
      rethrow; // Return null or rethrow the exception depending on your preference
    }
  }

  Future loginRequest(String username, String password) async {
    try {
      Uri url = Uri.parse(loginUrl);
      Map<String, String> formBody = {
        'username': username,
        'password': password,
      };

      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: formBody);
      if (response.statusCode == 401) {
        throw "UNAUTHORIZED";
      } else if (response.statusCode != 200) {
        throw "ERROR authenticating  USER";
      }
      var data = jsonDecode(response.body);
      var jsonData = TokenData.fromJson(data);
      await FlutterKeychain.put(key: "jwt_token", value: jsonData.jwt_token);
      await FlutterKeychain.put(key: "authenticated", value: "yes");
    } catch (err) {
      rethrow;
    }
  }

  //Future <List<Event>?> getsavedEvents(String username, String password){

  //}
}
