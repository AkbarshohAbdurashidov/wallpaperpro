import 'dart:typed_data';

import 'package:WallpaperPro/repo/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
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
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(122),
        ),
        tooltip: 'Press once to download current image',
        onPressed: () async {
          await ImageGallerySaver.saveImage(widget.imageUrl as Uint8List);
          repo.downloadImage(
              imageUrl: widget.imageUrl,
              imageId: widget.imageId,
              context: context);
        },
        child: Icon(Icons.download),
        backgroundColor: Color.fromARGB(110, 63, 63, 63),
        foregroundColor: Color.fromARGB(200, 255, 255, 255),
        elevation: 5.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
