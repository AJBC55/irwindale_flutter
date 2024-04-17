import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EventsRequests{

String  geteventsUrl = "https://track-andrew-b967c8424989.herokuapp.com/events";



  Future<void> geteventsData({String search = "", int skip = 0 } ) async {

    
    String queryParams = "?search=$search&skip=$skip";
    try{
      Uri url   = Uri.parse(geteventsUrl + queryParams); 
      try{
        var  response = await http.get(url); 

        if (response.statusCode == 200){
          try{
            var  data = json.decode(response.body);


          } catch (err){
            print("error decoding json with $err ");

          }

        } else  {
          int sts_code = response.statusCode;

          print("error at status code $sts_code");

        }

       
      } catch (err){
         print(err);
      }   
      } catch (err){
        print("url error $err ");
    }

  


  }

void testRequest() {



}

}
