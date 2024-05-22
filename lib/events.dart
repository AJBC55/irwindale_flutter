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

  Future<void> fetchEvents({String search = "", int skip = 0}) async {
    try {
      final eventsRequests = Requests();
      final response =
          await eventsRequests.geteventsData(search: search); // Fetch data

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
        body: Center(
          child: CircularProgressIndicator(),
        ), // Spinner while loading
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    String search = value; 
                    fetchEvents(search: search);
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search events...',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/irwindalespeedwaylogo.png',
              height: 80,
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // Set black background color
        child: events != null && events!.isNotEmpty
            ? ListView.builder(
                itemCount: events!.length,
                itemBuilder: (context, index) {
                  final event = events![index];

                  String year = event.event_start.split('-')[0];
                  String month = event.event_start.split('-')[1];
                  String day =
                      int.parse(event.event_start.split('-')[2]).toString();

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
                  String eventStart = '$monthName $day, $year';

                  List<Widget> timeWidgets = event.time.map((t) {
                    List<String> splitText =
                        t.toString().split(':'); // Split text by ":"
                    return Row(
                      children: [
                        Text(
                          ' ${splitText[0].trim()}: ',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight
                                .bold, // Bold font for text before ":"
                          ),
                        ),
                        // Text after ":"
                        Text(
                          '${splitText[1].trim()}:00 PM',
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
                      borderRadius: BorderRadius.circular(10), // Rounded corners
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
                            borderRadius: BorderRadius.circular(10), // Matching rounded corners
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[200]!, // Border for the image
                                  width: 5.0,
                                ),
                                borderRadius: BorderRadius.circular(10), // Matching rounded corners
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
                                Center(
                                  child: Text(
                                    event.name//.toUpperCase()
                                    ,textAlign:
                                        TextAlign.center, // Center align text
                                    softWrap:
                                        true, // Allow text to wrap to the next line if needed
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      //fontStyle: FontStyle.italic,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Spacer(),
                                    Text(
                                      eventStart.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                //const SizedBox(height: 12),
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
                                            backgroundColor:
                                                const Color.fromARGB(255, 0, 0,
                                                    0), // Button color
                                            foregroundColor:
                                                Colors.white, // Text color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (event.time.isNotEmpty)
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _toggleTimings,
                                          child: Text(showTimings
                                              ? "Hide Times"
                                              : "Show Times"),
                                          style: ElevatedButton.styleFrom(
                                            textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 0, 0, 0),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Visibility(
                                  visible: showTimings,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: timeWidgets,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 16, right: 16, bottom: 10),
                          child: SizedBox(
                            width: double.infinity,
                            // Make button take up the full width
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
                                  borderRadius: BorderRadius.circular(10),
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
                child:
                    Text("No events found"), // Display if no data is available
              ),
      ),
      
    );
  }
}
