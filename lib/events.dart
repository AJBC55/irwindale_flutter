import 'package:flutter/material.dart';
import 'package:irwindale_flutter/data_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'request.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event>? events;
  bool isLoading = true;
  bool showTimings = false;
  bool showDescription = false;
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  void _toggleTimings() {
    setState(() {
      showTimings = !showTimings;
    });
  }

  void _toggleDescription() {
    setState(() {
      showDescription = !showDescription; // Toggle the state variable
    });
  }

  Future<void> fetchEvents() async {
    try {
      final eventsRequests = Requests();
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
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator()), // Spinner while loading
      );
    }
    return Scaffold(
      body: events != null && events!.isNotEmpty
          ? ListView.builder(
              itemCount: events!.length,
              itemBuilder: (context, index) {
                final event = events![index];

                String year = event.event_start.split('-')[0];
                String month = event.event_start.split('-')[1];
                String day = event.event_start.split('-')[2];

                Map<String, String> monthMap = {
                  '01': 'January',
                  '02': 'February',
                  '03': 'March',
                  '04': 'April',
                  '05': 'May',
                  '06': 'June',
                  '07': 'July',
                  '08': 'August',
                  '09': 'September',
                  '10': 'October',
                  '11': 'November',
                  '12': 'December',
                };

                String monthName = monthMap[month]!;
                String eventStart = monthName + " " + day + ", " + year;

                List<Widget> timeWidgets = event.time.map((t) {
                  List<String> splitText =
                      t.toString().split(':'); // Split text by ":"
                  return Row(
                    children: [
                      Text(
                        splitText[0].trim() +
                            ': ', // First part of split text (before ":")
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.bold, // Bold font for text before ":"
                        ),
                      ),
                      // Text after ":"
                      Text(
                        splitText[1].trim() +
                            ":00 PM", // Second part of split text (after ":")
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight
                              .normal, // Normal font for text after ":"
                        ),
                      ),
                    ],
                  );
                }).toList(); // Convert the iterable to a list

                return Container(
                  margin: const EdgeInsets.all(10),
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
                        padding: const EdgeInsets.only(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 10), // Padding around the image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              0), // Matching rounded corners
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Border for the image
                                width: 0.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                  0), // Matching rounded corners
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
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(),
                                  Text(
                                    eventStart.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ...timeWidgets,
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (event.description.isNotEmpty)
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _toggleDescription,
                                        child: Text(showDescription
                                            ? "Read Less"
                                            : "Read More"),
                                        style: ElevatedButton.styleFrom(
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          backgroundColor: const Color.fromARGB(
                                              255, 0, 0, 0), // Button color
                                          foregroundColor:
                                              Colors.white, // Text color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Visibility(
                                visible: showDescription,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Text(
                                    event.description,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: SizedBox(
                          width: double
                              .infinity, // Make button take up the full width
                          child: ElevatedButton(
                            onPressed: () => _launchURL(event.ticket_link),
                            child: Text("Get Tickets"),
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: const Color.fromARGB(
                                  255, 0, 0, 0), // Button color
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
          : const Center(
              child: Text("No events found"), // Display if no data is available
            ),
    );
  }
}
