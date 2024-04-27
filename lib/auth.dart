import 'package:flutter/material.dart';
import 'package:irwindale_flutter/data_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'event_requests.dart';

// Event class definition


class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event>? events;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents(); 
  }

  Future<void> fetchEvents() async {
    try {
      final eventsRequests = EventsRequests();
      final response = await eventsRequests.geteventsData(); // Fetch data

      setState(() {
        events = response;
        isLoading = false;
      });
    } catch (err) {
      print("Error fetching events: $err");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Spinner while loading
      );
    }  
    return Scaffold(
      body: events != null && events!.isNotEmpty
          ? ListView.builder(
              itemCount: events!.length,
              itemBuilder: (context, index) {
                final event = events![index];
                List<Widget> timeWidgets = event.time.map((t) {
                  return Text(
                    t.toString(), // Convert each item to a string
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  );
                }).toList(); // Convert the iterable to a list

                return Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Black border
                      width: 2 // Border width
                    ),
                    color: Colors.grey[200], // Light grey background
                    borderRadius: BorderRadius.circular(0), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 10), // Padding around the image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0), // Matching rounded corners
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Border for the image
                                width: 0.0,
                              ),
                              borderRadius: BorderRadius.circular(0), // Matching rounded corners
                            ),
                            child: Image.network(
                              event.img_link,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.name,
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              event.event_start,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ...timeWidgets,
                            SizedBox(height: 12),
                            Text(event.description),
                          ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                        child: SizedBox(
                          width: double.infinity, // Make button take up the full width
                          child: ElevatedButton(
                            onPressed: () => _launchURL(event.ticket_link),
                            child: Text("Get Tickets"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Color.fromARGB(255, 0, 0, 0), // Button color
                              foregroundColor: Colors.white, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text("No events found"), // Display if no data is available
            ),
    );
  }
}