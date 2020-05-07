import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_hub/widgets/widget.dart';
import 'package:http/http.dart' as http;

import 'data/data.dart';
import 'model/wallpaper_model.dart';

class Search extends StatefulWidget {
  final String searchQuery;
  Search({this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = new TextEditingController();
  List<WallPaperModel> wallPapers = new List();

  getSearchWallpapers(String query) async {
    var response = await http.get(
        'https://api.pexels.com/v1/search?query=$query&per_page=45&page=1',
        headers: {"Authorization": apiKey});

//    print(response.body.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallPaperModel wallPaperModel = new WallPaperModel();
      wallPaperModel = WallPaperModel.fromMap(element);
      wallPapers.add(wallPaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(36),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        getSearchWallpapers(searchController.text);
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              WallPapersList(wallPapers: wallPapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}
