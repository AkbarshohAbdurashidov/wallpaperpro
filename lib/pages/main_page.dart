import 'dart:ui';

import 'package:WallpaperPro/model/model.dart';
import 'package:WallpaperPro/pages/preview_page.dart';
import 'package:WallpaperPro/repo/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

const backroundColor = Color.fromARGB(100, 63, 63, 63);

class _MainPageState extends State<MainPage> {
  TextEditingController textEditingController = TextEditingController();
  late Future<List<Images>> imagesList;
  final ScrollController scrollController = ScrollController();
  final Repository repo = Repository();
  int pageNumber = 1;
  final List<String> categoriesList = [
    "Nature",
    "Abstract",
    "Technology",
    "Mountains",
    "Cars",
    "Bikes",
    "People",
  ];

  void getImagesBySearch({required String query}) {
    imagesList = repo.getImagesBySearch(query: query);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    imagesList = repo.getImagesList(pageNumber: pageNumber);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backroundColor,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 200,
              sigmaY: 200,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(100, 63, 63, 63).withAlpha(200),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Wallpaper",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "Pro",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<Images>>(
              future: imagesList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.white),
                            contentPadding: const EdgeInsets.only(left: 25),
                            labelText: "Type here to search",
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.yellow, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: IconButton(
                                onPressed: () {
                                  getImagesBySearch(
                                    query: textEditingController.text,
                                  );
                                },
                                icon: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          controller: textEditingController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9]'),
                            ),
                            FilteringTextInputFormatter.deny(
                              RegExp('sex'),
                            )
                          ],
                          onSubmitted: (value) {
                            getImagesBySearch(query: value);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categoriesList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                getImagesBySearch(
                                  query: categoriesList[index],
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    child: Center(
                                      child: Text(
                                        categoriesList[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: MasonryGridView.count(
                          controller: scrollController,
                          itemCount: snapshot.data?.length,
                          shrinkWrap: true,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            double height = (index % 10 + 1) * 100;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PreviewPage(
                                      imageId: snapshot.data![index].imageId,
                                      imageUrl: snapshot
                                          .data![index].imagePotraitPath,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: height > 300 ? 300 : height,
                                  imageUrl:
                                      snapshot.data![index].imagePotraitPath,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 3),
                      SafeArea(
                        child: MaterialButton(
                          minWidth: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            pageNumber++;
                            imagesList =
                                repo.getImagesList(pageNumber: pageNumber);
                            setState(() {});
                          },
                          child: const Text("Load more."),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}