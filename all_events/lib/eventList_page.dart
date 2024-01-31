import 'dart:convert';

import 'package:all_events/eventCategory_dataclass.dart';
import 'package:all_events/eventResponse_data.dart';
import 'package:all_events/web_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventsList extends StatefulWidget {
  final String? CatUrl;
  final String? categoryName;

  const EventsList({super.key, this.CatUrl, this.categoryName});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  Future<EventResponse> eventListCall() async {
    final url = Uri.parse('${widget.CatUrl}');

    try {
      final response = await http.get(url);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final EventResponse eventResponse = EventResponse.fromJson(jsonMap);
        print(eventResponse.count);

        return eventResponse;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Error fetching data');
    }
  }

  @override
  void initState() {
    super.initState();
    CategoriesCall();
  }

  List<EventCategory> categories = [];

  Future<void> CategoriesCall() async {
    final response = await http.get(
        Uri.parse('https://allevents.s3.amazonaws.com/tests/categories.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      setState(() {
        categories =
            jsonList.map((json) => EventCategory.fromJson(json)).toList();
      });
      // print(categories[0].category);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void showCategoriesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: Colors.grey, thickness: 1),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the first three chips horizontally
                    Container(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            categories.length > 3 ? 3 : categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EventsList(
                                          categoryName:
                                              categories[index].category,
                                          CatUrl: categories[index].data,
                                        )));
                              },
                              child: Chip(
                                elevation: 0,
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                backgroundColor: Colors.blue,
                                shape: StadiumBorder(),
                                shadowColor: Colors.blue,
                                label: Text(
                                  categories[index].category,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Display the remaining chips below
                    Wrap(
                      spacing: 8.0,
                      children: categories.length > 3
                          ? categories.sublist(3).map((chipName) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EventsList(
                                            categoryName: chipName.category,
                                            CatUrl: chipName.data,
                                          )));
                                },
                                child: Chip(
                                  elevation: 0,
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5, bottom: 5),
                                  backgroundColor: Colors.blue,
                                  shape: StadiumBorder(),
                                  shadowColor: Colors.blue,
                                  label: Text(
                                    chipName.category,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              );
                            }).toList()
                          : [],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool isListView = true; // Variable to track view mode

  void toggleViewMode() {
    setState(() {
      isListView = !isListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.categoryName!.toUpperCase()}'),
          iconTheme: IconThemeData(
            color: Colors.blue, // Set the color you want for the back arrow
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.blue, // Set the color for the search icon
              ),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.grey[100],
        body: FutureBuilder<EventResponse>(
          future: eventListCall(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading screen while fetching data
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else if (snapshot.hasError) {
              // Show error message if there's an error
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              // Display data using ListView.builder
              final eventItems = snapshot.data!.items;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: toggleViewMode,
                        child: Row(
                          children: [
                            Icon(isListView ? Icons.view_module : Icons.list),
                            Text(isListView ? 'Grid' : 'List'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: MediaQuery.sizeOf(context).width * 0.90,
                    height: 40,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCategoriesBottomSheet(context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.category_outlined),
                                Text('Categories')
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.date_range),
                              Text('Date & Time')
                            ],
                          ),
                          Row(
                            children: [Icon(Icons.sort), Text('Sort')],
                          )
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isListView
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: eventItems.length,
                            itemBuilder: (context, index) {
                              EventItem item = eventItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => WebView(
                                                eventUrl: item.eventUrl,
                                                eventName: item.eventName)));
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      width: MediaQuery.sizeOf(context).width *
                                          0.90,
                                      height: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Image.network(
                                                "${item.thumbUrl}",
                                                height: 120,
                                                width: 120,
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.5,
                                                    child: Text(
                                                      "${item.eventName}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${item.label}",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.5,
                                                    child: Text(
                                                      "${item.location}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    height: 35,
                                                    width: 35,
                                                    child: Center(
                                                      child: Icon(Icons
                                                          .star_rate_outlined),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    height: 35,
                                                    width: 35,
                                                    child: Center(
                                                      child: Icon(
                                                          Icons.share_outlined),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Set the number of columns in grid view
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.3),
                            ),
                            itemCount: eventItems.length,
                            itemBuilder: (context, index) {
                              EventItem item = eventItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => WebView(
                                                eventUrl: item.eventUrl,
                                                eventName: item.eventName)));
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      width: MediaQuery.sizeOf(context).width *
                                          0.4,
                                      height: 300,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Image.network(
                                                "${item.thumbUrl}",
                                                // height: 120,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.5,
                                              )),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.5,
                                                  child: Text(
                                                    "${item.eventName}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(
                                                  "${item.label}",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.5,
                                                  child: Text(
                                                    "${item.location}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                height: 35,
                                                width: 35,
                                                child: Center(
                                                  child: Icon(
                                                      Icons.star_rate_outlined),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                height: 35,
                                                width: 35,
                                                child: Center(
                                                  child: Icon(
                                                      Icons.share_outlined),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              );
            } else {
              // Show a default message if none of the above conditions are met
              return Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    );
  }
}
