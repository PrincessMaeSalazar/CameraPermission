import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:external_path/external_path.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> imagePhotoPath = <dynamic>[];
  Future? _imageGetPath;

  @override
  void initState() {
    _getPermission();
    super.initState();
    _imageGetPath = getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Image"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: _imageGetPath,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var dir = Directory(snapshot.data);
                  if (true) _fetchFiles(dir);
                  return Text(snapshot.data);
                } else {
                  return const Text("Loading Photo ... ");
                }
              },
            ),
          ),
          Expanded(
            flex: 19,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: _getListImg(imagePhotoPath),
            ),
          )
        ],
      ),
    );
  }

  void _getPermission() async {
    await Permission.storage.request().isGranted;
    setState(() {});
  }


  Future<String> getImage() {
    return ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  }

  _fetchFiles(Directory dir) {
    List<dynamic> listImage = [];
    dir.list().forEach((element) {
      RegExp regExp = RegExp(
          "(gif|jpe?g|tiff?|png|webp|bmp)", caseSensitive: false);
      if (regExp.hasMatch('$element')) listImage.add(element);
      setState(() {
        imagePhotoPath = listImage;
      });
    });
  }

  List<Widget> _getListImg(List<dynamic> listImagePath) {
    List<Widget> listImages = [];
    for (var imagePath in listImagePath) {
      listImages.add(
        Container(
          padding: const EdgeInsets.all(8),
          child: Image.file(imagePath, fit: BoxFit.cover),
        ),
      );
    }
    return listImages;
  }
}
