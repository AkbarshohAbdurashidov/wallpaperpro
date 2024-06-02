import 'dart:ui';

import 'package:WallpaperPro/pages/main_page.dart';
import 'package:WallpaperPro/repo/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  final String imageUrl;
  final int imageId;

  const PreviewPage({
    super.key,
    required this.imageId,
    required this.imageUrl,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  Repository repo = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRRect(
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(),
                ),
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: CachedNetworkImage(
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        imageUrl: widget.imageUrl,
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
        ),
      ),
      floatingActionButton: Container(
        width: 200,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600,
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-5, -5),
                blurRadius: 15,
                spreadRadius: 1),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade200,
              Colors.grey.shade300,
              Colors.grey.shade400,
              Colors.grey.shade500,
            ],
          ),
        ),
        child: MaterialButton(
          hoverColor: Colors.black,
          onPressed: () async {
            repo.downloadImage(
                imageUrl: widget.imageUrl,
                imageId: widget.imageId,
                context: context);
          },
          child: const Icon(
            Icons.download,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
