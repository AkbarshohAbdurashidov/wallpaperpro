import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:media_scanner/media_scanner.dart';

import '../model/model.dart';

class Repository {
  final String apiKey =
      "563492ad6f917000010000012c16bc9cf9f346beadb0239c617954d0";
  final String baseUrl = "https://api.pexels.com/v1/";

  Future<List<Images>> getImagesList({required int? pageNumber}) async {
    String url = "";

    if (pageNumber == null) {
      url = "${baseUrl}curated?per_page=80";
    } else {
      url = "${baseUrl}curated?per_page=80&page=$pageNumber";
    }

    List<Images> imageList = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": apiKey},
      );
      print("Response=> ${response.body.toString()}");

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        for (final json in jsonData["photos"] as Iterable) {
          final image = Images.fromJson(json);
          imageList.add(image);
        }
      }
    } catch (_) {}
    return imageList;
  }

  Future<Images> getImageById({required int id}) async {
    final url = "${baseUrl}photos/$id";
    Images image = Images.emptyConstructor();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": apiKey,
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        image = Images.fromJson(jsonData);
      }
    } catch (_) {}
    return image;
  }

  Future<List<Images>> getImagesBySearch({required String query}) async {
    final url = "${baseUrl}search?query=$query&per_page=80";
    List<Images> imageList = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": apiKey,
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);

        for (final json in jsonData["photos"] as Iterable) {
          final image = Images.fromJson(json);
          imageList.add(image);
        }
      }
    } catch (_) {}
    return imageList;
  }

  Future<void> downloadImage({
    required String imageUrl,
    required int imageId,
    required BuildContext context,
  }) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final bytes = response.bodyBytes;
        final directory = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);
        final file = File("$directory/$imageId.png");
        await file.writeAsBytes(bytes);
        MediaScanner.loadMedia(path: file.path);
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text("File's been saved at; ${file.path}"),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("File's not been saved at because:"),
            duration: Duration(seconds: 3),
          );
        }
      }
    } catch (_) {}
  }
}
