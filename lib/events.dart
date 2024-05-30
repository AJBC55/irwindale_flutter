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
  int skip = 0;

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
      showDescription = !showDescription;
    });
  }

  Future<void> fetchEvents({String search = "", int skip = 0}) async {
    try {
      final eventsRequests = Requests();
      final response = await eventsRequests.geteventsData(search: search, skip: skip);

      setState(() {
        if (this.skip == 0) {
          events = response;
        } else {
          events = [...events!, ...response!];
        }
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

  void _loadMore() {
    setState(() {
      skip += 10;
      isLoading = true;
    });
    fetchEvents(skip: skip);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && skip == 0) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
  title: Stack(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: TextField(
            onChanged: (value) {
              setState(() {
                String search = value;
                skip = 0;
                fetchEvents(search: search);
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search events...',
              contentPadding: EdgeInsets.symmetric(vertical: 20), // Adjust vertical padding if needed
            ),
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        child: Image.asset(
          'assets/irwindalespeedwaylogo.png',
          height: 60,
        ),
      ),
    ],
  ),
),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
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
                              t.toString().split(':');
                          return Row(
                            children: [
                              Text(
                                ' ${splitText[0].trim()}: ',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${splitText[1].trim()}:00 PM',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }).toList();

                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 0, right: 0, bottom: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 5.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
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
                                          event.name,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
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
                                                  backgroundColor: const Color.fromARGB(
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
                                  child: ElevatedButton(
                                    onPressed: () => _launchURL(event.ticket_link),
                                    child: Text("Get Tickets"),
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 0, 0, 0),
                                      foregroundColor: Colors.white,
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
                      child: Text("No events found"),
                    ),
            ),
            if (!isLoading)
              Padding(
                padding: const EdgeInsets.all(10.0),
                 child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loadMore,
                      child: const Text("Load More"),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        ),
                    ),
                 ),
              ),
            if (isLoading && skip > 0)
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}