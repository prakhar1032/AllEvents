import 'dart:convert';

import 'package:all_events/eventCategory_dataclass.dart';
import 'package:all_events/eventList_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       showCategoriesBottomSheet(context);
            //     },
            //     child: Text('data')),
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
        ),
      ),
    );
  }
}
