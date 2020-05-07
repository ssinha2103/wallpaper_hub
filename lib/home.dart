import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_hub/category.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:wallpaper_hub/image_view.dart';
import 'package:wallpaper_hub/model/wallpaper_model.dart';
import 'package:wallpaper_hub/search.dart';
import 'package:wallpaper_hub/widgets/widget.dart';
import 'package:http/http.dart' as http;

import 'model/categories_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = new List();
  List<WallPaperModel> wallPapers = new List();

  TextEditingController searchController = new TextEditingController();

  getTrendingWallpapers() async {
    var response = await http.get(
        'https://api.pexels.com/v1/curated?per_page=95&page=2',
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
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search(
                                      searchQuery: searchController.text,
                                    )));
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              myName(),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 60,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoriesTile(
                          title: categories[index].categoriesName,
                          imgUrl: categories[index].imgUrl);
                    }),
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

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;

  CategoriesTile({@required this.title, @required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Category(
                      categoryName: title.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                height: 50,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              height: 50,
              width: 100,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
